Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2GGXPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:15:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41730 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab2GGXPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:15:18 -0400
Date: Sun, 8 Jul 2012 00:14:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120707231456.GA21201@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:58:04PM +0100, Alan Cox wrote:
> >  arch/x86/include/asm/atomic64_32.h              |    1 +
> >  arch/x86/include/asm/atomic64_64.h              |    1 +
> >  arch/xtensa/kernel/syscall.c                    |    2 +-
> 
> This looks odd to say the least ?

There are a few preparatory patches at the beginning of this series that
will be merged separately but I wanted to give the full context of why
they are needed, hence posting them together with the AArch64 code.

> The only other question I'd ask is given that ppc and x86 have both done
> 32/64bit separate architectures and then gone the other way is that
> something ARM 64bit needs to think about ?

This has been debated and there are strong reasons to keep it separate:

1. The AArch64 architecture is significantly different from AArch32 (the
official name of the 32-bit ARM architecture), it is not an extension.
It has a new exception model, new instruction set (even the register
names are different), new C ABI, PCS. It has a hardware compat mode but
that's about it, there is no interworking between the two (not allowed
by hardware, nor that the ABIs would make this possible). 

2. Easier code maintenance. While I started the kernel port from the
arch/arm/ code base (it was at a time when Linux didn't even have
generic unistd.h and the AArch64 specs kept changing) the code diverged
significantly both because of architecture differences and software
requirements like new ABI, generic headers (unistd.h, stat.h etc). The
port undergone significant rewrite following the rules for new
architecture ports and some of the few similarities will be moved to a
more generic place (like the mmu_gather patches from peterz). AArch64
SoCs are going into a more standardised direction and the SoC code will
be kept to a minimum and moved under drivers/. So merging AArch32 and
AArch64 together would be rather detrimental to code maintenance for
both architectures (#ifdef's or duplicate 32/64 files).

3. Flexibility. It's early days for AArch64, we don't have a hardware
platform supported yet and there are ongoing debates around ACPI,
firmware standardisation for CPU booting, hotplug, power management. We
need the flexibility to improve the code base without worrying about
backwards compatibility (apart from the compat layer which isn't at all
affected by the hardware developments).

-- 
Catalin
