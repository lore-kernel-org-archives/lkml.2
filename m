Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GPIZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2GPIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:25:04 -0400
Message-ID: <5003CFBA.3060108@redhat.com>
Date: Mon, 16 Jul 2012 11:24:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com> <20120710101018.GE15120@arm.com> <20120714093032.GA23316@elf.ucw.cz> <20120715121644.GB10597@arm.com>
In-Reply-To: <20120715121644.GB10597@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 03:16 PM, Catalin Marinas wrote:
> 
> The AArch32 execution mode is optional, so it depends on the actual CPU
> implementation (while AArch64 is mandatory). If the implementation
> supports it, the most likely scenario for AArch32 at kernel level is in
> virtual machines or the secure OS. I'll explain below why.
> 
> The exception (or privilege) levels on an ARMv8 architecture look like
> this:
> 
> Secure World	Normal World
> +-----+
> | EL3 |				- Secure monitor
> +-----+
> 		+-----+
> 		| EL2 |		- Hypervisor (normal world only)
> 		+-----+
> +-----+		+-----+
> | EL1 |		| EL1 |		- OS kernel (secure or normal)
> +-----+		+-----+
> +-----+		+-----+
> | EL0 |		| EL0 |		- User apps (secure or normal)
> +-----+		+-----+

Can the same kernel image run in both EL1 and EL2?  I noticed some .if
ELs in the assembler files.  I guess they could be compiled multiple
times and the correct version chosen at runtime, or patched up like x86
does with alternative().

One of the advantages kvm has to Linux distributors is that the same
kernel image can be used the hypervisor, guest, and bare metal.  I'd
like to preserve that for arm64.

-- 
error compiling committee.c: too many arguments to function


