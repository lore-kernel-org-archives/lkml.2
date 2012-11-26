Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2KZQne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:43:34 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40950 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2KZQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
In-Reply-To: <50AF4584.7020604@ti.com>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com>
Date: Mon, 26 Nov 2012 15:46:00 +0000
Message-Id: <20121126154600.765E03E1AFD@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 10:44:36 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Grant,
> 
> On 11/23/2012 10:13 AM, Peter Ujfalusi wrote:
> > Hi Grant,
> > 
> > On 11/23/2012 08:55 AM, Grant Likely wrote:
> >> Ugh. and this is why I wanted the PWM and GPIO subsystems to use the
> >> same namespace and binding. <grumble, mutter> But that's not your fault.
> >>
> >> It's pretty horrible to have a separate translator node to convert a PWM
> >> into a GPIO (with output only of course). The gpio properties should
> >> appear directly in the PWM node itself and the translation code should
> >> be in either the pwm or the gpio core. I don't think it should look like
> >> a separate device.
> > 
> > Let me see if I understand your suggestion correctly. In the DT you suggest
> > something like this:
> > 
> > twl_pwmled: pwmled {
> > 	compatible = "ti,twl4030-pwmled";
> > 	#pwm-cells = <2>;
> > 	#gpio-cells = <2>;
> > 	gpio-controller;
> > };
> 
> After I thought about this.. Is this what we really want?
> After all what we have here is a PWM generator used to emulate a GPIO signal.
> The PWM itself can be used for driving a LED (standard LED or backlight and we
> have DT bindings for these already), vibra motor, or other things.
> If we combine the PWM with GPIO we should go and 'bloat' the DT node to also
> include all sort of other uses of PWM at once?
> 
> IMHO it is better to keep them as separate things.
> pwm node to describe the PWM generator,
> separate nodes to describe it's uses like led, backlight, motor and gpio.

You're effectively asking the pwm layer to behave like a gpio (which
is completely reasonable). Having a completely separate translation node
really doesn't make sense because it is entirely a software construct.
In fact, the way your using it is *entirely* to make the Linux driver
model instantiate the translation code. It has *nothing* to do with the
structure of the hardware. It makes complete sense that if a PWM is
going to be used as a GPIO, then the PWM node should conform to the GPIO
binding.

g.
