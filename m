Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0F0TyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 15:54:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754762Ab0F0TyJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 15:54:09 -0400
Subject: Re: [PATCH v3 1/4] hwmon: Driver for SMM665 Six-Channel Active DC Output Controller/Monitor
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100627151047.GA5731@ericsson.com> (sfid-20100627_161157_396817_8F10F51C)
Date: Sun, 27 Jun 2010 20:54:06 +0100
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <52840892-BE40-44D3-9454-407B074481CC@opensource.wolfsonmicro.com>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com> <1277416861-32494-2-git-send-email-guenter.roeck@ericsson.com> <20100627102058.GB2845@sirena.org.uk> <20100627151047.GA5731@ericsson.com> (sfid-20100627_161157_396817_8F10F51C)
To: Guenter Roeck <guenter.roeck@ericsson.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jun 2010, at 16:10, Guenter Roeck wrote:

> On Sun, Jun 27, 2010 at 06:20:59AM -0400, Mark Brown wrote:

>> A bit late to the game here but this looks like the chip has some
>> regulator control functionality as well as monitoring functionality (and
>> the product page on the Summit web site suggests so also).  This means
>> that when fully supported in software the driver would cross multiple
>> subsystems so it might make sense to start off with a MFD rather than
>> direct I2C control?  
>> 
>> If the non-monitoring functionality can't be controlled from software
>> this isn't an issue.
> 
> I thought about that when I started working on the driver, but concluded that 
> it does not really make sense.
> 
> The chip is commonly used to control all supply voltages on a board.
> Changing those voltages is not a good idea. For that reason, the chip can be 

There's rather a lot of systems out there doing DVFS or using things like MMC
cards which would disagree with the idea that it's a bad idea to change supply
voltages at runtime. Even for fixed voltage supplies enabling and disabling at
runtime is useful to save power. I think it's fair to say that the overall trend is
towards more dynamic power management.

> set into read-only mode, where changing the voltages is no longer possible
> after initial programming.

This tends to be done through paranoia more than anything else - people get
very worried about things like accidental writes to their PMICs.

> While it is theoretically possible that someone might use the device to control
> not only fixed but also dynamic voltages, I think that is highly unlikely, given
> the risk involved in blowing up the board. Thus, moving the driver to mfd would 
> effectively serve no real purpose other than to cause confusion and add unnecessary

Pretty much any current generation CPU can use dynamic voltage configuration
for DVFS.