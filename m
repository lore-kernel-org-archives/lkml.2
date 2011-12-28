Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1L1WAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 17:00:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1L1WAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 17:00:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: Freezing of tasks failed after 20.01 seconds in 3.2.0-rc4+ (Linus GIT af968e2)
Date: Wed, 28 Dec 2011 23:03:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, Miles Lane <miles.lane@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <CAHFgRy_AdA7iKzCwNvXiE3pR1dqdkuKPgT0soWjw8E_TcLjJtA@mail.gmail.com> <4EFAAFEF.6070503@linux.vnet.ibm.com>
In-Reply-To: <4EFAAFEF.6070503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112282303.26978.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 28, 2011, Srivatsa S. Bhat wrote:
> Hi,
> 
> Miles Lane (in CC) hit freezing failures in 3.2.0-rc4+ (Linus GIT af968e2)
> while trying to suspend the machine.

Well, ext3 seems to be involved.  I don't see any problems with suspending
those kernels on my test machines, but I don't use ext3 on them any more.

It would be good to rule out ext3 somehow.

Thanks,
Rafael


> Here is the log:
> 
> [ 4040.037426] Freezing user space processes ...
> [ 4060.048526] Freezing of tasks failed after 20.01 seconds (2 tasks
> refusing to freeze, wq_busy=0):
> [ 4060.048534] Xorg            D ffffffff81806240     0   901    847 0x00c00004
> [ 4060.048538]  ffff8800c3877628 0000000000000086 0000000000000082
> ffff8800c38775d8
> [ 4060.048551]  ffff8800c3877fd8 ffff8800c3877fd8 ffff8800c3877fd8
> 00000000000136c0
> [ 4060.048553]  ffff880118b3dc40 ffff8800c2cc1710 ffff8800c38775f8
> ffff88011fb13f80
> [ 4060.048556] Call Trace:
> [ 4060.048562]  [<ffffffff811a6940>] ? __wait_on_buffer+0x30/0x30
> [ 4060.048565]  [<ffffffff8165094f>] schedule+0x3f/0x60
> [ 4060.048567]  [<ffffffff816509ff>] io_schedule+0x8f/0xd0
> [ 4060.048569]  [<ffffffff811a694e>] sleep_on_buffer+0xe/0x20
> [ 4060.048571]  [<ffffffff8165121f>] __wait_on_bit+0x5f/0x90
> [ 4060.048574]  [<ffffffff812ebf08>] ? generic_make_request+0x68/0x70
> [ 4060.048577]  [<ffffffff811a6940>] ? __wait_on_buffer+0x30/0x30
> [ 4060.048579]  [<ffffffff816512cc>] out_of_line_wait_on_bit+0x7c/0x90
> [ 4060.048582]  [<ffffffff81089c90>] ? autoremove_wake_function+0x40/0x40
> [ 4060.048584]  [<ffffffff811a693e>] __wait_on_buffer+0x2e/0x30
> [ 4060.048587]  [<ffffffff811a8761>] __bread+0x71/0xb0
> [ 4060.048590]  [<ffffffff811f377b>] ext3_get_branch+0x8b/0x150
> [ 4060.048593]  [<ffffffff811f6912>] ext3_get_blocks_handle+0x1a2/0x650
> [ 4060.048595]  [<ffffffff811a8d65>] ? block_read_full_page+0x225/0x390
> [ 4060.048598]  [<ffffffff811f6e84>] ext3_get_block+0xc4/0x120
> [ 4060.048600]  [<ffffffff811b2172>] do_mpage_readpage+0x3b2/0x550
> [ 4060.048604]  [<ffffffff81116d95>] ? add_to_page_cache_locked+0x85/0xa0
> [ 4060.048606]  [<ffffffff811b246e>] mpage_readpages+0xee/0x140
> [ 4060.048608]  [<ffffffff811f6dc0>] ? ext3_get_blocks_handle+0x650/0x650
> [ 4060.048610]  [<ffffffff8111f3de>] ? __alloc_pages_nodemask+0x10e/0x820
> [ 4060.048613]  [<ffffffff811f6dc0>] ? ext3_get_blocks_handle+0x650/0x650
> [ 4060.048615]  [<ffffffff811f328d>] ext3_readpages+0x1d/0x20
> [ 4060.048617]  [<ffffffff81121908>] read_pages+0x48/0x100
> [ 4060.048619]  [<ffffffff81121b23>] __do_page_cache_readahead+0x163/0x180
> [ 4060.048621]  [<ffffffff81121e91>] ra_submit+0x21/0x30
> [ 4060.048625]  [<ffffffff8163d353>] do_sync_mmap_readahead.isra.24+0x94/0x9c
> [ 4060.048627]  [<ffffffff81118991>] filemap_fault+0x361/0x3e0
> [ 4060.048642]  [<ffffffffa009c37c>] ? drm_mm_kmalloc+0x6c/0xe0 [drm]
> [ 4060.048646]  [<ffffffff81138c72>] __do_fault+0x72/0x550
> [ 4060.048649]  [<ffffffff8130ae7b>] ? prio_tree_insert+0x12b/0x1a0
> [ 4060.048651]  [<ffffffff8113c2aa>] handle_pte_fault+0xfa/0x200
> [ 4060.048653]  [<ffffffff8113c768>] handle_mm_fault+0x1f8/0x350
> [ 4060.048661]  [<ffffffffa00dced0>] ?
> i915_gem_object_set_to_gtt_domain+0x80/0x80 [i915]
> [ 4060.048664]  [<ffffffff816562d0>] do_page_fault+0x150/0x520
> [ 4060.048668]  [<ffffffff810127da>] ? __switch_to+0x1ea/0x310
> [ 4060.048670]  [<ffffffff81054f4d>] ? set_next_entity+0xad/0xd0
> [ 4060.048673]  [<ffffffff8118821a>] ? do_vfs_ioctl+0x8a/0x340
> [ 4060.048675]  [<ffffffff816502fc>] ? __schedule+0x3cc/0x6f0
> [ 4060.048677]  [<ffffffff81652fb5>] page_fault+0x25/0x30
> [ 4060.048685] gnome-settings- D 0000000000000001     0  1406   1344 0x00800004
> [ 4060.048687]  ffff8800bd305628 0000000000000082 0000000000000082
> ffff8800bd3055d8
> [ 4060.048689]  ffff8800bd305fd8 ffff8800bd305fd8 ffff8800bd305fd8
> 00000000000136c0
> [ 4060.048692]  ffff8800885cdc40 ffff8800c1228000 ffff8800bd3055f8
> ffff88011fa93f80
> [ 4060.048694] Call Trace:
> [ 4060.048696]  [<ffffffff811a6940>] ? __wait_on_buffer+0x30/0x30
> [ 4060.048698]  [<ffffffff8165094f>] schedule+0x3f/0x60
> [ 4060.048700]  [<ffffffff816509ff>] io_schedule+0x8f/0xd0
> [ 4060.048702]  [<ffffffff811a694e>] sleep_on_buffer+0xe/0x20
> [ 4060.048704]  [<ffffffff8165121f>] __wait_on_bit+0x5f/0x90
> [ 4060.048706]  [<ffffffff812ebf08>] ? generic_make_request+0x68/0x70
> [ 4060.048708]  [<ffffffff811a6940>] ? __wait_on_buffer+0x30/0x30
> [ 4060.048710]  [<ffffffff816512cc>] out_of_line_wait_on_bit+0x7c/0x90
> [ 4060.048712]  [<ffffffff81089c90>] ? autoremove_wake_function+0x40/0x40
> [ 4060.048714]  [<ffffffff811a693e>] __wait_on_buffer+0x2e/0x30
> [ 4060.048716]  [<ffffffff811a8761>] __bread+0x71/0xb0
> [ 4060.048719]  [<ffffffff811f377b>] ext3_get_branch+0x8b/0x150
> [ 4060.048721]  [<ffffffff811f6912>] ext3_get_blocks_handle+0x1a2/0x650
> [ 4060.048724]  [<ffffffff8104cd93>] ? __wake_up+0x53/0x70
> [ 4060.048727]  [<ffffffff814072a5>] ? loop_make_request+0xe5/0x120
> [ 4060.048729]  [<ffffffff812ebaf4>] ? generic_make_request.part.50+0x74/0xb0
> [ 4060.048732]  [<ffffffff811f6e84>] ext3_get_block+0xc4/0x120
> [ 4060.048734]  [<ffffffff811b2172>] do_mpage_readpage+0x3b2/0x550
> [ 4060.048736]  [<ffffffff81116d95>] ? add_to_page_cache_locked+0x85/0xa0
> [ 4060.048738]  [<ffffffff811b246e>] mpage_readpages+0xee/0x140
> [ 4060.048740]  [<ffffffff811f6dc0>] ? ext3_get_blocks_handle+0x650/0x650
> [ 4060.048742]  [<ffffffff8111f3de>] ? __alloc_pages_nodemask+0x10e/0x820
> [ 4060.048744]  [<ffffffff811f6dc0>] ? ext3_get_blocks_handle+0x650/0x650
> [ 4060.048747]  [<ffffffff8165135d>] ? mutex_lock+0x1d/0x50
> [ 4060.048749]  [<ffffffff811f328d>] ext3_readpages+0x1d/0x20
> [ 4060.048751]  [<ffffffff81121908>] read_pages+0x48/0x100
> [ 4060.048753]  [<ffffffff81121b23>] __do_page_cache_readahead+0x163/0x180
> [ 4060.048755]  [<ffffffff81121e91>] ra_submit+0x21/0x30
> [ 4060.048757]  [<ffffffff8163d353>] do_sync_mmap_readahead.isra.24+0x94/0x9c
> [ 4060.048759]  [<ffffffff81118991>] filemap_fault+0x361/0x3e0
> [ 4060.048761]  [<ffffffff81188fe0>] ? __pollwait+0xf0/0xf0
> [ 4060.048764]  [<ffffffff81138c72>] __do_fault+0x72/0x550
> [ 4060.048766]  [<ffffffff8113c2aa>] handle_pte_fault+0xfa/0x200
> [ 4060.048767]  [<ffffffff8113c768>] handle_mm_fault+0x1f8/0x350
> [ 4060.048769]  [<ffffffff816562d0>] do_page_fault+0x150/0x520
> [ 4060.048773]  [<ffffffff8129a2b3>] ? security_file_permission+0x93/0xb0
> [ 4060.048777]  [<ffffffff81175f41>] ? rw_verify_area+0x61/0xf0
> [ 4060.048778]  [<ffffffff811764d5>] ? vfs_read+0x165/0x180
> [ 4060.048780]  [<ffffffff81652fb5>] page_fault+0x25/0x30
> 
> Regards,
> Srivatsa S. Bhat
> 
> 
> 

