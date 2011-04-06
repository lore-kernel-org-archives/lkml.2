Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1DFMYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:24:35 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54782 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1DFMYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:24:34 -0400
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 08:24:33 EDT
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
In-Reply-To: <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110405163338.GA11832@n2100.arm.linux.org.uk>
	 <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 04:52:18 -0700
Message-ID: <1302090738.22904.8.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 22:24 +0200, Uwe Kleine-König wrote:
> This function makes a deep copy of the platform data to allow it to live
> in init memory.
> The definition cannot go into leds-gpio.c because it needs to be builtin
> to be usable by platforms.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> changes since v1:
>  - don't add __init to the declaration of gpio_led_register_device
> 
>  drivers/leds/led-core.c |   27 ++++++++++++++++++++++++++-
>  include/linux/leds.h    |   12 ++++++++++++
>  2 files changed, 38 insertions(+), 1 deletions(-)

Can you explain the reasoning for this a little further please? It
sounds like instead of leaving the platform data in memory (which is
reasonable since we need it), we're now adding code to make a copy of
this data so we can remove the original. Why?

I have a rather strong dislike of adding "always builtin" functions as
they suggest something is wrong with the approach. led-core.c has always
been intentionally as minimal as we could get it.

In times when things like boot time are important it also seems like bad
form to be copying data around just so we can throw one copy away during
the boot process. What memory savings (which I assume is the
motivation?) is this giving us at what cost?

I guess the motivation might be that if a given platform has many
different LED configurations, you're trying to remove the ones you don't
need from memory? Given all the above I'd suggest that this function
should really be added to the platform device code if anywhere and
doesn't belong in the LED subsystem as its not an LED specific problem.

Cheers,

Richard

-- 
Linux Foundation
http://www.yoctoproject.org/

