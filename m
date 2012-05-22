Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab2EVCZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:25:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab2EVCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:25:03 -0400
Date: Mon, 21 May 2012 19:25:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Neuling <mikey@neuling.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-Reply-To: <328.1337652722@neuling.org>
Message-ID: <alpine.DEB.2.00.1205211924390.13682@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au> <328.1337652722@neuling.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Michael Neuling wrote:

> console [tty0] enabled
> console [hvc0] enabled
> pid_max: default: 32768 minimum: 301
> Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
> Mount-cache hash table entries: 4096
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> POWER7 performance monitor hardware support registered
> Unable to handle kernel paging request for data at address 0x00001388
> Faulting instruction address: 0xc00000000014a070
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 NUMA pSeries
> Modules linked in:
> NIP: c00000000014a070 LR: c0000000001978cc CTR: c0000000000b6870
> REGS: c00000007e5836b0 TRAP: 0300   Tainted: G        W     (3.4.0-rc6-mikey)
> MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28004022  XER: 02000000
> SOFTE: 1
> CFAR: 00000000000050fc
> DAR: 0000000000001388, DSISR: 40000000
> TASK = c00000007e560000[1] 'swapper/0' THREAD: c00000007e580000 CPU: 0
> GPR00: 0000000000000000 c00000007e583930 c000000000c034d8 00000000000012d0 
> GPR04: 0000000000000000 0000000000001380 0000000000000000 0000000000000001 
> GPR08: c00000007e0dff60 0000000000000000 c000000000ca05a0 0000000000000000 
> GPR12: 0000000028004024 c00000000ff20000 0000000000000000 0000000000000000 
> GPR16: 0000000000000000 0000000000000000 0000000000000001 0000000000001380 
> GPR20: 0000000000000001 c000000000e14900 c000000000e148f0 0000000000000001 
> GPR24: c000000000c6f378 0000000000000000 0000000000001380 00000000000002aa 
> GPR28: 0000000000000000 0000000000000000 c000000000b576b0 c00000007e021200 
> NIP [c00000000014a070] .__alloc_pages_nodemask+0xd0/0x910
> LR [c0000000001978cc] .new_slab+0xcc/0x3d0
> Call Trace:
> [c00000007e583930] [c00000007e5839c0] 0xc00000007e5839c0 (unreliable)
> [c00000007e583ac0] [c0000000001978cc] .new_slab+0xcc/0x3d0
> [c00000007e583b70] [c00000000072ae98] .__slab_alloc+0x38c/0x4f8
> [c00000007e583cb0] [c000000000198190] .kmem_cache_alloc_node_trace+0x90/0x260
> [c00000007e583d60] [c000000000a5a404] .numa_init+0x9c/0x188
> [c00000007e583e00] [c00000000000aa30] .do_one_initcall+0x60/0x1e0
> [c00000007e583ec0] [c000000000a40b60] .kernel_init+0x128/0x294
> [c00000007e583f90] [c000000000020788] .kernel_thread+0x54/0x70
> Instruction dump:
> 0b000000 eb1e8000 3b800000 801800a8 2f800000 409e001c 7860efe3 38000000 
> 41820008 38000002 787c6fe2 7f9c0378 <e93a0008> 801800a4 3b600000 2fa90000 
> ---[ end trace 31fd0ba7d8756002 ]---
> 
> Which seems to be this code in __alloc_pages_nodemask
> ---
>         /*
>          * Check the zones suitable for the gfp_mask contain at least one
>          * valid zone. It's possible to have an empty zonelist as a result
>          * of GFP_THISNODE and a memoryless node
>          */
>         if (unlikely(!zonelist->_zonerefs->zone))
> c00000000014a070:       e9 3a 00 08     ld      r9,8(r26)
> ---
> 
> r26 is coming from r5 which is the struct zonelist *zonelist parameter
> to __alloc_pages_nodemask.  Having 0000000000001380 in there is clearly
> a bogus pointer.
> 
> Bisecting it points to b4cdf91668c27a5a6a5a3ed4234756c042dd8288
>   b4cdf91 sched/numa: Implement numa balancer
> 
> Trying David's patch just posted doesn't fix it.
> 

Hmm, what does CONFIG_DEBUG_VM say?
