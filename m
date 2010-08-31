Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0HaSZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:25:41 -0400
Received: from iabervon.org ([66.92.72.58]:52036 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0HaSZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:25:40 -0400
Date: Tue, 31 Aug 2010 14:18:47 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Felipe Balbi <me@felipebalbi.com>,
        Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
In-Reply-To: <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1008311303480.14365@iabervon.org>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com> <20100830214025.2f9677a1@lxorguk.ukuu.org.uk> <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Linus Torvalds wrote:

> On Monday, August 30, 2010, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >
> > But do you believe that input should be the "primary residence" for the
> > devices when they are only _sometimes_ used as input devices? Or it
> > would make sense to employ a converter from XXX to input (either purely
> > in-kernel or userspace over uinput)?
> 
> Umm... You've brought that up before as an objection, but what _is_
> that other model that you would convert from? IOW what *is* that XXX
> that you talk about?
> 
> So I think accelerometers etc should be seen as input devices for the
> simple reason that
> 
>  (a) They really *are* input devices in all the most common cases. If
> you have a phone with an accelerometer, it really is used as an input
> device quite like a joystick.

At least some of the time, an accelerometer is more like part of a 
joystick. You can have phones with accelerometers at both ends, where the 
input events produced depend on the combination of the readings, with each 
of the individual accelerometers being a device that is also available by 
itself. You can have phones which can be used in various orientations, 
where the logical "left" direction depends on the orientation. With a 
joystick, the device that the driver is for has the assignment of motions 
to inputs; for an accelerometer in a phone, the assignment is outside the 
scope of the chip, and it would make sense to have a second driver that 
takes non-chip-specific accelerometer output (per-accelerometer, per-axis) 
and maps it to input events based on how the user holds the box the chip 
is in.

It's like having a whole bunch of button devices; you want them to be 
exposed as a keyboard, and the sensor hardware reports press and release, 
but something else is needed to know which hardware button is which key. 
Similarly, you want to know about how the user is moving the device, and 
you may need to process various sorts of raw data to produce anything 
meaningful to applications.

	-Daniel
*This .sig left intentionally blank*
