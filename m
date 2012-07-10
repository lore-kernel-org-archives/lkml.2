Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2GJQ6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:58:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37772 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab2GJQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:58:21 -0400
Date: Tue, 10 Jul 2012 17:57:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710165746.GB20221@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com>
 <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 04:33:58PM +0100, Alan Cox wrote:
> > In the AArch32 kernel port many implementation decisions newer
> > architectures were made in a way that preserves backwards compatibility
> > to over 15 years ago (and for *good* reasons, ARMv4 hardware is still in
> > use). But keeping the same decisions in AArch64 is wrong.
> 
> Same argument as x86-32 v x86-64. Same issues about compatibility.

I don't deny that the arguments may be the same (I should go back and
read those threads). The AArch64 context is different and we can't do a
comparison with the x86 case.

> > AArch64 is also in its early days with a lot of developments to come
> > (and still waiting for hardware). Until we really know the final shape,
> > the AArch64 code base must allowed to evolve independently from the
> > AArch32 one.
> 
> That is one area where while the merge was needed and a lot of work the
> original split may well have been sensible for x86-64 as well.

That's exactly why I don't see the point in arguing whether the current
AArch64 port should be merged into arch/arm/.

> > The initial target is servers (see the companies that have announced
> > plans around ARMv8) but I agree, we may see it in other devices in the
> > future. But as the maintainer I have no plans to support a 32-bit SoC on
> > an AArch64/ARMv8 system (which may or may not support AArch32 at kernel
> > level). If an AArch64 SoC would share some devices with an AArch32 SoC,
> > such code will go to drivers/.
> 
> What plans to other maintainers and board vendors have ? Any design choice
> has to cope with these happening if a third party goes and does it.

Very few vendors (or architecture licensees) went public on this, so
cannot speak for their plans. But there are ongoing private discussions
on standardising relevant parts of the SoC, having a common firmware API
for CPU booting, possibly using ACPI. Again, it's early development
stage.

If a third party tries to push a 32-bit ARMv8 SoC port, I rely on the
arm-soc team (Arnd, Olof) to reject it. It's similar to the argument
against people running a 32-bit kernel on x86_64 hardware. The main
reason we have 32-bit at the EL1 (kernel) level is for virtualisation
where one may want to run a 32-bit guest OS.

-- 
Catalin
