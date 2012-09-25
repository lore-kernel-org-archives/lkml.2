Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2IYWYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:24:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49666 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2IYWYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:24:21 -0400
Date: Wed, 26 Sep 2012 00:24:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
Cc: linux-kernel@vger.kernel.org, peter@piie.net
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
Message-ID: <20120925222417.GA31780@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
	linux-kernel@vger.kernel.org, peter@piie.net
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
 <CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
 <20120925090151.GB1247@liondog.tnic>
 <CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Peter.

On Tue, Sep 25, 2012 at 12:41:11PM +0300, Tero Keski-Valkama wrote:
> 2012/9/25 Borislav Petkov <bp@alien8.de>:
> > On Tue, Sep 25, 2012 at 10:34:13AM +0300, Tero Keski-Valkama wrote:
> >
> > But before we go with this any further: you mentioned some issues still
> > with acerhdf - you don't want to turn off your fan but to turn it to
> > full?
> >
> > I think in this case, you want to simply not load the driver and use the
> > BIOS settings, no?
> >
> > --
> > Regards/Gruss,
> >     Boris.
> 
> Technically I think my original issue is about thermal zones, and BIOS
> control doesn't solve it as is. However, the patch should be valid,
> even if it doesn't solve my original issue.
> 
> The thing is that passive cooling thermal zones throttle all the cores
> to stone age, to 800 MHz, before the fan even really starts powering
> up from the low default level.

I don't understand: you want the thermal zones to not throttle your cpu
to 800 Mhz and/or the fan to start sooner?

> So, my original problem would be solved
> by:
> a) Direct control of the fan, to be able to put it on full for example
> through userspace control,

That's always a bad idea, especially if userspace dies on you.

> b) Changing the active cooling thermal zones, so that the fan speeds
> up earlier, or

Ok, I see, here's what you want.

> c) Changing the passive cooling (CPU throttling) thermal zones, so
> that it doesn't prevent fan from speeding up in the first place.
> 
> At the moment, I don't see any way to change the thermal zones through
> existing interfaces for this laptop, and I don't see any potential
> thermal zone controls, or manual fan control option in the Embedded
> Controller registry.

I'll let Peter have a look at the patch too.

@Peter, it is at: http://lkml.org/lkml/2012/9/25/92

Btw, the commit message starts with "x86:... " and it should be
"acerhdf:.. " Peter, please change that when handling the patch further.

Also, you've added yourself to the copyright - this means that you're
pretty much going to get all future email about acerhdf. Do you really
want that?

-- 
Regards/Gruss,
    Boris.
