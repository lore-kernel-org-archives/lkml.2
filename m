Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0FCO4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:56:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab0FCO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:56:44 -0400
Date: Thu, 3 Jun 2010 07:51:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failure with next-20100603
In-Reply-To: <20100603174251.226da45d.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1006030748590.8175@i5.linux-foundation.org>
References: <20100603174251.226da45d.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Rothwell wrote:
> 
> Unable to handle kernel paging request for data at address 0x00330000
> Faulting instruction address: 0xc0000000000a2f50
> Oops: Kernel access of bad area, sig: 11 [#1]
> NIP [c0000000000a2f50] .load_module+0x990/0x1458
> LR [c0000000000a2f18] .load_module+0x958/0x1458
> Call Trace:
> [c00000000228fc20] [c0000000000a2f18] .load_module+0x958/0x1458 (unreliable)
> [c00000000228fd90] [c0000000000a3a78] .SyS_init_module+0x60/0x244
> [c00000000228fe30] [c00000000000852c] syscall_exit+0x0/0x40
> Instruction dump:
> 7c7a1b78 7fa30040 41dd09cc 39230210 38030220 f9230218 f8030228 f9230210 
> f8030220 e9230240 38000001 e96d0040 <7c09592e> e80d01b0 f8030230 38800004 
> ---[ end trace 85cf1caaf6abfc45 ]---
> udevd-work[2749]: '/sbin/modprobe -b of:NlheaT<NULL>CIBM,lhea' unexpected exit with status 0x000b
> 
> This was followed by several other similaar OOPSes also in load_module.
> 
> I assume that this may have something to do with the module loading
> fix/cleanup that is in progress ...

That's a fairly safe assumption.

I can't read PPC oopses in my sleep the way I can do x86, and in 
particular, I can't pinpoint that to the source code by just decoding the 
instructions and matching them against what I have. Do you have that 
binary, and can you do a 'gdb vmlinux' on it, and then have gdb tell you 
where in load_module "load_module+0x990" and "load_module+0x958" are?

			Linus
