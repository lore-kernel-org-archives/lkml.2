Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1CaDRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:17:50 -0400
Received: from relais.videotron.ca ([24.201.245.36]:53719 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1CaDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:17:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 30 Mar 2011 23:17:47 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
Message-id: <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, david@lang.hm wrote:

> On Wed, 30 Mar 2011, Nicolas Pitre wrote:
> 
> > Furthermore, this does create pain.  you have to make things in sync
> > between the kernel and the mini-kernel (let's call it bootloader).  In
> > practice the bootloader is always maintained separately from the kernel,
> > on its own pace and with its own release schedule.  Trying to
> > synchronize independent projects is really painful as you know already,
> > otherwise the user space for perf would still be maintained separately
> > from the kernel, right?
> 
> Being separate from the kernel with it's own release schedule could be a good
> thing.

It could.  It didn't work well for oprofile.  That's why perf was 
included in the kernel tree which so far appears to be a success.

> using the example of clocks. if the clock definitions were in the bootloader
> project, then when a new board is produced with a slightly different clock
> arrangement, all you have to do is to update the bootloader to pass the new
> definition to the kernel, and then you can use a well tested kernel that has
> been put through it's paces on other hardware already.

Sure.  And that's the perfect case.  I've yet to see things work so 
well in practice.

> Today you have to get the change upstream into the kernel, and then use the
> new kernel (which always includes new features and bugs that you have to test
> for)

No.  Today you have to get the change working in the current stable 
kernel locally and test it before you submit it upstream.

> the two pieces do not need to be released and updated in lockstep. yes, there
> will be (many) cases where a new kernel adds support for a new type of device,
> but the communications format between the bootloader and the kernel can be
> designed to be tolorant of such skew. Even before the kernel knows how to
> drive the hardware you can have the format of the information about that
> hardware defined (allowing the bootloader to pass information to the kernel
> that it just ignores because it doesn't have a driver in it for that
> particulare piece of hardware), and if the bootloader doesn't tell the kernel
> about some device, the kernel will just ignore that device.

Today we have no such communication format with its limitations and 
compatibility issues to care about.  That allows for much greater 
flexibility just as the kernel internal APIs are not guaranteed to be 
stable.  The major drawback is a lack of forward compatibility meaning 
that for every new piece of hardware to come you need a kernel update.  
There is simply no magic solution.

> this means that you need to have some group doing the equivalent of assigning
> device numbers for the different devices (and in this case going just a little
> further to define what setup parameters will be needed), initially this may be
> a little rough, but after a very short time I would expect the people doing
> this work to start recognising that even though vendor A who first proposes
> this device has some things hard-wired, the definition format should support
> these things as variables instead of being assumed.

Ideally, yes.  but if every vendor has a different set of peripherals, 
and from one SOC revision to the next from the same vendor you still 
have different hardware knobs, then you still have to add yet more code 
to the kernel.  And that doesn't solve the issue of dynamic clock and 
power management at runtime either for which custom code is still 
required.

As long as SOC vendors keep producing wildly different architectures 
besides the core CPU we'll have this problem.  Denying the reality won't 
make that problem go away either.  And device tree won't stop those 
vendor from still trying to do things differently (better?) because they 
are not constrained by having to ensure this single proprietary software 
stack still boot.


Nicolas
