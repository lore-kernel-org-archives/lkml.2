Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1DAP16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:27:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48142 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795Ab1DAP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:27:55 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <201104011554.07924.arnd@arndb.de>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <8ya39m2mv65.fsf@huya.qualcomm.com> <20110401074519.GC7594@elte.hu>
	 <201104011554.07924.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 16:27:35 +0100
Message-ID: <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, 2011-04-01 at 14:54 +0100, Arnd Bergmann wrote:
> I would actually suggest a different much more radical start: Fork the way
> that platforms are managed today, and start an alternative way of setting
> up boards and devices together with the proven ARM core kernel infrastructure,
> based on these observations (please correct me if some of them they don't make
> sense):
> 
> 1. The core arch code is not a problem (Russell does a great job here)
> 2. The platform specific code contains a lot of crap that doesn't belong there
>    (not enough reviewers to push back on crap)
> 3. The amount of crap in platform specfic files is growing exponentially,
>    despite the best efforts of a handful of people to clean it up.
> 4. Having one source file per board does not scale any more.
> 5. Discoverable hardware would solve this, but is not going to happen
>    in practice.
> 6. Board firmware would not solve this and is usually not present.
> 7. Boot loaders can not be trusted to pass valid information
> 8. Device tree blobs can solve a lot of the problems, and nobody has
>    come up with a better solution.

Right, so this is directly related to point (5) because in essence FDT
is a way to make undiscoverable hardware discoverable by probing the
tree. The `it's just data' mantra sums it up nicely.

> 9. All interesting work is going into a handful of platforms, all of which
>    are ARMv7 based.

I think starting out ARMv7-only might make this more manageable but
there are still shed loads of pre-v7 chips out there which we should try
not to break.

> 10. We do not want to discontinue support for old boards that work fine.

[...]

> Based on these assumptions, my preferred strategy would be to a new
> mach-nocrap directory with a documented set of rules (to be adapted when
> necessary):

This is a nice idea, but I don't think it's entirely practical:

> * Strictly no crap
>  * No board files

I don't understand how you can handle `early quirks' without board
files. Does this follow on from Linus' suggestion about moving code out
of the kernel and into the bootloader?

Realistically, I don't think you will ever get away from board files.
The trick is probably to make them as small as possible and common to as
many boards as possible (like the platforms directory for PowerPC).

>  * No hardcoded memory maps
>  * No lists of interrupts and GPIOs

This is largely just data, so should be do-able once this stuff isn't
needed at compile-time (which is becoming the case with stuff like
dynamic p2v).

Will

