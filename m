Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1DFNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:39:27 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55310 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab1DFNj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:39:26 -0400
Subject: Re: [PATCH v2] leds: provide helper to register "leds-gpio" devices
From: Richard Purdie <rpurdie@rpsys.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de
In-Reply-To: <20110406123310.GD13963@pengutronix.de>
References: <20110405163338.GA11832@n2100.arm.linux.org.uk>
	 <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1302090738.22904.8.camel@rex>  <20110406123310.GD13963@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 06:38:17 -0700
Message-ID: <1302097097.22904.41.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 14:33 +0200, Uwe Kleine-König wrote:
> On Wed, Apr 06, 2011 at 04:52:18AM -0700, Richard Purdie wrote:
> > I guess the motivation might be that if a given platform has many
> > different LED configurations, you're trying to remove the ones you don't
> > need from memory? Given all the above I'd suggest that this function
> > should really be added to the platform device code if anywhere and
> "platform device code" means e.g. arch/arm/plat-mxc or drivers/base
> here?

Yes.

> > doesn't belong in the LED subsystem as its not an LED specific problem.
> yeap, that's it. Note that this thread[1] started on the linux-arm-kernel
> mailing list with a imx-specific version of this function. With the
> background of Linus' recent rant against churn in arch/arm several
> people pointed out that this can better go to a more generic place where
> not only arm/imx, but also arm/omap and even powerpc can use the same
> code. So the (IMHO) obvious place to put the code is near the driver.
> 
> And yes, the problem is not LED specific, but a function that creates
> and registers a leds-gpio device *is* LED specific. A while back I
> thought about introducing something like drivers/register/*, but I'm
> sure this won't scale. Either you need a header per device type (or at
> subsystem) or a single header. Both look ugly in my eyes. Having the
> prototype in include/linux/leds.h seems the right thing, because
> platform code needs to include that anyhow to provide a struct
> gpio_led_platform_data.
> 
> I don't consider something wrong here, because the Linux device model
> requires that you have a driver and a device. Both have to match and the
> device (usually) is created at boot time. Because of the needed match
> it's natural to have device use (aka driver) and device creation at the
> same place. Because of the boot time thing the code needs to be
> built-in.

It should only be built-in on platforms that both use leds-gpio and want
to use this function at boot time. This is not the description of
leds-core.c.

I understand the issue and the desire to move it into common code, I
think that is good but I don't think you've found the most appropriate
place yet.

I'm tempted to suggest making the function a static inline in leds.h (or
create an leds-gpio.h and move the struct definition there too).

Cheers,

Richard
-- 
Linux Foundation
http://www.yoctoproject.org/

