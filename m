Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0F0WIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 18:08:43 -0400
Received: from imr1.ericy.com ([198.24.6.9]:43809 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0F0WIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 18:08:39 -0400
Date: Sun, 27 Jun 2010 15:07:09 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: Driver for SMM665 Six-Channel Active DC
 Output Controller/Monitor
Message-ID: <20100627220709.GA7072@ericsson.com>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
 <1277416861-32494-2-git-send-email-guenter.roeck@ericsson.com>
 <20100627102058.GB2845@sirena.org.uk>
 <20100627151047.GA5731@ericsson.com>
 <52840892-BE40-44D3-9454-407B074481CC@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52840892-BE40-44D3-9454-407B074481CC@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 03:54:06PM -0400, Mark Brown wrote:
> On 27 Jun 2010, at 16:10, Guenter Roeck wrote:
> 
> > On Sun, Jun 27, 2010 at 06:20:59AM -0400, Mark Brown wrote:
> 
> >> A bit late to the game here but this looks like the chip has some
> >> regulator control functionality as well as monitoring functionality (and
> >> the product page on the Summit web site suggests so also).  This means
> >> that when fully supported in software the driver would cross multiple
> >> subsystems so it might make sense to start off with a MFD rather than
> >> direct I2C control?  
> >> 
> >> If the non-monitoring functionality can't be controlled from software
> >> this isn't an issue.
> > 
> > I thought about that when I started working on the driver, but concluded that 
> > it does not really make sense.
> > 
> > The chip is commonly used to control all supply voltages on a board.
> > Changing those voltages is not a good idea. For that reason, the chip can be 
> 
> There's rather a lot of systems out there doing DVFS or using things like MMC
> cards which would disagree with the idea that it's a bad idea to change supply
> voltages at runtime. Even for fixed voltage supplies enabling and disabling at
> runtime is useful to save power. I think it's fair to say that the overall trend is
> towards more dynamic power management.
> 
> > set into read-only mode, where changing the voltages is no longer possible
> > after initial programming.
> 
> This tends to be done through paranoia more than anything else - people get
> very worried about things like accidental writes to their PMICs.
> 
Ok, I'll accept that.

Even then, I think it would make more sense to stick with the current approach.
If someone wants to extend the driver at some point in the future to support
regulator functionality, it would be straightforward to create the necessary
mfd framework for the chip at that time. After all, the hwmon driver and with it
most of the current code would still be required.

> > While it is theoretically possible that someone might use the device to control
> > not only fixed but also dynamic voltages, I think that is highly unlikely, given
> > the risk involved in blowing up the board. Thus, moving the driver to mfd would 
> > effectively serve no real purpose other than to cause confusion and add unnecessary
> 
> Pretty much any current generation CPU can use dynamic voltage configuration
> for DVFS.
