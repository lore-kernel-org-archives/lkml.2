Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1DAP4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:56:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1DAP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:56:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 17:55:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011554.07924.arnd@arndb.de> <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011755.57412.arnd@arndb.de>
X-Provags-ID: V02:K0:zouJjrxUNjhMyxR0sAqjHE9DNOwnuVgSrJO+ilOnq6o
 FKBrOBeupYAoqFTqsk7bE9Hiub7bXNiPRuiXRVv6dnK7Efkmiu
 zqQKqjqh8VEUUhuFHwcr8UYMWardcb63iTUOc4HBTNoG9ie6ca
 +AJUejRiVPfvNfjeoYPkQKCqOAz+df40+fM84gCJNnOzUYGSKa
 ngThANrpP3Z6vSFzrZXQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Will Deacon wrote:

> > 1. The core arch code is not a problem (Russell does a great job here)
> > 2. The platform specific code contains a lot of crap that doesn't belong there
> >    (not enough reviewers to push back on crap)
> > 3. The amount of crap in platform specfic files is growing exponentially,
> >    despite the best efforts of a handful of people to clean it up.
> > 4. Having one source file per board does not scale any more.
> > 5. Discoverable hardware would solve this, but is not going to happen
> >    in practice.
> > 6. Board firmware would not solve this and is usually not present.
> > 7. Boot loaders can not be trusted to pass valid information
> > 8. Device tree blobs can solve a lot of the problems, and nobody has
> >    come up with a better solution.
> 
> Right, so this is directly related to point (5) because in essence FDT
> is a way to make undiscoverable hardware discoverable by probing the
> tree. The `it's just data' mantra sums it up nicely.

Well, except that because of point 7, device trees are still inferior to
having correct and complete information in hardware.

> > 9. All interesting work is going into a handful of platforms, all of which
> >    are ARMv7 based.
> 
> I think starting out ARMv7-only might make this more manageable but
> there are still shed loads of pre-v7 chips out there which we should try
> not to break.

Yes, see below: the idea is to touch as little of the existing code
as possible, at least in the first stages.

> > 10. We do not want to discontinue support for old boards that work fine.
> 
> [...]
> 
> > Based on these assumptions, my preferred strategy would be to a new
> > mach-nocrap directory with a documented set of rules (to be adapted when
> > necessary):
> 
> This is a nice idea, but I don't think it's entirely practical:
> 
> > * Strictly no crap
> >  * No board files
> 
> I don't understand how you can handle `early quirks' without board
> files. Does this follow on from Linus' suggestion about moving code out
> of the kernel and into the bootloader?

There are multiple ways of dealing with this. One way would be to
mandate that the boot loader does the quirks, ideally as little
as possible.

Another option is to have a boot wrapper with board specific code,
which gets run between the regular boot loader and the common
kernel entry point. We might need such a wrapper anyway to pass the
device tree to the kernel.

> Realistically, I don't think you will ever get away from board files.
> The trick is probably to make them as small as possible and common to as
> many boards as possible (like the platforms directory for PowerPC).

Perhaps. But we can start out with strict rules and add exceptions
later when we run out of options.

> >  * No hardcoded memory maps
> >  * No lists of interrupts and GPIOs
> 
> This is largely just data, so should be do-able once this stuff isn't
> needed at compile-time (which is becoming the case with stuff like
> dynamic p2v).

Right.

	Arnd
