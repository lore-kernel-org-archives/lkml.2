Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2KSK6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:58:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2KSK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:58:05 -0500
Date: Mon, 19 Nov 2012 11:57:59 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED
 configuration
Message-ID: <20121119105759.GU10369@pengutronix.de>
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
 <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
 <50A9F335.80107@ti.com>
 <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:49:54 up 149 days,  2:01, 106 users,  load average: 0.59, 1.57,
 2.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:40:30AM +0100, Linus Walleij wrote:
> On Mon, Nov 19, 2012 at 9:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
> > I was actually tempted to remove the whole LED (PWM) thing from the
> > gpio-twl4030 driver. It was a big surprise to me to see something like this in
> > there.
> 
> It looks wrong. In theory I think this should be ripped out and moved to
> drivers/leds/leds-twl4030.c. But that would only be in case it was *always*
> exclusively used for a LED and as you say:
> 
> > It turns out that on BeagleBoard the USB host enable signal is connected to
> > LEDA (PWMA) of twl4030... It is an enable signal. Seriously. So what we do
> > here is either configure the PWMs as full on, or turn it off.
> 
> Sounds like some hardware engineer has been having fun or was
> just out of GPIOs to use... So this LED PWM is also used as a
> GPIO.
> 
> I think this part of the driver should be moved to
> drivers/pwm/pwm-twl4030.c and modeled as a PWM. If some
> platform need to use the PWM as if it was a GPIO then that's just a
> special usecase. (Setting duty cycles to something like
> INT_MAX and just switching polarity to toggle it...)
> 
> If it needs to be used by a LED there needs to be some generic
> LED type just using a standard pwm_request() to get some
> specific PWM, such as leds/leds-pwm.c or so. This way the
> PWM can be used for LEDs if need be or other things...

Either I'm misinterpreting you or you didn't have a look in the tree.
Actually drivers/leds/leds-pwm.c already exists.

> 
> Sounds correct, Sascha?

Yes, the twl4030 pwm should go to drivers/pwm/pwm-twl4030.c.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
