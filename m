Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab1CaRXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:23:34 -0400
Received: from mail.lang.hm ([64.81.33.126]:59909 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1CaRXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:23:33 -0400
Date: Thu, 31 Mar 2011 10:22:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110331105000.GC14323@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1103310904080.29543@asgard.lang.hm>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk>
 <20110331105000.GC14323@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Russell King - ARM Linux wrote:

> On Thu, Mar 31, 2011 at 10:54:40AM +0100, Alan Cox wrote:
>> If I boot it on a current PC I'm booting on a multiprocessor system with
>> different timers, totally different IRQ controllers, different keyboard
>> controllers (USB), PCI Express, an IOMMU, NCQ SATA, ACPI, graphics
>> running in shared host memory able to give/take pages from the host,
>> extra instructions, etc etc
>>
>> And the same kernel boots just fine on both just fine.
>
> We've been there for a long time with ARM.  Right from the start I had
> a single kernel image which booted over a range of ARM CPUs and
> platforms.
>
> As far as ARM CPU architectures go, today we can have a single kernel
> image which covers ARMv3 to ARMv5, and a separate kernel image which
> covers ARMv6 to ARMv7 including SMP and UP variants.  The thing which
> currently stops ARMv3 to ARMv7 all together is the different page table
> layouts, the ASID tagging, the exclusive load/store support for cmpxchg
> and other atomic operations, etc.

I don't think the push is to get a single kernel image that boots 
absolutly everywhere. having separate ARM5 and ARM7 kernels doesn't seem 
to be a big deal to anyone.

> Outside of the CPU architecture, things become a lot more complicated.

exactly, and this is where there is an issue.

> The biggest one up until this merge window was that there is no fixed
> address for system RAM, which makes stuff like virt_to_phys() rather
> horrible to deal with - which in turn makes setting up and walking page
> tables a nightmare.  We've just solved that issue with run-time patching
> of the kernel code to replace the add/sub instructions with ones with
> the appropriate offset, so we're a step closer to unifying everything
> into one single kernel image.  This work alone produced this diffstat:
>
> 87 files changed, 450 insertions(+), 190 deletions(-)
>
> so it actually resulted in a net increase in the amount of code to be
> maintained rather than reducing it.  That's hardly surprising as what
> that replaced was just a bunch of #define's for PHYS_OFFSET with some
> complex assembly code to do run-time patching of instructions.

but I don't think this sort of work is what anyone is complaining about.

> Given this thread, I've lost the motivation to continue with it because
> it's just going to cause more 'pointless churn' and end up annoying
> Linus even more.

it sounds like you are part of the solution, not part of the problem. the 
biggest problem is the general response from 'the ARM community' when 
these sorts of issues are raised claiming that there is no problem. you 
seem to be very aware of the problem and are working to fix it. that is a 
very different situaion.

David Lang

