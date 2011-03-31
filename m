Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab1CaKMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:12:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:59774 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab1CaKMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:12:07 -0400
Date: Thu, 31 Mar 2011 12:11:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nico@fluxnic.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <alpine.LFD.2.00.1103302319290.28032@xanadu.home>
Message-ID: <alpine.LFD.2.00.1103310928240.22418@localhost6.localdomain6>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110331001502.GB6680@n2100.arm.linux.org.uk> <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com> <alpine.LFD.2.00.1103302319290.28032@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Thu, 31 Mar 2011, Nicolas Pitre wrote:
> On Wed, 30 Mar 2011, Linus Torvalds wrote:
> > And ARM fanbois can say "oh, but arm is special" all they want, but
> > they need to realize that the lack of common platform for ARM is a
> > real major issue. It's not a "feature", and I'm sorry, but anybody who
> > calls x86 "peanuts" is a moron and should be ashamed of himself.
> > Instead of trying to feel superior, those people should feel like
> > pariah.
> 
> Oh come on.  You just provided actual numbers above showing that ARM is 
> simply fscked up (your words) compared to X86.  I would be curious to 
> know what people like tglx who did significant work on both 
> architectures actually think of X86 relative to ARM when it comes to 
> kernel maintenance.

To be honest both suck in their own way. The only reason why x86 is
slightly less horrible is the fact that it's better architectured at
the hardware level.

But I see the same mess coming in with all those wonderful Atom based
SoCs on the horizon, which are nothing else than any other random ARM
SoC, just that they glue an x86 core into the same cheepo random IP
peripherals conglomerate. In fact some of those chip have been ARM
powered before they got an x86 injected.

And worse: the Intel folks went there and wrote a new driver for an IP
block which had already an "ARM associated" driver.

So I say that it is not only an ARM problem, it's a general problem
that people do not realize that the IP cores are reused all over the
place and across architectures.

I'm pretty sure after I went through all the irq code recently that
lots of those ARM SoCs from vendors across the board could share a lot
of driver code if someone would actually sit down and analyse the
situation. Right now we have nobody who has the time and the stomach
to go through this and at the same time prevent that more copied
crappola is hitting the tree.

I'm sure that device tree is part of the solution, but that only helps
if we find a way to prevent duplicate drivers in the first place.

Thanks,

	tglx
