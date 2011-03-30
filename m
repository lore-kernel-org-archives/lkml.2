Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab1C3Ulr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:41:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:63060 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1C3Ulq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:41:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 30 Mar 2011 16:41:45 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Linus Torvalds wrote:

> ARM right now i a nightmare, and most of it is because ARM hardware
> manufacturers are morons.

If in your mind "competitors" == "morons" then you might be right.

> But the way the ARM tree is then laid out
> has made that even more painful, and the decision to put all the crazy
> board details in the kernel tables instead of trying to have a
> per-board boot loader that fills in the details is just crazy.

I beg to disagree.

Trying to rely on bootloaders doing things right is like saying that x86 
should always rely on the BIOS doing things right.  We have this chance 
in the OMAP case to have a manufacturer who is smart enough to document 
all those things so that the kernel can be autonomous and more reliable, 
and the BIOS joke avoided entirely. When something needs fixing it is 
much easier to update the kernel ourselves than waiting after any 
bootloader updates which are themselves much more risky to perform.

Granted, things could be structured in a better way so to minimize the 
risk of conflicts when clocks for unrelated drivers are updated at the 
same time.  Something like initcall tables or the like.

> Look at the dirstat for arch/ in just the current merge window
> (cut-off at 5% just to not get too much):
> 
> [torvalds@i5 linux]$ git diff -C --dirstat=5 --cumulative v2.6.38.. arch
>   14.0% arch/arm/mach-omap2/
>    5.8% arch/arm/plat-mxc/include/mach/
>    6.3% arch/arm/plat-mxc/
>   57.1% arch/arm/
>    5.4% arch/m68k/
>    9.6% arch/unicore32/
>    6.9% arch/x86/
>  100.0% arch/
> 
> almost *SIXTY* percent of all arch updates were to ARM code.

Absolutely not!  You have 14% going to OMAP code which happens to be 
under arch/arm/ but there is nothing ARM specific in there.  If OMAP was 
using a PPC or a MIPS core then you'd have the same result except under 
arch/powerpc or arch/mips.  There is very little in terms of ARM 
specific peculiarities under arch/arm/mach-omap2/ in fact.

And it happens that, after all the beating we've made on those embedded 
(ARM) SOC manufacturers, trying to push the point home that it is far 
better for everyone to have support merged in the mainline kernel 
instead of keeping their patches piled up into an obsolete kernel 
version, it happens that the OMAP folks are the top champions when it's 
time to upstream their code.  Are we going to complain to them now that 
they're doing exactly what the upstream kernel community people have 
been asking of them for so many years?

> And that's despite the fact that one of those architectures 
> (unicore32) is a totally new architecture, and despite m68k having 
> gone through a first-level unification of nommu and mmu code!

So what?  That only shows that those architectures are not being used as 
much as ARM is.  This is probably just a reflect of actual market share.

> And was this just a fluke? No. Doing the same for 2.3.37..38 gives
> 58.3% for arch/arm (and in that release we had a blackfin unification
> effort, otherwise arm would have been an even bigger percentage).

And don't be surprised if the dirstat result for arch/arm/ goes up even 
further in the near future.  Other SOC manufacturers which happen to 
have chosen an ARM core for their CPU are also coming out of their 
moronic stupor and waking up to speed with this Open Source thing.  If 
they were choosing a MIPS core this could rebalance the dirstat, but 
they happen to also have an ARM core with a _completely_ different 
architecture around it since that's what they compete over.  If ARM Ltd 
was to dictate everything composing the ARM architecture like what 
happened on X86 then you'd end up with a much lower level of competition 
and innovation.

If that means doing someting similar to "git mv arch/arm/mach-omap2 
arch/omap2" for the dirstat to be more meaningful then let's do it.  But 
I think that a different interpretation of the one you did would be more 
appropriate here.

> That's ridiculous. It's entirely due to the whole f*cked-up arm ecosystem.

Well, let's face it, ARM is at the moment highly successful.  And yes it 
might be destabilizing as ARM might be surpassing the X86 kernel 
development rate while X86 always used to be the ultimate reference.  
But calling the whole ecosystem "f*cked-up" because we have issue 
scaling to it properly is a rather cheap argument.

> Something needs to be done. A small part is to make sure the source
> code is more hierarchical, so that we don't have those crazy shared
> data-files that are ugly as hell and get conflicts because different
> boards all think they need to care.

Absolutely!

> But the larger problem is that somebody really REALLY needs to think
> about how to get those crazy board details out of the kernel entirely.
> Having per-board drivers for real hardware is sane - having to have
> per-board detail files for clock chips is just crazy. Split off that
> thing a "Linux ARM second-stage bootloader" project that has the
> per-board tables or something. Don't pollute the main kernel with
> crazy details like this.

There is on-going work to bring device tree support to ARM.  Maybe that 
will be the way to go to move those clock details out of the kernel.  
And maybe that will become another unfixable PC BIOS fiasco. We'll see.  
I don't particularly like the idea of _more_ APIs between bootloaders 
and the kernel.  Keeping everything fixable in only one place is way 
more convenient than the burden of the occasional merge conflict.

Sure, something has to be done to minimize the pain, your pain, but not 
by increasing the pain elsewhere.  I think that you know pretty well 
already how painful dealing with BIOS data, or ACPI, or any other vendor 
controlled (sometimes closed source) config tables might be.  We've 
sidestepped that pain entirely on ARM so far and that really feels good.


Nicolas
