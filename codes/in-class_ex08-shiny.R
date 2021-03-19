##### first, load libraries ####
library(shiny)
library(tidyverse)

## read data in##
exam <- read_csv('data/Exam_data.csv')

##################################
#User interface
#################################

ui <- fluidPage(
  titlePanel('Pupils Examination Results Dashboard'),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'variable', 
                  label = 'Subject', 
                  choices = c("English" = 'ENGLISH',
                              "Maths" = 'MATHS',
                              "Science" = 'SCIENCE'), 
                  selected = 'ENGLISH'),
      sliderInput(inputId = "bin", 
                  label = "Number of bins", 
                  min = 5, 
                  max = 20, 
                  value = 10),
      checkboxInput(inputId = 'show_data', 
                    label = "Show data table",
                    value = TRUE)
      ),
    mainPanel(
      plotOutput('distPlot'),
      DT::dataTableOutput(outputId ='examtable')
    )
  )
)


##################################
#server function
#################################

server <- function(input,output){
  output$distPlot <- renderPlot({
    x <- unlist(exam[,input$variable])
    
    ggplot(exam, aes(x)) +
      geom_histogram(bins = input$bin,
                     color = 'black',
                     fill = 'light blue') +
      xlab(input$variable)
  })
  
  output$examtable <- DT::renderDataTable({
    if(input$show_data){
      DT::datatable(data = exam %>% select(1:7),
                    options=list(pageLength = 10),
                    rownames = FALSE)
    }
  })
}



##################################
#shinyapp - must be last line
#################################
shinyApp(ui = ui, server = server)