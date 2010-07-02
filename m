Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0GBBgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 21:36:43 -0400
Received: from ozlabs.org ([203.10.76.45]:50663 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0GBBgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 21:36:41 -0400
From: Michael Neuling <mikey@neuling.org>
To: Nick Piggin <npiggin@suse.de>
cc: divya <dipraksh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Oops while running fs_racer test on a POWER6 box against latest git
In-reply-to: <20100701105907.GK22976@laptop>
References: <4C2B28F3.7000006@linux.vnet.ibm.com> <7381.1277960694@neuling.org> <20100701105907.GK22976@laptop>
Comments: In-reply-to Nick Piggin <npiggin@suse.de>
   message dated "Thu, 01 Jul 2010 20:59:07 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 02 Jul 2010 11:36:38 +1000
Message-ID: <29845.1278034598@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100701105907.GK22976@laptop> you wrote:
> On Thu, Jul 01, 2010 at 03:04:54PM +1000, Michael Neuling wrote:
> > > While running fs_racer test from LTP on a POWER6 box against latest git(2
.6.3
> > 5-rc3-git4 - commitid 984bc9601f64fd)
> > > came across the following warning followed by multiple oops.
> > > 
> > > ------------[ cut here ]------------
> > > 
> > > Badness at kernel/mutex-debug.c:64
> > > NIP: c0000000000be9e8 LR: c0000000000be9cc CTR: 0000000000000000
> > > REGS: c00000010be8f6f0 TRAP: 0700   Not tainted  (2.6.35-rc3-git4-autotes
t)
> > > MSR: 8000000000029032<EE,ME,CE,IR,DR>    CR: 24224422  XER: 00000012
> > > TASK = c00000010727cf00[8211] 'fs_racer_file_c' THREAD: c00000010be8bb50 
CPU:
> >  2
> > > GPR00: 0000000000000000 c00000010be8f970 c000000000d3d798 000000000000000
1
> > > GPR04: c00000010be8fa70 c00000010be8c000 c00000010727d9f8 000000000000000
0
> > > GPR08: c0000000043042f0 c0000000016534e8 000000000000017a c000000000c29a1
c
> > > GPR12: 0000000028228424 c00000000f600500 c00000010be8fc40 000000002000000
0
> > > GPR16: fffffffffffff000 c000000109c73000 c00000010be8fc30 000000000001044
2
> > > GPR20: 0000000000000000 0000000000000000 00000000000001b6 c00000010dd1225
0
> > > GPR24: c00000000017c08c c00000010727cf00 c00000010dd12278 c00000010dd1221
0
> > > GPR28: 0000000000000001 c00000010be8c000 c000000000ca2008 c00000010be8fa7
0
> > > NIP [c0000000000be9e8] .mutex_remove_waiter+0xa4/0x130
> > > LR [c0000000000be9cc] .mutex_remove_waiter+0x88/0x130
> > > Call Trace:
> > > [c00000010be8f970] [c00000010be8fa00] 0xc00000010be8fa00 (unreliable)
> > > [c00000010be8fa00] [c00000000064a9f0] .mutex_lock_nested+0x384/0x430
> > > Instruction dump:
> > > e81f0010 e93d0000 7fa04800 41fe0028 482e96e5 60000000 2fa30000 419e0018
> > > e93e8008 80090000 2f800000 409e0008<0fe00000>   e93e8000 80090000 2f80000
0
> > > Unable to handle kernel paging request for unknown fault
> > > Faulting instruction address: 0xc00000000008d0f4
> > > Oops: Kernel access of bad area, sig: 7 [#1]
> > > SMP NR_CPUS=1024 NUMA
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > pSeries
> > > last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_ma
p
> > > Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg
> > > sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
> > > NIP: c00000000008d0f4 LR: c00000000008d0d0 CTR: 0000000000000000
> > > REGS: c00000010978f900 TRAP: 0600   Tainted: G        W    (2.6.35-rc3-gi
t4-a
> > utotest)
> > > MSR: 8000000000009032
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
> > > EE,ME,IR,DR>    CR: 24022442  XER: 00000012
> > > DAR: c000000000648f54, DSISR: 0000000040010000
> > > TASK = c0000001096e4900[7353] 'fs_racer_file_s' THREAD: c00000010978c000 
CPU:
> >  10
> > > GPR00: 0000000000004000 c00000010978fb80 c000000000d3d798 000000000000000
1
> > > GPR04: c00000000083539e c000000001610228 0000000000000000 c0000000054c688
0
> > > GPR08: 00000000000006a5 c000000000648f54 0000000000000007 00000000049b000
0
> > > GPR12: 0000000000000000 c00000000f601900 00000000ffffffff fffffffffffffff
f
> > > GPR16: 000000004b7dc520 0000000000000000 0000000000000000 c00000010978fea
0
> > > GPR20: 00000fffcca7e7a0 00000fffcca7e7a0 00000fffabf7dfd0 00000fffabf7dfd
0
> > > GPR24: 0000000000000000 0000000001200011 c000000000e1c0a8 c000000000648ed
4
> > > GPR28: 0000000000000000 c0000001096e4900 c000000000ca0458 c00000010725d40
0
> > > NIP [c00000000008d0f4] .copy_process+0x310/0xf40
> > > LR [c00000000008d0d0] .copy_process+0x2ec/0xf40
> > > Call Trace:
> > > [c00000010978fb80] [c00000000008d0d0] .copy_process+0x2ec/0xf40 (unreliab
le)
> > > [c00000010978fc80] [c00000000008deb4] .do_fork+0x190/0x3cc
> > > [c00000010978fdc0] [c000000000011ef4] .sys_clone+0x58/0x70
> > > [c00000010978fe30] [c0000000000087f0] .ppc_clone+0x8/0xc
> > > Instruction dump:
> > > 419e0010 7fe3fb78 480774cd 60000000 801f0014 e93f0008 7800b842 39290080
> > > 78004800 60000042 901f0014 38004000<7d6048a8>   7d6b0078 7d6049ad 40c2fff
4
> > > 
> > > Kernel version 2.6.34-rc3-git3 works fine.
> > 
> > Should this read 2.6.35-rc3-git3?
> > 
> > If so, there's only about 20 commits in:
> > 5904b3b81d2516..984bc9601f64fd
> > 
> > The likely fs related candidates are from Christoph and Nick Piggin
> > (added to CC)
> > 
> > No commits relating to POWER6 or PPC.
> 
> Not sure what's happening here. The first warning looks like some mutex
> corruption, but it doesn't have a stack trace (these are 2 seperate
> dumps, right? ie. the copy_process stack doesn't relate to the mutex
> warning?) So I don't have much idea.
> 
> If it is reproducable, can you try getting a better stack trace, or
> better yet, even bisecting if there is just a small window?

I can't reproduce the bug here on POWER6 or POWER7.

Divya, can you bisect this?

Mikey
