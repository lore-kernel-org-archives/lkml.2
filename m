Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab1CaTZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:25:32 -0400
Received: from relais.videotron.ca ([24.201.245.36]:26095 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab1CaTZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:25:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 31 Mar 2011 15:25:27 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103311429590.28032@xanadu.home>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk>
 <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Linus Torvalds wrote:

> What I'm _not_ seeing is a lot of cross-platform maintenance or sense
> of people trying to reign things in and look for solutions to the
> proliferation of random stupid and mindless platform code.

I do that, Russell does that, Catalin does that, Tony does that, and 
maybe less than a handful of other important people I'm not listing 
(sorry).  But clearly we are far far from being enough people doing that 
kind of work.  And the fact is that the volume of ARM platform code is 
steadily being produced at a rate far surpassing X86, and even higher 
than all the other architectures put together.  Linaro is trying to help 
here, but Linaro cannot conjure the needed experience and knowledge for 
that kind of work with a magic wand.

So we need help!  If core kernel people could get off their X86 stool 
and get down in the ARM mud to help sort out this mess that would be 
really nice (thanks tglx).  Until then all that the few of us can do is 
to contain the flood and hope for the best, and so far things being as 
they are have still worked surprisingly well in practice for users.  If 
compensation is a concern then I think Linaro might be able to arrange 
something.

And we can't count on vendor people doing this work.  They are all busy 
porting the kernel to their next SOC version so they can win the next 
big Android hardware design, and doing so with our kernel quality 
standards is already quite a struggle for them.

What is going on at the moment is some effort to introduce DT support to 
ARM.  The core support is there, but that is useless until platform code 
is moved to it, and corresponding work is put into bootloaders, etc.  
That is progressing... slowly.

Also there is some work to be able to build a kernel supporting more 
than one SOC family at once.  Of course there is no practical use for a 
single kernel binary that boots on all existing boards, but moving 
towards such a goal has beneficial side effects such as good 
consolidation when possible.

But we also need some slack wrt number of lines changed.  An increased 
consolidation effort will create more churn not less, at least for a 
while.  The OMAP clock merge conflict was the result of some cleanup 
which will make further consolidation easier.


Nicolas
