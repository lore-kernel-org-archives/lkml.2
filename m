Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259Ab2KWHzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:55:49 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59264 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181Ab2KWHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:55:47 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
In-Reply-To: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
Date: Fri, 23 Nov 2012 07:55:37 +0000
Message-Id: <20121123075537.A14713E0A91@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 14:42:03 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> There seams to be board designs using PWM generators as enable/disable signals.
> For these boards we used to have custom code as hacks to deal with such a
> situations.
> With the gpio-pwm driver we can emulate the GPIO functionality using PWM
> generators via standard interfaces. The PWM will be configured to be off
> when the GPIO is off and to full duty cycle when the GPIO is requested to be
> on.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi Linus,
> 
> So this is the driver I came up regarding to the issue that some boards
> (BeagleBoard for example) are using the PWM generators as enable/disable signal.
> 
> On BeagleBoard the situation is like this:
> TWL4030 PWMA -> TWL4030 LEDA -> nUSBHOST_PWR_EN -> external power switch -> USB
> host hub power.
> 
> So I have tested this driver on BeagleBoard:
> - Custom code to toggle the GPIO just to see if it switches correctly
> 
> - Real life usecase:
> fixed voltage regulator with GPIO control (the gpio is the gpio-pwm provided).
> ehci-omap has been modified to allow deferred probe.
> the regulator is used by ehci-omap.
> 
> All works fine.

Ugh. and this is why I wanted the PWM and GPIO subsystems to use the
same namespace and binding. <grumble, mutter> But that's not your fault.

It's pretty horrible to have a separate translator node to convert a PWM
into a GPIO (with output only of course). The gpio properties should
appear directly in the PWM node itself and the translation code should
be in either the pwm or the gpio core. I don't think it should look like
a separate device.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
