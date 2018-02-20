# Zhancheng Qian, February 2018

# Modified from Felix Hageloh 's Pretty Weather widget
# Made possible with DarkSky API (darksky.net/dev)
apiKey: '' # put your forcast.io api key inside the quotes here

refreshFrequency: 600000

style: """
  bottom: 45%
  left: 10%
  margin: 0 0 0 -100px
  font-family: Berlin, Helvetica Neue
  color: #fff

  @font-face
    font-family Weather

  .temp
    text-align: center
    font-size: 30px
    font-weight: 250
    color: rgba(#fff, 0.9)
    margin-top: 0px
    max-width: 1000px
    line-height: 2

  .summary
    text-align: center
    font-size: 15px
    font-weight: 400
    color: rgba(#fff, 0.9)
    margin-top: -10px
    max-width: 1000px
    line-height: 2
"""

command: "echo {}"

render: (o) -> """
  <div class='temp'></div>
  <div class='summary'></div>
"""

afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @command   = @makeCommand(@apiKey, "#{lat},#{lon}")
    @refresh()


makeCommand: (apiKey, location) ->
  exclude  = "minutely,hourly,alerts,flags"
  "curl -sS 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=auto&exclude=#{exclude}'"

update: (output, domEl) ->
  data  = JSON.parse(output)
  today = data.daily?.data[0]
  return unless today?
  date  = @getDate today.time
  $(domEl).find('.temp').prop 'textContent', Math.round((today.temperatureMax-30)/2)+" degrees right now" #'°'
  $(domEl).find('.summary').text today.summary

getDate: (utcTime) ->
  date  = new Date(0)
  date.setUTCSeconds(utcTime)
  date
