Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab1C3Van (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:30:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029Ab1C3VIy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 14:02:20 -0700
Message-ID: <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 1:41 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> If in your mind "competitors" == "morons" then you might be right.

There's a difference between "competition" and "do things differently
just to be difficult".

> Trying to rely on bootloaders doing things right is like saying that x86
> should always rely on the BIOS doing things right.

No. Not at all.

The problem with firmware/BIOS is that it's set in stone and closed-source.

I'm suggesting splitting out the crazy part into a separate project
that does this. Open-source. Like a mini-kernel. Because the thing is,
the main kernel doesn't care, and _shouldn't_ care. Those board files
are just noise.

The long-term situation should be that you should be able to have ONE
binary kernel "just work". That's where we are on x86. Really.

Without that kind of long-term view, where do you think ARM is going
to be in five years?

>> almost *SIXTY* percent of all arch updates were to ARM code.
>
> Absolutely not!  You have 14% going to OMAP code which happens to be
> under arch/arm/ but there is nothing ARM specific in there.  If OMAP was
> using a PPC or a MIPS core then you'd have the same result except under
> arch/powerpc or arch/mips.  There is very little in terms of ARM
> specific peculiarities under arch/arm/mach-omap2/ in fact.

But that's my point - the problem is all the crazy board crap.

I've never claimed that this is about the ARM cpu (which has it's own
issues, but that's a separate rant entirely). It's about the broken
infrastructure.

Now, some of it is quite understandable - ie real drivers for real
hardware. But a _lot_ of it seems to be just descriptor tables, and
I'm getting the very strong feeling that ARM people aren't even
_trying_ to make it sane, and trying to standardize things, or trying
to aim for the whole notion of "one kernel image, with much more hw
description done elsewhere".

Sure, you'll fundamentally always need several images (due to the
afore-mentioned crazy CPU architecture flaws - arm6 vs arm7 vs
armxyz), but I'm looking at the future, and arch/arm will get
_totally_ unmaintainable unless you guys have a plan for getting out
of the crazy hole you are in now.

arch/arm is already about 3x the size of arch/x86. And it's pretty
much all the crazy infrastructure afaik. timer chips, irq chips, gpio
differences - crap like that.

And the fact that you don't even seem to UNDERSTAND the problem, and
think that it's ok, and that continued future explosion of this is all
fine makes me even more nervous.

                           Linus
