Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2GIFUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:20:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:42591 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2GIFTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:19:36 -0400
Message-ID: <1341811163.3804.2.camel@pasglop>
Subject: Re: linux-next: boot failure in next-20120705 and 20120706
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jul 2012 15:19:23 +1000
In-Reply-To: <20120709144946.ada290480c0edc6a99f9c9c6@canb.auug.org.au>
References: <20120709144946.ada290480c0edc6a99f9c9c6@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 14:49 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Boot testing next-20120705 and 20120706 one of my PowerPC machines get this BUG:
> 
> (this one just after the console login prompt appeared.)

I'll have a look tomorrow. Make sure you keep the .config & machine at
hand :-) Any chance you can check with just powerpc-next ?

Cheers,
Ben.

> kernel BUG at arch/powerpc/kernel/irq.c:188!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in: binfmt_misc dm_mirror dm_region_hash dm_log ibmveth
> NIP: c00000000000f7d4 LR: c00000000000f838 CTR: c0000000007222a0
> REGS: c000000000d17a30 TRAP: 0700   Not tainted  (3.5.0-rc5-autokern1)
> MSR: 8000000000021032 <SF,ME,IR,DR,RI>  CR: 24000048  XER: 00000000
> SOFTE: 0
> TASK = c000000000c41a10[0] 'swapper/0' THREAD: c000000000d14000 CPU: 0
> GPR00: 0000000000000001 c000000000d17cb0 c000000000d12d10 0000000000000500 
> GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> GPR08: 001752557ab9dd5b c000000007ffb000 0000000000000000 c000000000bf5200 
> GPR12: 0000000000000000 c000000007ffb000 0000000002b00000 00000000009d7000 
> GPR16: 0000000000d454f0 00000000027dc6f0 0000000001b5f994 0000000000000060 
> GPR20: 0000000000000000 ffffffffffffffff ffffffffffffffff 8000000000009032 
> GPR24: c000000000d14000 c000000000d30290 c000000000d30178 c000000000d30290 
> GPR28: c0000000008a6180 0000000000000008 c000000000c7e130 0000000000000001 
> NIP [c00000000000f7d4] .__check_irq_replay+0xc4/0xf0
> LR [c00000000000f838] .arch_local_irq_restore+0x38/0x90
> Call Trace:
> [c000000000d17cb0] [c000000000d17d30] init_thread_union+0x3d30/0x4000 (unreliable)
> [c000000000d17d40] [c00000000000f838] .arch_local_irq_restore+0x38/0x90
> [c000000000d17db0] [c000000000015c60] .cpu_idle+0x230/0x2b0
> [c000000000d17e70] [c00000000000b3f8] .rest_init+0x88/0xa0
> [c000000000d17ef0] [c000000000b86c0c] .start_kernel+0x478/0x498
> [c000000000d17f90] [c0000000000096f8] .start_here_common+0x20/0x28
> Instruction dump:
> 4e800020 7da96b78 7beaf7e3 880901f3 38600500 5400e87e 5400183e 980901f3 
> 4082ffcc 880d01f3 7c0000d0 78000fe0 <0b000000> 38600000 4bffffb4 38610070 
> 
> This is:
> 	BUG_ON(local_paca->irq_happened != 0);
> in __check_irq_replay().
> 
> This only happens on my Power5+ machine.


