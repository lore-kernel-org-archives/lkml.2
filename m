Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0H3VoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:44:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57361 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab0H3VoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p89AcsON+jlWC94ZAgTWMYPFdS/pPLpVdXIW/iLYokcbOkd2WpcJ0z9VqiLwCncD2S
         2/kjU6EXYpOhCfTY9JvkAOSFWvskmKO7f8vIj2BHqoOFdpU3xnlQURT6HzhIzAYhd6V4
         B8RG+60hLO9daia9+YIbk3FoKnrd4lmofIliQ=
Date: Mon, 30 Aug 2010 14:43:56 -0700
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
Message-ID: <20100830214355.GB28865@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 02:28:37PM -0700, Linus Torvalds wrote:
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

IIO which is currently in staging.

> So I think accelerometers etc should be seen as input devices for the
> simple reason that
> 
>  (a) They really *are* input devices in all the most common cases. If
> you have a phone with an accelerometer, it really is used as an input
> device quite like a joystick.
> 
> The fact that there are specialized and rare cases where people may
> have some fancier accelerometer that isn't necessarily seen that way,
> and where it is used for some fancy scientific experiment or whatever
> doesn't change this in *any* way. The common case that almost
> everybody cares about - and that is getting more common - is the
> simple and obvious input case.
> 
> How is a Wii accelerometer in any way different from a joystick? How
> is a phone accelerometer any different from one? The answer is clear:
> they aren't different! So it makes 100% sense to expose them under the
> same subsystem.
> 
> (b) You cannot even name your XXX thing. It clearly makes sense (at

I can - see above.

> least within Tue context of a driver for some embedded phone chip) to
> see it as an input device. And nothing else comes to mind. You'd have
> to expose it as some random character device and then everybody would
> just have to make it emulate an input device in user space anyway.
> What's the point of that?
> 
> None. That's what the point is.
> 
> So I really don't understand why you're fighting the input device
> angle. It makes sense as an input device. It does NOT make sense as
> anything else.
> 
> Really - what else could a phone accelerometer

That is why I started taking accelerometers in. But I am concerned that
taking accelerometers (which indeed are most often input devices) will
lead people to try and use the same for temperature, ALS and other
sensors that are more often used in industrial process controls.

> (or GPS device, for that matter) really be?

But why GPS should be input device? It has nothing to do with user
input.

> It very much is about user input - even if it
> isn't a keyboard.

-- 
Dmitry
