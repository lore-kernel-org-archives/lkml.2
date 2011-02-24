Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1BXSL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1BXSLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:11:47 -0500
Date: Thu, 24 Feb 2011 13:11:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6 v5.1] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
Message-ID: <20110224181140.GE18494@redhat.com>
References: <4D61FE91.60705@cn.fujitsu.com>
 <4D6201A3.70301@cn.fujitsu.com>
 <4D64788F.6040408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D64788F.6040408@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:01:35AM +0800, Gui Jianfeng wrote:
> Hi
> 
> I rebase this series on top of *for-next* branch, it will make merging life easier.
> 
> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
> in the way that it puts all CFQ queues in a hidden group and schedules with other 
> CFQ group under their parent. The patchset is available here,
> http://lkml.org/lkml/2010/8/30/30

Gui,

I was running some tests (iostest) with these patches and my system crashed
after a while.

To be precise I was running "brrmmap" test of iostest.

train.lab.bos.redhat.com login: [72194.404201] EXT4-fs (dm-1): mounted
filesystem with ordered data mode. Opts: (null)
[72642.818976] EXT4-fs (dm-1): mounted filesystem with ordered data mode.
Opts: (null)
[72931.409460] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[72931.410216] IP: [<ffffffff812265ff>] __rb_rotate_left+0xb/0x64
[72931.410216] PGD 134d80067 PUD 12f524067 PMD 0 
[72931.410216] Oops: 0000 [#1] SMP 
[72931.410216] last sysfs file:
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
[72931.410216] CPU 3 
[72931.410216] Modules linked in: kvm_intel kvm qla2xxx scsi_transport_fc
[last unloaded: scsi_wait_scan]
[72931.410216] 
[72931.410216] Pid: 18675, comm: sh Not tainted 2.6.38-rc4+ #3 0A98h/HP
xw8600 Workstation
[72931.410216] RIP: 0010:[<ffffffff812265ff>]  [<ffffffff812265ff>]
__rb_rotate_left+0xb/0x64
[72931.410216] RSP: 0000:ffff88012f461480  EFLAGS: 00010086
[72931.410216] RAX: 0000000000000000 RBX: ffff880135f40c00 RCX:
ffffffffffffdcc8
[72931.410216] RDX: ffff880135f43800 RSI: ffff880135f43000 RDI:
ffff880135f42c00
[72931.410216] RBP: ffff88012f461480 R08: ffff880135f40c00 R09:
ffff880135f43018
[72931.410216] R10: 0000000000000000 R11: 0000001000000000 R12:
ffff880135f42c00
[72931.410216] R13: ffff880135f41808 R14: ffff880135f43000 R15:
ffff880135f40c00
[72931.410216] FS:  0000000000000000(0000) GS:ffff8800bfcc0000(0000)
knlGS:0000000000000000
[72931.410216] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[72931.410216] CR2: 0000000000000010 CR3: 000000013774f000 CR4:
00000000000006e0
[72931.410216] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[72931.410216] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[72931.410216] Process sh (pid: 18675, threadinfo ffff88012f460000, task
ffff8801376e6f90)
[72931.410216] Stack:
[72931.410216]  ffff88012f4614b8 ffffffff81226778 ffff880135f43000
ffff880135f43000
[72931.410216]  ffff88011c5bed00 0000000000000000 0000000000000001
ffff88012f4614d8
[72931.410216]  ffffffff8121c521 0000001000000000 ffff880135f41800
ffff88012f461528
[72931.410216] Call Trace:
[72931.410216]  [<ffffffff81226778>] rb_insert_color+0xbc/0xe5
[72931.410216]  [<ffffffff8121c521>]
__cfq_entity_service_tree_add+0x76/0xa5
[72931.410216]  [<ffffffff8121cb28>] cfq_service_tree_add+0x383/0x3eb
[72931.410216]  [<ffffffff8121cbaa>] cfq_resort_rr_list+0x1a/0x2a
[72931.410216]  [<ffffffff8121eb06>] cfq_add_rq_rb+0xbd/0xff
[72931.410216]  [<ffffffff8121ec0a>] cfq_insert_request+0xc2/0x556
[72931.410216]  [<ffffffff8120a44c>] elv_insert+0x118/0x188
[72931.410216]  [<ffffffff8120a52a>] __elv_add_request+0x6e/0x75
[72931.410216]  [<ffffffff812102d0>] __make_request+0x3ac/0x42f
[72931.410216]  [<ffffffff8120e9ca>] generic_make_request+0x2ec/0x356
[72931.410216]  [<ffffffff8120eb05>] submit_bio+0xd1/0xdc
[72931.410216]  [<ffffffff8110bea3>] submit_bh+0xe6/0x108
[72931.410216]  [<ffffffff8110eb9d>] __bread+0x4c/0x6f
[72931.410216]  [<ffffffff811453ab>] ext3_get_branch+0x64/0xdf
[72931.410216]  [<ffffffff81146f5c>] ext3_get_blocks_handle+0x9b/0x90b
[72931.410216]  [<ffffffff81147882>] ext3_get_block+0xb6/0xf6
[72931.410216]  [<ffffffff81113520>] do_mpage_readpage+0x198/0x4bd
[72931.410216]  [<ffffffff810c01b2>] ? __inc_zone_page_state+0x29/0x2b
[72931.410216]  [<ffffffff810ab6e4>] ? add_to_page_cache_locked+0xb6/0x10d
[72931.410216]  [<ffffffff81113980>] mpage_readpages+0xd6/0x123
[72931.410216]  [<ffffffff811477cc>] ? ext3_get_block+0x0/0xf6
[72931.410216]  [<ffffffff811477cc>] ? ext3_get_block+0x0/0xf6
[72931.410216]  [<ffffffff810da750>] ? alloc_pages_current+0xa2/0xc5
[72931.410216]  [<ffffffff81145a6a>] ext3_readpages+0x18/0x1a
[72931.410216]  [<ffffffff810b31fc>] __do_page_cache_readahead+0x111/0x1a7
[72931.410216]  [<ffffffff810b32ae>] ra_submit+0x1c/0x20
[72931.410216]  [<ffffffff810acb1b>] filemap_fault+0x165/0x35b
[72931.410216]  [<ffffffff810c6ce1>] __do_fault+0x50/0x3e2
[72931.410216]  [<ffffffff810c7cf8>] handle_pte_fault+0x2ff/0x779
[72931.410216]  [<ffffffff810b05c9>] ? __free_pages+0x1b/0x24
[72931.410216]  [<ffffffff810c82d1>] handle_mm_fault+0x15f/0x173
[72931.410216]  [<ffffffff815b0963>] do_page_fault+0x348/0x36a
[72931.410216]  [<ffffffff810f21c5>] ? path_put+0x1d/0x21
[72931.410216]  [<ffffffff810f21c5>] ? path_put+0x1d/0x21
[72931.410216]  [<ffffffff815adf1f>] page_fault+0x1f/0x30
[72931.410216] Code: 48 83 c4 18 44 89 e8 5b 41 5c 41 5d c9 c3 48 83 7b 18
00 0f 84 71 ff ff ff e9 77 ff ff ff 90 90 48 8b 47 08 55 48 8b 17 48 89 e5
<48> 8b 48 10 48 83 e2 fc 48 85 c9 48 89 4f 08 74 10 4c 8b 40 10 
[72931.410216] RIP  [<ffffffff812265ff>] __rb_rotate_left+0xb/0x64
[72931.410216]  RSP <ffff88012f461480>
[72931.410216] CR2: 0000000000000010
[72931.410216] ---[ end trace cddc7a4456407f6a ]---

Thanks
Vivek

> 
> Vivek think this approach isn't so instinct that we should treat CFQ queues
> and groups at the same level. Here is the new approach for hierarchical 
> scheduling based on Vivek's suggestion. The most big change of CFQ is that
> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
> queue scheduling just like CFQ group does. But I still give cfqq some jump 
> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
> queue and CFQ group use the same scheduling algorithm. 
> 
> "use_hierarchy" interface is now added to switch between hierarchical mode
> and flat mode. It works as memcg.
> 
> V4 -> V5 Changes:
> - Change boosting base to a smaller value.
> - Rename repostion_time to position_time
> - Replace duplicated code by calling cfq_scale_slice()
> - Remove redundant use_hierarchy in cfqd
> - Fix grp_service_tree comment
> - Rename init_cfqe() to init_group_cfqe()
> 
> --
> V3 -> V4 Changes:
> - Take io class into account when calculating the boost value.
> - Refine the vtime boosting logic as Vivek's Suggestion.
> - Make the calculation of group slice cross all service trees under a group.
> - Modify Documentation in terms of Vivek's comments.
> 
> --
> V2 -> V3 Changes:
> - Starting from cfqd->grp_service_tree for both hierarchical mode and flat mode
> - Avoid recursion when allocating cfqg and force dispatch logic
> - Fix a bug when boosting vdisktime
> - Adjusting total_weight accordingly when changing weight
> - Change group slice calculation into a hierarchical way
> - Keep flat mode rather than deleting it first then adding it later
> - kfree the parent cfqg if there nobody references to it
> - Simplify select_queue logic by using some wrap function
> - Make "use_hierarchy" interface work as memcg
> - Make use of time_before() for vdisktime compare
> - Update Document
> - Fix some code style problems
> 
> --
> V1 -> V2 Changes:
> - Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
>   queue_entity and group_entity, just use cfqe instead.
> - Give newly added cfqq a small vdisktime jump accord to its ioprio.
> - Make flat mode as default CFQ group scheduling mode.
> - Introduce "use_hierarchy" interface.
> - Update blkio cgroup documents
> 
>  Documentation/cgroups/blkio-controller.txt |   81 +-
>  block/blk-cgroup.c                         |   61 +
>  block/blk-cgroup.h                         |    3
>  block/cfq-iosched.c                        |  959 ++++++++++++++++++++---------
>  4 files changed, 815 insertions(+), 289 deletions(-)
> 
> Thanks,
> Gui
