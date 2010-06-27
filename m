Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0F0PMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:12:08 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53128 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab0F0PMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:12:06 -0400
Date: Sun, 27 Jun 2010 08:10:47 -0700
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
Message-ID: <20100627151047.GA5731@ericsson.com>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
 <1277416861-32494-2-git-send-email-guenter.roeck@ericsson.com>
 <20100627102058.GB2845@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100627102058.GB2845@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 06:20:59AM -0400, Mark Brown wrote:
> On Thu, Jun 24, 2010 at 03:00:58PM -0700, Guenter Roeck wrote:
> > This driver adds support for the monitoring features of the Summit
> > Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.
> 
> A bit late to the game here but this looks like the chip has some
> regulator control functionality as well as monitoring functionality (and
> the product page on the Summit web site suggests so also).  This means
> that when fully supported in software the driver would cross multiple
> subsystems so it might make sense to start off with a MFD rather than
> direct I2C control?  
> 
> If the non-monitoring functionality can't be controlled from software
> this isn't an issue.

I thought about that when I started working on the driver, but concluded that 
it does not really make sense.

The chip is commonly used to control all supply voltages on a board.
Changing those voltages is not a good idea. For that reason, the chip can be 
set into read-only mode, where changing the voltages is no longer possible
after initial programming.

While it is theoretically possible that someone might use the device to control
not only fixed but also dynamic voltages, I think that is highly unlikely, given
the risk involved in blowing up the board. Thus, moving the driver to mfd would 
effectively serve no real purpose other than to cause confusion and add unnecessary
complexity.

Guenter
