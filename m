Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1CaHPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:15:45 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44722 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab1CaHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:15:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 31 Mar 2011 03:15:42 -0400 (EDT)
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
In-reply-to: <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
Message-id: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, david@lang.hm wrote:

> On Wed, 30 Mar 2011, Nicolas Pitre wrote:
> 
> > As long as SOC vendors keep producing wildly different architectures
> > besides the core CPU we'll have this problem.  Denying the reality won't
> > make that problem go away either.  And device tree won't stop those
> > vendor from still trying to do things differently (better?) because they
> > are not constrained by having to ensure this single proprietary software
> > stack still boot.
> 
> the thing that you are not convincing us of is that all these different SoCs
> are so wildly different architectures.

You can have a look at the code.  It is all there.  And the different 
GPIO controllers are just the tip of the iceberg.  But by all means if 
you actually find a way to abstract most differences between those SOCs 
then please say so.  Many people tried already.  Maybe they weren't 
smart enough.

> back in the early days of the PCs, different systems from different vendors
> had different bus types, peripherals at different addresses, etc. that didn't
> make all of those vendors systems different architectures, instead those
> things were varients of the x86 architecture.

Most of them didn't survive.  That really helps.

> with ARM you do have a couple different architectures (arm5 vs arm7 for
> example),

That's the easy part.  Well not necessarily that easy, but RMK did a 
damn good job of it and looking at the result you may think that was 
easy.

> but what you are hearing people say is that
> 
> arm7+IPblock1+IPblock2
> arm7+IPblock1+IPblock3>
> arm7+IPblock2+IPblock3>
> 
> are not three different architectures, they are one architecture with
> different devices attached.
> 
> what's more, you seem to be saying that
> 
> arm7+IPblock1
> 
> and
> 
> arm7+IPblock1
> 
> are different architectures if the wiring between the arm core and IPblock1
> are different (they are different 'boards' or different chip models, possibly
> from different manufacturers)

That's again the easy part.  If that was all that simple we would be all 
happy campers.

> I see the variations here as a good thing, just like having a huge number of
> pluggable cards in a PC was a good thing (even though it made it hard to have
> an OS that supports every card out there)

What we have here is more like a large number of PCs, each one with a 
different set of cards.  The different SOCs are like PCs, and the cards 
are those set of peripherals to be found in those SOCs.

But it is not just about peripherals, and system level things like 
timers and interrupt controllers.  It is also about the huge complexity 
put into the hardware for power management.  you will find different 
clocks/PLLs, power domains and regulators, and that has to be intermixed 
with various sleep states, wake sources and conditions, etc.  And no 
ressemblance is to be found between different vendors for those pm 
features unfortunately.  Even with a common high level abstraction 
(which abstraction is still being worked on) you will still need the 
backend code to interface with the hardware.

Maybe someday the optimal (or even just good enough) power management 
hardware infrastructure will be found and everybody will standardize on 
that.  But we're apparently not there yet.

> in the case of the PC, systems that were too different died off, systems that
> could have their differences abstracted into different drivers prospered.

Maybe that will happen eventually.  In the mean time they are rather all 
successful despite the major hardware discrepancies because the kernel 
is Open Source and it is relatively easy for each vendor to hack the 
kernel until it works on their own hardware.  User space is largely 
unaffected so the kernel becomes the actual abstraction.

> I am _not_ saying that all arm systems need to standardize on one interrupt
> controller,

I wish they had.

> I am saying that the kernel support for ARM needs to be able to
> _easily_ be told that this chip has interrupt chip type 24 connected this way,
> and interrupt chip type 87 connected that way, without needing to create a new
> architecture.

But then we have the next SOC coming up with yet another IRQ controller 
built into it.  So yet more code is required to deal with it.
Amongst the 15 ARM vendors or so, no IRQ controller is the same.

> If the kernel is compiled with the appropriate drivers, it
> should even be able to be done without needing to recompile the kernel.

Obviously.  And that's not a problem.  The problem is to actually 
support all the different hardware blocks.  Hence the volume of code 
out there.

If you do configure your kernel for one specific target which has a 
specific SOC implying a specific IRQ, timer, GPIO, clock, power, memory 
and peripheral bus, then you'll end up using relatively few lines of 
code from the arch/arm/ directory.  If instead you want support for a 
SOC from another vendor, then you'll need a different set of source code 
similar to the differences between an ARM SOC and a MIPS SOC.

> Now I understand that this isn't how things are done today in ARM, but that's
> not how things were done 10 years ago in x86 either. back then you had kernels
> compiled specifically for each system. nowdays that is still done where space
> or performance is critical, but a huge number of systems sacrafice a few % of
> speed, and some storage and ram for the flexibility and supportability of
> using a one-size-fits-many kernel (along with a large number of loadable
> modules)

We do have that partially on ARM.  It is already possible to build a 
kernel that supports multiple different boards at once, as long as 
they're all using the same SOC family.  I invite you to have a look at 
http://armlinux.simtec.co.uk/kautobuild/2.6.39-rc1/index.html.  Notice 
the defconfig names which are mostly after SOC names, and the number of 
actual machines they do include for each of those configs.  For example, 
the omap2plus_defconfig produces a single kernel binary that can boot on 
31 different boards.  Performance is not optimal as the instruction set 
is limited to the oldest supported by all those boards.  But it works.

This last merge window, some prerequisite infrastructure changes was 
pushed upstream to eventually allow for many SOC families to be compiled 
together by performing binary patching of the kernel at boot time like 
on X86.

But that has nothing to do with the fact that those SOCs still need 
their own specific support code to work because each vendor did their 
own things around the CPU core.  And there are a _lot_ of different SOCs 
on ARM, far more than any other architecture in the kernel tree.

> look at serial port support on x86.
> 
> while serial ports are becoming rare nowdays, the kernel has support for
> _many_ different types of ports, and all of the port types support being wired
> up in different ways (to different addresses and interrupts)
> 
> the kernel could have gone the route that ARM did of having a master config
> that listed every system known and where it's serial ports were wired, but
> thanks to the fact that many of these were plug-in options, that would have
> been painful enough that it drove them to do it the right way.

No... You don't understand.  What you're talking about above is all 
about different ways to wire the same serial controller chip, or 
derrivatives of that chip, all based on the venerable 8250 from National 
Semiconductor.  While it is true that some ARM SOCs do have a compatible 
UART and rightfully use the 8250.c driver, many (most?) SOCS do have 
totally incompatible UARTs requiring separate drivers. That's what I 
mean by each vendor doing their own things differently.

> take ARM down a similar path, treat the on-chip devices in a similar way to
> off-chip devices.

But we do already.  Care to provide an example where it is not the case?

> define the different types of GPIO behavior in arch-level drivers and make the
> chip-level (or board level) definitions say "I have a type 6 GPIO device wired
> this way" instead of including an entire GPIO driver in that definition.

GPIO is too easy.  Please take the clock tree and the multiple power 
domains found on the various TI OMAP and tell me how you would change 
that code into 
such abstract data, and make that format also useful and usable for the 
Marvell Kirkwood, and/or the Freescale i.MX, and/or the ST-Ericson 
UX500, and/or ... (the list can go like this for long).

> what is happening in ARM is being driven by the short-term ease of the chip
> manufacturers, they do things any way they want, and their engineers
> cut-n-paste their way to make things work as a new architecture.

Sure that's what they do.  But that code never get merged in mainline.  
Trust me, what we have now, even if it doesn't look nice from a 10000 
feet point of view, has gone through ssome review and often complete 
rewrite from people outside of those manufacturers.

> in the long run, making things more flexible and easier for the device
> designers and the people modifying the designs down the road will grow the pie
> by making it much easier for people to drop an ARM onto a new design, add a
> smattering of random (to the chip manufacturer) chips to do various things,
> and get linux running on the result.
> 
> get it down to where a new board can be designed by a guy in his garage, with
> a linux ARM distro able to run out of the box on it (with the appropriate
> definitions of how the guy wired it), and the variations will proliferate to
> the point where the current variation in ARM will look trivial by comparison,
> and the result will be even more use (and therefor sales) of ARM chips in all
> sorts of things that nobody can imagine today.

Hey, are you trying to convince _me_?  I'm currently not into the 
semiconductor 
industry, and for the 2.5 years that I did work for a semiconductor 
vendor I had very little to say about the hardware design.  I do wish 
that the hardware platform on ARM was more uniform.  That would 
certainly make my job easier.  But reality is different, for better or 
worse.


Nicolas
