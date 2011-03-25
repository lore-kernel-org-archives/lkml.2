Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab1CYHXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:23:54 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47767 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1CYHXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:52 -0400
X-ASG-Debug-ID: 1301037831-03d6a577be00e80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C4304.3050101@fusionio.com>
Date: Fri, 25 Mar 2011 08:23:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <4D8B9D2F.4010504@fusionio.com> <20110324194546.GA1741@gentoo.trippels.de> <4D8BA235.7060904@fusionio.com> <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110324214150.GA1739@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301037831
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58905
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-24 22:41, Markus Trippelsdorf wrote:
> On 2011.03.24 at 22:01 +0100, Jens Axboe wrote:
>> On 2011-03-24 21:06, Markus Trippelsdorf wrote:
>>> On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
>>>>
>>>> OK, still a data point. What was the last -git kernel you used?
>>>
>>> This one was the last and gave me no problems:
>>>
>>> commit b81a618dcd3ea99de292dbe624f41ca68f464376
>>> Merge: 2f284c8 a9712bc
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Wed Mar 23 20:51:42 2011 -0700
>>>
>>>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
>>
>> Puzzling... Poking at straws here so far. Does this make any difference
>> whatsoever?
> 
> I will test your patch later.
> 
> Git-bisect gave me this result thus far:
> 
> 9026e521c0da0731eb31f9f9022dd00cc3cd8885 is bad
> 82f04ab47e1d94d78503591a7460b2cad9601ede is good
> 
> When I continue the bisection with 4345caba340f051e10847924fc078ae18ed6695c
> the system will start normally, but it then silently corrupts my xfs
> partitions. And on next (re)boot I get this (only fixable with
> xfs_repair):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
> IP: [<ffffffff8123cb97>] xfs_cmn_err+0x27/0xc0
> PGD 21c54c067 PUD 21c6bb067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host1/target1:0:0/1:0:0:0/block/sdb/sdb2/alignment_offset
> CPU 3 
> Pid: 1294, comm: rm Not tainted 2.6.38-rc6-00279-g4345cab #25 System manufacturer System Product Name/M4A78T-E
> RIP: 0010:[<ffffffff8123cb97>]  [<ffffffff8123cb97>] xfs_cmn_err+0x27/0xc0
> RSP: 0018:ffff88021c7b9ab8  EFLAGS: 00010246
> RAX: ffff88021c7b9b38 RBX: ffff88021dd14118 RCX: ffffffff8167a348
> RDX: 0000000000000000 RSI: ffffffff816501f0 RDI: 0000000000000008
> RBP: ffff88021c7b9b28 R08: ffffffff81650119 R09: 000000000000058e
> R10: 0000000000000001 R11: 0000000000012de8 R12: ffff88021dcc3340
> R13: 0000000000000075 R14: ffff88021e126c80 R15: 00000000000b0208
> FS:  00007fef28aec700(0000) GS:ffff8800dfd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000000f8 CR3: 000000021c5ae000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rm (pid: 1294, threadinfo ffff88021c7b8000, task ffff88021c566710)
> Stack:
>  ffffffff811f2362 ffff88021dcc3340 ffff88021c7b9b08 ffffffff811f7dab
>  000000000000ea60 ffff88021e173e00 ffff88021c7b9bb4 ffff88021c7b9bb0
>  ffff88021c7b9bac ffff88021e126c80 ffff88021c7b9b48 ffffffff811dadfe
> Call Trace:
>  [<ffffffff811f2362>] ? xfs_btree_rec_addr+0x12/0x20
>  [<ffffffff811f7dab>] ? xfs_btree_get_rec+0x5b/0x90
>  [<ffffffff811dadfe>] ? xfs_alloc_get_rec+0x2e/0x70
>  [<ffffffff812072f0>] xfs_error_report+0x40/0x50
>  [<ffffffff811de274>] ? xfs_free_extent+0x94/0xc0
>  [<ffffffff811dc120>] xfs_free_ag_extent+0x4e0/0x7d0
>  [<ffffffff811de274>] xfs_free_extent+0x94/0xc0
>  [<ffffffff8122d4d5>] ? kmem_zone_alloc+0x85/0xd0
>  [<ffffffff811ee3e4>] xfs_bmap_finish+0x164/0x1b0
>  [<ffffffff8120e6b0>] xfs_itruncate_finish+0x150/0x3f0
>  [<ffffffff8122d4d5>] ? kmem_zone_alloc+0x85/0xd0
>  [<ffffffff8122ae46>] xfs_inactive+0x2d6/0x440
>  [<ffffffff812391ba>] xfs_fs_evict_inode+0xaa/0x130
>  [<ffffffff81133d14>] evict+0x24/0xc0
>  [<ffffffff81134a1b>] iput+0x1ab/0x280
>  [<ffffffff8112a0c6>] do_unlinkat+0x116/0x1c0
>  [<ffffffff811208fa>] ? sys_newfstatat+0x2a/0x40
>  [<ffffffff8112a192>] sys_unlinkat+0x22/0x40
>  [<ffffffff8103ddeb>] system_call_fastpath+0x16/0x1b
> Code: 00 00 00 00 55 48 89 e5 48 83 ec 70 66 66 66 66 90 8b 05 59 d6 4b 00 4c 89 45 f0 4c 89 4d f8 85 c0 74 04 85 c7 75 3e 48 8d 45 10 <48> 8b b2 f8 
> 00 00 00 48 8d 55 c0 48 c7 c7 ce 11 65 81 c7 45 a8 
> RIP  [<ffffffff8123cb97>] xfs_cmn_err+0x27/0xc0
>  RSP <ffff88021c7b9ab8>
> CR2: 00000000000000f8
> ---[ end trace 43fa8028bd7b575e ]--

How confident are you in those bisection results? Not trying to put you
on the spot, just wondering whether you tested and it's completely
consistent, or whether it was a one-off.

In any case, between those commits we the below. Since you get
corruption with noop as well as with cfq, then we can rule out the cfq
and blk-cgroup changes. I'm assuming you don't use the integrity stuff,
so that goes too. And the accounting fix is very straight forward.

Dan Carpenter (1):
      block: NULL dereference on error path in __blkdev_get()

Jens Axboe (2):
      fs: assign sb->s_bdi to default_backing_dev_info if the bdi is
going away
      block: attempt to merge with existing requests on plug flush

Justin TerAvest (3):
      cfq-iosched: Don't update group weights when on service tree
      cfq-iosched: Don't set active queue in preempt
      blk-cgroup: Only give unaccounted_time under debug

Martin K. Petersen (1):
      block: Require subsystems to explicitly allocate bio_set integrity
mempool

Shaohua Li (1):
      block: fix non-atomic access to genhd inflight structures

So the lineup should be down to these three:

Dan Carpenter (1):
      block: NULL dereference on error path in __blkdev_get()

Jens Axboe (2):
      fs: assign sb->s_bdi to default_backing_dev_info if the bdi is
going away
      block: attempt to merge with existing requests on plug flush

Since we already tested the plug merge theory by disabling that part in
elevator.c, it's really down to the sb->s_bdi change or the NULL fix from
Dan.

The sb->s_bdi change is 95f28604a65b1c40b6c6cd95e58439cd7ded3add
The __blkdev_get() is 4345caba340f051e10847924fc078ae18ed6695c

Can you try Linus' tree and just back out both of those, then test? If
it looks good, then apply one then the other to see which one is
screwing this up.

Thanks a lot for your testing!

-- 
Jens Axboe

