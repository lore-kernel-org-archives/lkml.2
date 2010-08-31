Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0HaQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:17:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab0HaQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q45aKTSylrZjy2JWM2Vq6yUbng6dywsXpIGJA6GL4G9EgoZdK8BFb/Job+gE6R+nMZ
         GXMrAZ7bJ5IMiue0Tbie1Y5LuYx70uRJsqNA3dOPpyzgeq4B+7kMsnFk8iYzigHD+FUl
         cIcAmuPje1FbvMfDdVyDyUZEfRmA7cX/idly0=
Date: Tue, 31 Aug 2010 09:17:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
Message-ID: <20100831161730.GA30947@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
 <20100830224352.GF28865@core.coreip.homeip.net>
 <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:44:46AM +0100, Alan Cox wrote:
> > 1. Input transport via evdev is very convenient
> > 2. There is no other standard alternative
> > 
> > Once there is standard interface for such sensors they will happily use
> > it and will not look back.
> 
> I think the fact that most of the interest in IIO is "how do we make an
> IIO/Input bridge" speaks volumes.

Like Jonathan mentioned, we so far only hear from mobile users here on
LKML.

> 
> > Sure, for a particular cell phone there is no ambiguity, the sensor has
> > certain functionality assigned that is well known. But does this mean
> > that we should not expect parts being reused at all anymore?
> 
> If non-input uses later need non-input interfaces they can switch to that
> with an input bridge when there is one and when it happens, which
> probably won't.

Would there even be an argument which subsystem to use if IIO->input
bridge existed today? Because if the answer is "no" then push into input
is driven by convenience and not because it is the right solution. 

> 
> > I am unsure how you would play a game with GPS as an input device.
> 
> In a non-game context take a look at things like the British Museum
> application that allows you to view wherever you are and as it was long
> ago by fishing out a relevant photograph as you walk around.

If application does take something as an input it does not make it
necessarily a human interface device. By this reasoning cameras should
be represented as an input devices (why, some applications take input
from it), hwmon should be input as well (detect your move from
Arkhangelsk to Cairo by changes in your chassis temperature while under
the same load?). Serial ports? Input. Sound - speech recognition should
be implemented as an input device converting microphone input directly
into EV_KEY/KEY_x stream bypassing sound subsystem completely? And if
someone decides to use it differently - why, let's just write a second
driver. This way is madness.

I really believe that input should represent purely human interface
devices, not arbitrary data acquisition devices.

> In a game
> context can I suggest the Zombies game is an example ?

I am not familiar with this game, sorry.

-- 
Dmitry
