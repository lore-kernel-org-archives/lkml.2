Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1CaAAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:00:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33807 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab1CaAAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:00:35 -0400
Date: Thu, 31 Mar 2011 00:59:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330235930.GA6680@n2100.arm.linux.org.uk>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 07:31:59PM -0400, Nicolas Pitre wrote:
> Sure, but important noise nevertheless.  As long as the noise is 
> confined to a limited set of .c files I'm happy.  OTOH I have very 
> little hope for a separate project that would only deal with that noise.  
> That will simply never fly, even less so as an Open Source project.

It's also an excuse for people to make it a closed source project, and
so you end up with platforms with a closed source binary blob passed
into the kernel, which has hacky patches to fixup the binary blob parser
to make it all work.

We already see this with the damn simple memory layout stuff we already
(try) to require of boot loaders.

> Still... there are on-going efforts to consolidate things amongst all 
> the ARM vendors.  The ARM architecture is standardizing more and more 
> stuff in the whole stack in every revision.  But they won't standardize 
> everything otherwise they'll kill that competing ecosystem.

Let's not kid ourselves over that effort: because there is already soo
much code in mainline, the efforts to consolidate things can in itself
create _big_ patches which will inflate the %age change under arch/arm.

> > Now, some of it is quite understandable - ie real drivers for real
> > hardware. But a _lot_ of it seems to be just descriptor tables, and
> > I'm getting the very strong feeling that ARM people aren't even
> > _trying_ to make it sane, and trying to standardize things, or trying
> > to aim for the whole notion of "one kernel image, with much more hw
> > description done elsewhere".
> 
> That work is happening.  It is not ready.  I'm not against it but I 
> remain sceptical.  I still think that a self contained kernel is more 
> maintainable.

Let's not forget that in the future, the hardware should improve.
There's efforts to standardise some of the peripherals, such as
interrupt controllers and timers.

The first attempt at architecting an interrupt controller for ARM has
actually caused *more* complexity, as the architected interrupt (GIC)
controller contained no power management.  That has caused SoC vendors
to bolt a second power management interrupt controller alongside the
GIC which needs to be kept in sync.  So... the result was yet more code
which doesn't sit at all well with data descriptions of systems.

> Still, because ARM is just a CPU architecture, those SOC vendors will 
> always have something new to differenciate themselves from the other SOC 
> vendors.  And that cannot be described in a table alone. The power 
> management hardware from TI will still require separate _executable_ 
> code from the Freescale one, or the Samsung one, or the Nvidia one, or 
> the Qualcomm one, or the Marvell one, yada yada.  And I really don't 
> want to see that code turned into some vendor provided buggy ACPI 
> bytecode or similar.

To get rid of all the platform related stuff, I think you'd need some
kind of bytecode to deal with some of the procedural stuff with various
platforms.  Without bytecode, the only other way is to keep the stuff
as C functions in the kernel and find some way of binding them to
drivers through DT, which means we're still going to have platform
specific C files littering the kernel.

While I can see DT solving the "declare this data structure" problem,
I believe that's only part of the issue.

This is exactly why when DT was proposed as a miracle cure-all for ARM,
I wanted to see DT on a real ARM platform rather than just ARM Ltd's
simple and similar development boards.

Certainly, though, DT for ARM is progressing.
