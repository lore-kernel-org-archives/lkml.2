Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2EVCvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:51:46 -0400
Received: from ozlabs.org ([203.10.76.45]:54623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849Ab2EVCvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:51:42 -0400
From: Michael Neuling <mikey@neuling.org>
To: David Rientjes <rientjes@google.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-reply-to: <alpine.DEB.2.00.1205211942540.29814@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au> <328.1337652722@neuling.org> <alpine.DEB.2.00.1205211924390.13682@chino.kir.corp.google.com> <2182.1337654352@neuling.org> <2246.1337654423@neuling.org> <alpine.DEB.2.00.1205211942540.29814@chino.kir.corp.google.com>
Comments: In-reply-to David Rientjes <rientjes@google.com>
   message dated "Mon, 21 May 2012 19:44:40 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 22 May 2012 12:51:40 +1000
Message-ID: <3120.1337655100@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> wrote:

> On Tue, 22 May 2012, Michael Neuling wrote:
> 
> > > > > Trying David's patch just posted doesn't fix it.
> > > > > 
> > > > 
> > > > Hmm, what does CONFIG_DEBUG_VM say?
> > > 
> > > No set.
> > 
> > Sorry, should have read "Not set"
> > 
> 
> I mean if it's set, what does it emit to the kernel log with my patch 
> applied?
> 
> I made CONFIG_DEBUG_VM catch !node_online(node) about six months ago, so I 
> was thinking it would have caught this if either you or Stephen enable it.

Sorry, got it... CONFIG_DEBUG_VM enabled below...

pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
POWER7 performance monitor hardware support registered
------------[ cut here ]------------
kernel BUG at /scratch/mikey/src/linux-next/include/linux/gfp.h:318!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in:
NIP: c000000000199164 LR: c0000000001993e0 CTR: c0000000000b6b70
REGS: c00000007e583830 TRAP: 0700   Tainted: G        W     (3.4.0-rc6-mikey)
MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28004028  XER: 02000000
SOFTE: 1
CFAR: c0000000001993c4
TASK = c00000007e560000[1] 'swapper/0' THREAD: c00000007e580000 CPU: 0
GPR00: 0000000000000001 c00000007e583ab0 c000000000c035a0 00000000000012d0 
GPR04: 0000000000000000 0000000000000001 c000000000e14900 0005055500000001 
GPR08: 0000000000000001 00000000000012d0 c000000000c6f398 0000000000000001 
GPR12: 0000000028004022 c00000000ff20000 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000001380 0000000000000000 
GPR20: 0000000000000001 c000000000e14900 c000000000e148f0 0000000000210d00 
GPR24: 0000000000000001 00000000000000d0 00000000000002aa 0000000000000000 
GPR28: 00000000000000d0 0000000000000001 c000000000b58fc8 c00000007e021200 
NIP [c000000000199164] .new_slab+0xb4/0x440
LR [c0000000001993e0] .new_slab+0x330/0x440
Call Trace:
[c00000007e583ab0] [c0000000001993e0] .new_slab+0x330/0x440 (unreliable)
[c00000007e583b60] [c00000000072ce84] .__slab_alloc+0x3bc/0x52c
[c00000007e583ca0] [c000000000199b08] .kmem_cache_alloc_node_trace+0x98/0x280
[c00000007e583d60] [c000000000a5a440] .numa_init+0x9c/0x188
[c00000007e583e00] [c00000000000aa30] .do_one_initcall+0x60/0x1e0
[c00000007e583ec0] [c000000000a40b60] .kernel_init+0x128/0x294
[c00000007e583f90] [c000000000020788] .kernel_thread+0x54/0x70
Instruction dump:
7b5b8402 7f6407b4 7c1ce378 7d29e038 7b990020 61291200 79230020 419202b8 
2b9d00ff 78840020 38000001 409d0240 <0b000000> e95e8140 792977e2 7bab1f24 
---[ end trace 31fd0ba7d8756002 ]---


