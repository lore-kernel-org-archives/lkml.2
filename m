Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab2EVCMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:12:08 -0400
Received: from ozlabs.org ([203.10.76.45]:39350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2EVCMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:12:05 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-reply-to: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Tue, 22 May 2012 11:40:51 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 22 May 2012 12:12:02 +1000
Message-ID: <328.1337652722@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
> 
> Last nights boot tests on various PowerPC systems failed like this:
> 
> calling  .numa_group_init+0x0/0x3c @ 1
> initcall .numa_group_init+0x0/0x3c returned 0 after 0 usecs
> calling  .numa_init+0x0/0x1dc @ 1
> Unable to handle kernel paging request for data at address 0x00001688
> Faulting instruction address: 0xc00000000016e154
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in:
> NIP: c00000000016e154 LR: c0000000001b9140 CTR: 0000000000000000
> REGS: c0000003fc8c76d0 TRAP: 0300   Not tainted  (3.4.0-autokern1)
> MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24044022  XER: 00000003
> SOFTE: 1
> CFAR: 000000000000562c
> DAR: 0000000000001688, DSISR: 40000000
> TASK = c0000003fc8c8000[1] 'swapper/0' THREAD: c0000003fc8c4000 CPU: 0
> GPR00: 0000000000000000 c0000003fc8c7950 c000000000d05b30 00000000000012d0 
> GPR04: 0000000000000000 0000000000001680 0000000000000000 c0000003fe032f60 
> GPR08: 0004005400000001 0000000000000000 ffffffffffffc980 c000000000d24fe0 
> GPR12: 0000000024044024 c00000000f33b000 0000000001a3fa78 00000000009bac00 
> GPR16: 0000000000e1f338 0000000002d513f0 0000000000001680 0000000000000000 
> GPR20: 0000000000000001 c0000003fc8c7c00 0000000000000000 0000000000000001 
> GPR24: 0000000000000001 c000000000d1b490 0000000000000000 0000000000001680 
> GPR28: 0000000000000000 0000000000000000 c000000000c7ce58 c0000003fe009200 
> NIP [c00000000016e154] .__alloc_pages_nodemask+0xc4/0x8f0
> LR [c0000000001b9140] .new_slab+0xd0/0x3c0
> Call Trace:
> [c0000003fc8c7950] [2e6e756d615f696e] 0x2e6e756d615f696e (unreliable)
> [c0000003fc8c7ae0] [c0000000001b9140] .new_slab+0xd0/0x3c0
> [c0000003fc8c7b90] [c0000000001b9844] .__slab_alloc+0x254/0x5b0
> [c0000003fc8c7cd0] [c0000000001bb7a4] .kmem_cache_alloc_node_trace+0x94/0x260
> [c0000003fc8c7d80] [c000000000ba36d0] .numa_init+0x98/0x1dc
> [c0000003fc8c7e10] [c00000000000ace4] .do_one_initcall+0x1a4/0x1e0
> [c0000003fc8c7ed0] [c000000000b7b354] .kernel_init+0x124/0x2e0
> [c0000003fc8c7f90] [c0000000000211c8] .kernel_thread+0x54/0x70
> Instruction dump:
> 5400d97e 7b170020 0b000000 eb3e8000 3b800000 80190088 2f800000 40de0014 
> 7860efe2 787c6fe2 78000fa4 7f9c0378 <e81b0008> 83f90000 2fa00000 7fff1838 
> ---[ end trace 31fd0ba7d8756001 ]---
> 
> swapper/0 (1) used greatest stack depth: 10864 bytes left
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> I may be completely wrong, but I guess the obvious target would be the
> sched/numa branch that came in via the tip tree.
> 
> Config file attached.  I haven't had a chance to try to bisect this yet.
> 
> Anyone have any ideas?

I'm getting similar here:


console [tty0] enabled
console [hvc0] enabled
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
POWER7 performance monitor hardware support registered
Unable to handle kernel paging request for data at address 0x00001388
Faulting instruction address: 0xc00000000014a070
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in:
NIP: c00000000014a070 LR: c0000000001978cc CTR: c0000000000b6870
REGS: c00000007e5836b0 TRAP: 0300   Tainted: G        W     (3.4.0-rc6-mikey)
MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28004022  XER: 02000000
SOFTE: 1
CFAR: 00000000000050fc
DAR: 0000000000001388, DSISR: 40000000
TASK = c00000007e560000[1] 'swapper/0' THREAD: c00000007e580000 CPU: 0
GPR00: 0000000000000000 c00000007e583930 c000000000c034d8 00000000000012d0 
GPR04: 0000000000000000 0000000000001380 0000000000000000 0000000000000001 
GPR08: c00000007e0dff60 0000000000000000 c000000000ca05a0 0000000000000000 
GPR12: 0000000028004024 c00000000ff20000 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000001 0000000000001380 
GPR20: 0000000000000001 c000000000e14900 c000000000e148f0 0000000000000001 
GPR24: c000000000c6f378 0000000000000000 0000000000001380 00000000000002aa 
GPR28: 0000000000000000 0000000000000000 c000000000b576b0 c00000007e021200 
NIP [c00000000014a070] .__alloc_pages_nodemask+0xd0/0x910
LR [c0000000001978cc] .new_slab+0xcc/0x3d0
Call Trace:
[c00000007e583930] [c00000007e5839c0] 0xc00000007e5839c0 (unreliable)
[c00000007e583ac0] [c0000000001978cc] .new_slab+0xcc/0x3d0
[c00000007e583b70] [c00000000072ae98] .__slab_alloc+0x38c/0x4f8
[c00000007e583cb0] [c000000000198190] .kmem_cache_alloc_node_trace+0x90/0x260
[c00000007e583d60] [c000000000a5a404] .numa_init+0x9c/0x188
[c00000007e583e00] [c00000000000aa30] .do_one_initcall+0x60/0x1e0
[c00000007e583ec0] [c000000000a40b60] .kernel_init+0x128/0x294
[c00000007e583f90] [c000000000020788] .kernel_thread+0x54/0x70
Instruction dump:
0b000000 eb1e8000 3b800000 801800a8 2f800000 409e001c 7860efe3 38000000 
41820008 38000002 787c6fe2 7f9c0378 <e93a0008> 801800a4 3b600000 2fa90000 
---[ end trace 31fd0ba7d8756002 ]---

Which seems to be this code in __alloc_pages_nodemask
---
        /*
         * Check the zones suitable for the gfp_mask contain at least one
         * valid zone. It's possible to have an empty zonelist as a result
         * of GFP_THISNODE and a memoryless node
         */
        if (unlikely(!zonelist->_zonerefs->zone))
c00000000014a070:       e9 3a 00 08     ld      r9,8(r26)
---

r26 is coming from r5 which is the struct zonelist *zonelist parameter
to __alloc_pages_nodemask.  Having 0000000000001380 in there is clearly
a bogus pointer.

Bisecting it points to b4cdf91668c27a5a6a5a3ed4234756c042dd8288
  b4cdf91 sched/numa: Implement numa balancer

Trying David's patch just posted doesn't fix it.

Mikey
