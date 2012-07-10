Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2GJKZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:25:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56553 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078Ab2GJKZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:25:48 -0400
Date: Tue, 10 Jul 2012 11:10:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710101018.GE15120@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710071023.GA10456@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 08:10:23AM +0100, Ingo Molnar wrote:
> * Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 07 July 2012, Olof Johansson wrote:
> > > > ARM introduced AArch64 as part of the ARMv8 architecture
> > > 
> > > With the risk of bikeshedding here, but I find the name awkward. How
> > > about just naming the arch port arm64 instead? It's considerably more
> > > descriptive in the context of the kernel.  For reference, we didn't
> > > name ppc64, nor powerpc, after what the IBM/power.org marketing people
> > > were currently calling the architecture at the time either.
> > 
> > I agree the name sucks, [...]
> 
> So why not change it now, when it only bothers a few dozen 
> people and it is only present in 36 patches? Why go full steam 
> ahead to annoy thousands of people with it and why spread the 
> naming madness to thousands of commits?

Changing the arch/ dir name is easy at this point. My preference is for
consistency with the official name (that cannot be changed) and the gcc
triplet. I also don't think it annoys thousands of people, most don't
really care. The few reactions I've seen is pretty much because people
were expecting arm64 and it came as something else.

But I'll make a decision on this before the next version of the series.

> > [...] This also includes the rpm and dpkg architecture names, 
> > and the string returned by the uname syscall. If everything 
> > else is aarch64, we should use that in the kernel directory 
> > too, but if everyone calls it arm64 anyway, we should probably 
> > use that name for as many things as possible.
> 
> Yeah.

What are Red Hat's plans for the AArh64 rpm architecture name?

> > > I guess it's a good chance to clean up some of it and start 
> > > from a clean slate, if you can avoid the temptation of just 
> > > moving over code.
> > 
> > Agreed. It's clear from the code that it started out as a copy 
> > of the 32 bit ARM code base, which I think was a mistake, but 
> > it has also moved on since then and many areas of the 64 bit 
> > code are now much cleaner because they don't have to worry 
> > about breaking legacy code. We're also more flexible with 
> > trying out stuff without having to worry about breaking some 
> > 10 year old board code.
> 
> Just for the record, you guys are repeating all the same 
> arguments that led to the x86_64 fork a decade ago...

As I stated already, comparing AArch64 to x86_64 is not right. So even
if the arguments may look the same, the context is *different*. AArch64
is *not* an extension to the AArch32 mode.

In the AArch32 kernel port many implementation decisions newer
architectures were made in a way that preserves backwards compatibility
to over 15 years ago (and for *good* reasons, ARMv4 hardware is still in
use). But keeping the same decisions in AArch64 is wrong.

If you want to put the two architectures under the same directory, you
pretty much end up with duplicate files or subdirectories. If there is
little code shared, then I don't see the point. It's just creating more
work to maintain the build system, the include/asm/ (as AArch64 uses
lots more generic headers).

AArch64 is also in its early days with a lot of developments to come
(and still waiting for hardware). Until we really know the final shape,
the AArch64 code base must allowed to evolve independently from the
AArch32 one.

> With the difference that the case for unifying platforms seems 
> even *stronger* in the ARM space than it is in the x86 space: 
> 32-bit computing will probably stay around with us far longer in 
> the gadget and appliance space than in the server space. 
> Thinking that arm64 will only be limited to servers is rather 
> short-sighted, IMO.

The initial target is servers (see the companies that have announced
plans around ARMv8) but I agree, we may see it in other devices in the
future. But as the maintainer I have no plans to support a 32-bit SoC on
an AArch64/ARMv8 system (which may or may not support AArch32 at kernel
level). If an AArch64 SoC would share some devices with an AArch32 SoC,
such code will go to drivers/.

-- 
Catalin
