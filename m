Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2GQIiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:38:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57832 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab2GQIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:38:05 -0400
Date: Tue, 17 Jul 2012 09:37:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120717083722.GB15653@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
 <20120715121644.GB10597@arm.com>
 <5003CFBA.3060108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5003CFBA.3060108@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 09:24:26AM +0100, Avi Kivity wrote:
> On 07/15/2012 03:16 PM, Catalin Marinas wrote:
> > 
> > The AArch32 execution mode is optional, so it depends on the actual CPU
> > implementation (while AArch64 is mandatory). If the implementation
> > supports it, the most likely scenario for AArch32 at kernel level is in
> > virtual machines or the secure OS. I'll explain below why.
> > 
> > The exception (or privilege) levels on an ARMv8 architecture look like
> > this:
> > 
> > Secure World	Normal World
> > +-----+
> > | EL3 |				- Secure monitor
> > +-----+
> > 		+-----+
> > 		| EL2 |		- Hypervisor (normal world only)
> > 		+-----+
> > +-----+		+-----+
> > | EL1 |		| EL1 |		- OS kernel (secure or normal)
> > +-----+		+-----+
> > +-----+		+-----+
> > | EL0 |		| EL0 |		- User apps (secure or normal)
> > +-----+		+-----+
> 
> Can the same kernel image run in both EL1 and EL2?  I noticed some .if
> ELs in the assembler files.  I guess they could be compiled multiple
> times and the correct version chosen at runtime, or patched up like x86
> does with alternative().
> 
> One of the advantages kvm has to Linux distributors is that the same
> kernel image can be used the hypervisor, guest, and bare metal.  I'd
> like to preserve that for arm64.

On ARM (the same on 32-bit) we can also run the same kernel image as
hypervisor or guest. Linux detects whether it was started in EL2 and
installs some layer for KVM to use later if needed and then drops to
EL1. If started in EL1, it doesn't have access to the virtualisation
features and it just runs as a guest.

The kernel cannot run in EL2 permanently as it cannot access user space
(EL2 has its own MMU tables, though compatible with the other levels).

-- 
Catalin
