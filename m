Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0H3WoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:44:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55833 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab0H3WoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A0x2cEXvu/P0CJfjk4EyWDE9bpoJIAc/vQ6qedJxQIHsOgwdEKD4qTtWKfcTPvCQr1
         unLw0dbZ9J2xi/ffo7OlqzXv6rOb3+xy6Rd7cgmO83ncpExoB3i6+W7T+TMuW15ygeCX
         DoJoO4iCbZC02FngCL2r/Ms0EgNbvh8lGv55M=
Date: Mon, 30 Aug 2010 15:43:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Felipe Balbi <me@felipebalbi.com>,
        Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
Message-ID: <20100830224352.GF28865@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 03:05:32PM -0700, Linus Torvalds wrote:
> On Monday, August 30, 2010, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >
> > That is why I started taking accelerometers in. But I am concerned that
> > taking accelerometers (which indeed are most often input devices) will
> > lead people to try and use the same for temperature, ALS and other
> > sensors that are more often used in industrial process controls.
> 
> You're just being silly.
> 
> Nobody writes a driver for a "temperature sensor" or "ambient light
> sensor". They write a driver for a specific *chip* that is used in
> cellphones etc, and that happens to have an ambient light and
> temperature sensor on it.

And? Yes, they have a ALS and temperature sensors. They also have
voltage regulators, pwm, ADC and a bunch of other stuff wired on. You
are not arguing that all of those should be input devices just because
they happen to reside on the same chip?

> 
> And in that context, it really does make sense to see it as an input
> driver. And the fact that there are industrial uses for ALS sensors
> that aren't necessarily at all interested on the input layer should
> not matter at all.

I think it does matter; we should have standard interface for certain
functionality that makes sense for everyone. So far cellphone guys
wanted to plumb such devices through input not necessarily because these
are HID events but because:

1. Input transport via evdev is very convenient
2. There is no other standard alternative

Once there is standard interface for such sensors they will happily use
it and will not look back.

> 
> So don't bring up "ALS isn't always input" because within the context
> of a driver for some highly integrated cellphone model, it really IS
> input, and there is no ambiguity at all.
> 
> So your "sometimes it is, and sometimes it isn't" argument is bogus.
> The ambiguity simply doesn't exist when seen in context.

Sure, for a particular cell phone there is no ambiguity, the sensor has
certain functionality assigned that is well known. But does this mean
that we should not expect parts being reused at all anymore?

> 
> >> (or GPS device, for that matter) really be?
> >
> > But why GPS should be input device? It has nothing to do with user
> > input.
> 
> What? OF COURSE it is an input driver. It's the user moving the device
> around. It's EXACTLY the same thing as an accelerometer in that
> respect. Sure, it's a bit less precise and measures movement wrt some
> external frame, but technically they are almost exactly the same.
> 
> If you se doing a navigation app, the accelerometer, the compass and
> the GPS are all equally (but differently) important.
> 
> Again - it's not a user touching buttons. But it IS a user moving around.

Right, but do you expect that movement to cause an immediate action?
When you press a key - something happens; when you swing a Wii
controller - the device reacts. And really you can swap joysticks,
motion controllers, Sony's 6-axis and so forth and the application would
be hard pressed to tell the difference. I am unsure how you would play a
game with GPS as an input device.

-- 
Dmitry
