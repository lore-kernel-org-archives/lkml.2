Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2IYI4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:56:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:27359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab2IYI4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:56:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="212546353"
Date: Tue, 25 Sep 2012 10:55:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: linux-kernel@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH] mfd: viperboard driver added
Message-ID: <20120925085559.GL28670@sortiz-mobl>
References: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de>
 <20120919152957.GF28670@sortiz-mobl>
 <86c9848e77fa42b6c48ba0703ebf637f@atlantis.wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c9848e77fa42b6c48ba0703ebf637f@atlantis.wh2.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Sep 24, 2012 at 06:46:19PM +0200, Lars Poeschel wrote:
> Hi Samuel,
> 
> Thanks for your review.
> 
> Am 19.09.2012 17:29, schrieb Samuel Ortiz:
> >Hi Lars,
> >
> >On Mon, Aug 27, 2012 at 03:08:38PM +0200, larsi@wh2.tu-dresden.de
> >wrote:
> >>From: Lars Poeschel <poeschel@lemonage.de>
> >>
> >>First version of the driver for Nano River Tech's
> >>viperboard added.
> >>It supports i2c, adc, gpio a and gpio b. spi and pwm on
> >>the first gpio a pins is not supported yet.
> >>
> >>Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> >>---
> >> drivers/mfd/Kconfig      |   17 +
> >> drivers/mfd/Makefile     |    1 +
> >> drivers/mfd/viperboard.c | 1084
> >>++++++++++++++++++++++++++++++++++++++++++++++
> >> 3 files changed, 1102 insertions(+)
> >> create mode 100644 drivers/mfd/viperboard.c
> >So the MFD driver contains a GPIO one, and an i2c bus driver.
> >You should really split this code into at least 3 pieces: 1 for
> >the GPIO
> >(drivers/gpio), another one for your i2c bus algorithm
> >(drivers/i2c/busses)
> >and a last one for the actual MFD driver. Your Kconfig entries
> >will define the
> >dependencies between them.
> >Then you can define your SoC subdevices as MFD cells and use the
> >MFD APIs to
> >add them as platform devices.
> 
> I am not really sure, but maybe you got mislead by the term
> "viperboard". It is NOT an embedded evaluation board or starterkit.
> It is an USB to SPI, I2C, GPIO and ADC interface. You can get a
> quick overview here: http://nanorivertech.com/viperboard.html
> The I2C, GPIO or ADC parts of this driver will never be part of a
> "platform device" in terms of the linux kernel definining the
> configuration of different embedded evaluation boards (a platform).
Well, that's something none of us know for sure :)
We've seen various IPs re-used across several devices in the past, which is
why we're keen on separating the various drivers.
Also, from an architectural point of view, it makes more sense and is cleaner
imho.


> Do you still think I should split up the different parts into their
> respective subsystems in the kernel and have one "core" combining
> those parts in MFD ?
Yes, I do.


> If so, I will do this. As there would be multiple different
> maintainers involved, against which branch has my patch to be ?
Most of your sub devices (GPIO, I2C, ADC) will be depending on the MFD one (as
in Kconfig dependency), so it's safe to send each driver to the specific sub
system maintainer and expect him/her to take it. We usually figure that out
once the patchset is ready for upstream inclusion.


> Should I simply CC the patch to all involved maintainers ?
It's better yes. Even though a maintainer typically cares about 1 or 2 patches
out of the whole patchset, they usually prefer to be able to get the whole
picture and understand where you want to go with this submission.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
