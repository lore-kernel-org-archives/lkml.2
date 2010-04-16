Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0DPBlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:41:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab0DPBlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:41:21 -0400
Message-ID: <4BC7C005.2090100@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 09:40:21 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>, Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: lockdep warning on block tree for-2.6.35 branch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I got the following warning when testing.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 3298, comm: find Not tainted 2.6.34-rc4-Vivek-Blkio #48
Call Trace:
 [<c04558bf>] __lock_acquire+0x166/0x789
 [<c0455f76>] lock_acquire+0x94/0xb1
 [<fa7c06d9>] ? blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
 [<c068e1e2>] _raw_spin_lock_irqsave+0x27/0x5a
 [<fa7c06d9>] ? blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
 [<fa7c06d9>] blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
 [<fa816886>] cfq_insert_request+0xdc/0x4f2 [cfq_iosched]
 [<c0451b48>] ? trace_hardirqs_off+0xb/0xd
 [<c052b7e9>] elv_insert+0xe0/0x174
 [<c052b90c>] __elv_add_request+0x8f/0x94
 [<c05314e2>] __make_request+0x357/0x389
 [<c04d6b44>] ? __find_get_block+0x15d/0x167
 [<c052faa0>] generic_make_request+0x27f/0x321
 [<c0491017>] ? mempool_alloc_slab+0xe/0x10
 [<c0491287>] ? mempool_alloc+0x3c/0xd7
 [<c0531186>] submit_bio+0x8a/0x8f
 [<c04da90a>] ? bio_alloc_bioset+0x37/0x96
 [<c04d656f>] submit_bh+0xf0/0x10f
 [<c04d7556>] ll_rw_block+0xc0/0xf9
 [<f86e717c>] ext3_bread+0x34/0x7b [ext3]
 [<f86ea875>] htree_dirblock_to_tree+0x1f/0x120 [ext3]
 [<f86ea9f0>] ext3_htree_fill_tree+0x7a/0x1bb [ext3]
 [<c0453147>] ? mark_held_locks+0x3d/0x58
 [<c04b29ce>] ? kmem_cache_alloc_notrace+0x86/0xaa
 [<c0453269>] ? trace_hardirqs_on_caller+0x107/0x12f
 [<f86e3b53>] ext3_readdir+0x1f9/0x69e [ext3]
 [<c04c68ec>] ? filldir64+0x0/0xcd
 [<c068d4fe>] ? mutex_lock_killable_nested+0x2c5/0x2d9
 [<c0450b5f>] ? debug_mutex_free_waiter+0x45/0x48
 [<c068d508>] ? mutex_lock_killable_nested+0x2cf/0x2d9
 [<c04c6ac7>] ? vfs_readdir+0x46/0x94
 [<c04c6ae9>] vfs_readdir+0x68/0x94
 [<c04c68ec>] ? filldir64+0x0/0xcd
 [<c04c6b73>] sys_getdents64+0x5e/0x9f
 [<c040274c>] sysenter_do_call+0x12/0x32

Thanks,
Gui

