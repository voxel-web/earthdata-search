# -*- coding: utf-8 -*-
# EDSC-137: As a user, I want an introductory tour when I visit the site so I
#           may quickly get oriented in the system

require "spec_helper"

# Resetting here because the tour introduces very complex page state that's not easy to back out of
describe "Site tour", reset: true do

  context "on the landing page" do
    before :each do
      visit "/"
      wait_for_xhr
    end

    # Single spec for the tour which tests every stop.  Normally I'd like this to be separate tests per stop, but
    # doing so is slow and highly redundant because the tour is so serial.
    it "shows an introductory tour walking the user through finding and visualizing data and adding it to a project" do
      expect(page).to have_popover('Welcome to Earthdata Search')
      click_on 'Next »'

      expect(page).to have_popover('Keyword Search')
      fill_in 'keywords', with: 'snow cover nrt'
      click_on 'Browse All Data'

      expect(page).to have_popover('Browse Datasets')
      find(".facets-item", text: "Terra").click

      expect(page).to have_popover('Spatial Search')
      create_bounding_box(0, 0, 10, 10)

      expect(page).to have_popover('Dataset Results')
      second_dataset_result.click

      expect(page).to have_popover('Matching Granules')
      second_granule_list_item.click

      expect(page).to have_popover('Map View')
      click_on 'Next »'

      expect(page).to have_popover('Granule Timeline')
      find('.timeline-zoom-in').click

      expect(page).to have_popover('Back to Datasets')
      granule_list.click_on 'Back to Datasets'

      expect(page).to have_popover('Comparing Multiple Datasets')
      second_dataset_result.find('.add-to-project').click

      expect(page).to have_popover('Projects')
      click_on 'View Project'

      expect(page).to have_popover('Project (cont.)')
    end

    context 'clicking on the tour\'s "Close" button' do
      before :each do
        click_on 'Close'
      end

      it 'closes the tour' do
        expect(page).to have_no_popover
      end
    end

    context "starting the tour and searching for terms other than those prompted by the tour" do
      before :each do
        click_on 'Next »'
        expect(page).to have_popover
        fill_in "keywords", with: "AST_L1A"
        click_on 'Browse All Data'
      end

      it "hides the tour" do
        expect(page).to have_no_popover
      end
    end

    context "starting a search without starting the tour" do
      before :each do
        click_on 'Browse All Data'
      end

      it "hides the tour" do
        expect(page).to have_no_popover
      end
    end
  end

  context "directly loading the search page" do
    before :each do
      visit "/search"
    end

    it "shows no tour" do
      expect(page).to have_no_popover
    end
  end
end