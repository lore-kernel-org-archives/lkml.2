Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab0HaFP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:15:26 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60982 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0HaFPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:15:24 -0400
MIME-Version: 1.0
Date: Tue, 31 Aug 2010 00:15:11 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Hemanth V <hemanthv@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <igor.stoppa@nokia.com>,
        <kai.svahn@nokia.com>, <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
In-Reply-To: <20100830224352.GF28865@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com> <20100830214025.2f9677a1@lxorguk.ukuu.org.uk> <20100830204412.GA28711@core.coreip.homeip.net> <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com> <20100830214355.GB28865@core.coreip.homeip.net> <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com> <20100830224352.GF28865@core.coreip.homeip.net>
Message-ID: <43fd040585e2eca4416f7619eba86515@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 30 Aug 2010 15:43:52 -0700, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Aug 30, 2010 at 03:05:32PM -0700, Linus Torvalds wrote:
>> On Monday, August 30, 2010, Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> wrote:
>> >
>> > That is why I started taking accelerometers in. But I am concerned
that
>> > taking accelerometers (which indeed are most often input devices)
will
>> > lead people to try and use the same for temperature, ALS and other
>> > sensors that are more often used in industrial process controls.
>> 
>> You're just being silly.
>> 
>> Nobody writes a driver for a "temperature sensor" or "ambient light
>> sensor". They write a driver for a specific *chip* that is used in
>> cellphones etc, and that happens to have an ambient light and
>> temperature sensor on it.
> 
> And? Yes, they have a ALS and temperature sensors. They also have
> voltage regulators, pwm, ADC and a bunch of other stuff wired on. You
> are not arguing that all of those should be input devices just because
> they happen to reside on the same chip?
> 
>> 
>> And in that context, it really does make sense to see it as an input
>> driver. And the fact that there are industrial uses for ALS sensors
>> that aren't necessarily at all interested on the input layer should
>> not matter at all.
> 
> I think it does matter; we should have standard interface for certain
> functionality that makes sense for everyone. So far cellphone guys
> wanted to plumb such devices through input not necessarily because these
> are HID events but because:
> 
> 1. Input transport via evdev is very convenient
> 2. There is no other standard alternative
> 
> Once there is standard interface for such sensors they will happily use
> it and will not look back.

I disagree. If the device is used as input and currently
app developers have to find other ways to use such input
data, having a standard interface other than input layer
will just make the mess standardized, but it will still
be a mess.

>> So don't bring up "ALS isn't always input" because within the context
>> of a driver for some highly integrated cellphone model, it really IS
>> input, and there is no ambiguity at all.
>> 
>> So your "sometimes it is, and sometimes it isn't" argument is bogus.
>> The ambiguity simply doesn't exist when seen in context.
> 
> Sure, for a particular cell phone there is no ambiguity, the sensor has
> certain functionality assigned that is well known. But does this mean
> that we should not expect parts being reused at all anymore?

Why are we trying to overengineer on such simple devices ? Wasn't
it so that we will design and implement solutions when the problem
arrives ? Why are we trying to think of all cases such a simple
device might be used just for the sake of not being input device ?

>> >> (or GPS device, for that matter) really be?
>> >
>> > But why GPS should be input device? It has nothing to do with user
>> > input.
>> 
>> What? OF COURSE it is an input driver. It's the user moving the device
>> around. It's EXACTLY the same thing as an accelerometer in that
>> respect. Sure, it's a bit less precise and measures movement wrt some
>> external frame, but technically they are almost exactly the same.
>> 
>> If you se doing a navigation app, the accelerometer, the compass and
>> the GPS are all equally (but differently) important.
>> 
>> Again - it's not a user touching buttons. But it IS a user moving
around.
> 
> Right, but do you expect that movement to cause an immediate action?
> When you press a key - something happens; when you swing a Wii
> controller - the device reacts. And really you can swap joysticks,
> motion controllers, Sony's 6-axis and so forth and the application would
> be hard pressed to tell the difference. I am unsure how you would play a
> game with GPS as an input device.

it might not be used on a game, but on a map application, that IS input.
You're failing to see input devices are used in cases other than gaming.

-- 
balbi
