Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0FCUeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:34:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24898 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0FCUeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:34:21 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_vqDZSRjHbv32lFVIwBrJsg)"
Date: Thu, 03 Jun 2010 16:34:20 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-reply-to: <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
Message-id: <alpine.LFD.2.00.1006031624450.24526@xanadu.home>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
 <20100603194559.GF25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_vqDZSRjHbv32lFVIwBrJsg)
Content-type: TEXT/PLAIN; charset=ISO-8859-15
Content-transfer-encoding: 8BIT

On Thu, 3 Jun 2010, Linus Torvalds wrote:

> 
> 
> On Thu, 3 Jun 2010, Russell King wrote:
> > 
> > I already covered that in my (ignored) email where I brought up a
> > "STD_CONFIG" config symbol, which could be disabled to turn off all
> > these additional "select"s.
> 
> I apparently haven't explained myself enough, because what you keep on 
> harping on is not something I consider acceptable.
> 
> STD_CONFIG is pointless. It's pointless because the solution to what 
> you call STD_CONFIG would be to just NOT USING the special Kconfig.xyz 
> file at all.

Linus, I think somehow you and Russell are talking past each other.

I must admit I don't exactly understand what your suggestion is all 
about.  But I however think that Russell's suggestion makes tons of 
sense.  Care to elaborate on what you dislike about it?

What is this Kconfig.xyz you're talking about?  How different is it 
from, say, arch/arm/mach-pxa/Kconfig?  If you look into that file, 
you'll find a bunch of select's which are fundamentally needed for the 
given targets to boot.  This file could be augmented with more 
conditional select's 
à la STD_CONFIG as Russell is advocating to actually provide defaults 
for the drivers that those targets should have by default.


Nicolas
> So when I suggest special Kconfig files, they are meant to just generate 
> the templates - ie they'd _generate_ what is currently the defconfig 
> files. You wouldn't _have_ to use them at all.

Sure.  a standard "make config" would still produce that .defconfig as 
usual.  Only that you'd have to turn STD_CONFIG off to be offered the 
choice of enabling/disabling those drivers which are enabled by default 
otherwise, just like the "make foo_defconfig" is doing now.


Nicolas

--Boundary_(ID_vqDZSRjHbv32lFVIwBrJsg)--
