Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2GJUfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:35:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60787 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2GJUfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:35:33 -0400
Date: Tue, 10 Jul 2012 22:35:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710203527.GA16986@gmail.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120710101018.GE15120@arm.com>
 <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
 <201207101652.18401.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207101652.18401.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> > What plans to other maintainers and board vendors have ? Any 
> > design choice has to cope with these happening if a third 
> > party goes and does it.
> 
> It is slightly worrying to have multiple SoC vendors working 
> on their own platform support. There are a few things we can 
> assume though:
> 
> * Everyone who has an AArch64 implementation has access to 
> Catalin's kernel patches in is basing their stuff on top of 
> it.
> 
> * Most likely they are all working on server chips, which 
> means they want to have their hardware supported in upstream 
> kernels and enterprise distros.

Dunno, the moment Apple comes out with their 64-bit iPhone6 (or 
whichever version they'll go 64-bit) *everyone* will scramble to 
go 64-bit, for marketing reasons. Code and SoC details will be 
ported to 64-bit in the usual fashion: in the crudest, fastest 
possible way.

There's also a technological threshold: once RAM in a typical 
smartphone goes above 2GB the pain of a 32-bit kernel becomes 
significant. We are only about a year away from that point.

So are you *really* convinced that the colorful ARM SoC world is 
not going to go 64-bit and will all unify behind a platform, and 
that we can actually force this process by not accepting 
non-generic patches? Is such a platform design being enforced by 
ARM, like Intel does it on the x86 side?

> * Unlike on 32 bit, the different platforms cannot be 
> compile-time exclusive. A platform port that cannot be enabled 
> without breaking another platform is not getting merged.
> 
> * I do not expect board-specific kernel patches, at least no 
> more than we have them on x86 with the occasional hack to work 
> around a broken machine.

If 64-bit hardware is made on existing SoC designs, which looks 
rather likely, then we are not in a position to reject kernel 
support for them.

Saying 'no' is very rarely a valid option for hardware ugliness. 
We are encouraged to say 'no' for software details that is 
actionable by the author of the patches, but hardware ugliness 
is rarely actionable on that level and we are not holding our 
users hostage in general just to make a point about ugliness.

> * The differences between SoCs will be confined to device 
> drivers to a much larger degree than they are on 32 bit, 
> partly because the SoC companies are trying to be fit into the 
> single-kernel model, and partly because we have added the 
> infrastructure to allow it.

There's 600 KLOC of code in arch/arm/, that's 3 times larger 
than arch/x86/. Most of it is not in any fashion related to the 
bitness of the CPU, it's platform IO code that is in principle 
bitness agnostic.

I have a really hard time imagining that all 64-bit ARM hardware 
will be supported from drivers/: IRQ controllers, timer drivers, 
all the ugly SoC details.

Do you *really* think that all of the 32-bit ARM code should 
essentially be thrown away when going to 64-bit ARM, that 
patches can only touch arch/arm64/ + drivers/ or the highway?

The moment someone adds 64-bit CPU support to arch/arm/ and it's 
merged we'll have an interesting situation on hand: support for 
the same CPU in two different architectures in the kernel tree.

Anyway, I'm not an ARM person so I really don't want to make 
your life harder, I just wanted to potentially save you the 2 
years of extreme unification stress that the x86 tree went 
through ;-)

Thanks,

	Ingo
