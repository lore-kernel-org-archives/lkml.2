Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1LHWwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:52:40 -0500
Received: from pip.mess.org ([212.110.186.137]:41951 "EHLO pip.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab1LHWwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:52:37 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 17:52:37 EST
Date: Thu, 8 Dec 2011 22:43:23 +0000
From: Sean Young <sean@mess.org>
To: simon@mungewell.org
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-input@vger.kernel.org,
        rdunlap@xenotime.net, linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
Message-ID: <20111208224323.GA29342@pip.mess.org>
References: <4EDFD23D.4030703@xenotime.net>
 <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
 <b92a2d1d30910b75f3354926d9fa26f6.squirrel@host171.canaca.com>
 <CANq1E4T6uoezonoaBk6agD4-6A7QMSiP0ySDPg+5r50G8LYWTA@mail.gmail.com>
 <80063840e8a9778675e9a63db6f1d956.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80063840e8a9778675e9a63db6f1d956.squirrel@host171.canaca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 11:23:26AM -0500, simon@mungewell.org wrote:
> 
> >> I don't mean to be a complainer, but shouldn't the WiiMote module depend
> >> on FF_MEMLESS rather than just forcing it on.
> > > > I have considered that but "grep -r FF_MEMLESS" returned no other
> > driver using "depend" so I decided to use "select", too.
> 
> If you look at 'Kconfig' every other driver is fragmented into a 'driver'
> and 'driver_ff', it is only the 'driver_ff' bit which does the
> force-feedback and all the 'drivers' would appear to work OK (as pure
> input devices) with FF disabled.

Which also requires these drivers to have #ifdef's in their code, they
would be much cleaner without those.

> Someone here will be able to comment whether that is policy, convention or
> just historic....
> 
> >> Some people might not want FF_MEMLESS enabled.
> >
> > Why? It is a really small feature that depends only on CONFIG_INPUT.
> > Just 600 lines of code. I don't see why someone who wants to enable
> > the way bigger wiimote driver and HID core would bother about
> > FF_MEMLESS? Why should someone want to disable the rumble-feature of
> > the wiimote?
> 
> 600 lines where? What's the other costs to the system when enabling the FF
> code in the kernel.

There is just ff-memless.c which will be compiled into a module (unless 
not configured to so of of course), which is less than 600 lines including 
comments. Nothing else changes.

The fact that these drivers can be built without force feedback enabled 
is an analomy. If every feature a piece of hardware provides were 
configurable with #ifdef's, the code would not be very maintainable.

> > I cannot see any real use-case here. Maybe you can explain a bit more.
> 
> Again I'm not here to kick up a fuss; it just looked different from the
> norm, so I was flagging it.

I guess once upon time people considered force feedback not useful enough
to compile in.

I'm hoping that patches for removing the CONFIG_*_FF #ifdefs would be 
accepted.


Sean
