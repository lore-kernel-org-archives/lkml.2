Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0ESTUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:20:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38530 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0ESTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=BXIGOxY8EWwsYTfwg3/RVGR13IizYFcPBN+B+ztFff6/640yYIl9a17KdVCiVZ63DG
         Tu6nUQhVzDdzDlfTbYPkc+L2UZ8EhAJXlCb5MzdbB+2h6KLxMkIhPt72qSLsyzoZGZ22
         44Qf5Wl2u606NiJdmWyL+UfCGTS67cPXgnj1E=
Date: Wed, 19 May 2010 21:19:45 +0200 (CEST)
From: John Kacur <jkacur@gmail.com>
X-X-Sender: jkacur@localhost
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: 2.6.33.4-rt20 inconsistent lock state
Message-ID: <alpine.LFD.2.00.1005192112030.14774@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=================================
[ INFO: inconsistent lock state ]
2.6.33.4-rt20-debug #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/416 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<ffffffffa0215cc3>] 
xfs_ilock+0x42/
0x15a [xfs]
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff810a4dac>] mark_held_locks+0x52/0x70
  [<ffffffff810a4e6e>] lockdep_trace_alloc+0xa4/0xc1
  [<ffffffff81128e12>] __alloc_pages_nodemask+0xe8/0xc9e
  [<ffffffff8116758f>] alloc_pages_current+0xc7/0xd0
  [<ffffffff8111f08e>] __page_cache_alloc+0xd0/0xd9
  [<ffffffff8111f3b3>] grab_cache_page_write_begin+0xb6/0x17c
  [<ffffffff811b4a0c>] block_write_begin+0x54/0x180
  [<ffffffffa023fe01>] xfs_vm_write_begin+0x2a/0x2c [xfs]
  [<ffffffff8111dab2>] generic_file_buffered_write+0x147/0x3a8
  [<ffffffffa024a766>] xfs_write+0x950/0xce3 [xfs]
  [<ffffffffa0244aab>] xfs_file_aio_write+0xdb/0xe7 [xfs]
  [<ffffffff81179a3e>] do_sync_write+0xd0/0x143
  [<ffffffff8117aa5b>] vfs_write+0x161/0x1cf
  [<ffffffff8117abe8>] sys_write+0x63/0x8a
  [<ffffffff8100379b>] system_call_fastpath+0x16/0x1b
irq event stamp: 3763347
hardirqs last  enabled at (3763347): [<ffffffff81521b35>] 
_raw_spin_unlock_irqre
store+0x5b/0xab
hardirqs last disabled at (3763346): [<ffffffff81521928>] 
_raw_spin_lock_irqsave
+0x1e/0x9c
softirqs last  enabled at (0): [<ffffffff8105ff2a>] 
copy_process+0x827/0x1d66
softirqs last disabled at (0): [<(null)>] (null)

other info that might help us debug this:
2 locks held by kswapd0/416:
 #0:  (shrinker_rwsem){+.+...}, at: [<ffffffff81132cfb>] 
shrink_slab+0x53/0x21b
 #1:  (&xfs_mount_list_lock){++++.-}, at: [<ffffffff810b2327>] 
rt_down_read+0x10
/0x12

stack backtrace:
Pid: 416, comm: kswapd0 Not tainted 2.6.33.4-rt20-debug #1
Call Trace:
 [<ffffffff810a4b18>] valid_state+0x178/0x18b
 [<ffffffff81013713>] ? save_stack_trace+0x2f/0x62
 [<ffffffff810a53be>] ? check_usage_forwards+0x0/0x8e
 [<ffffffff810a4c3e>] mark_lock+0x113/0x22f
 [<ffffffff810a5e73>] __lock_acquire+0x3a5/0xd32
 [<ffffffff8151feb6>] ? rt_spin_lock_slowunlock+0x6a/0x94
 [<ffffffff810a4b58>] ? mark_lock+0x2d/0x22f
 [<ffffffffa0215cc3>] ? xfs_ilock+0x42/0x15a [xfs]
 [<ffffffff810a723e>] lock_acquire+0xd4/0xf1
 [<ffffffffa0215cc3>] ? xfs_ilock+0x42/0x15a [xfs]
 [<ffffffff81093783>] anon_down_write_nested+0x4f/0x9d
 [<ffffffffa0215cc3>] ? xfs_ilock+0x42/0x15a [xfs]
 [<ffffffff810b0854>] ? rt_spin_lock_fastunlock.clone.0+0x71/0x7a
 [<ffffffffa0215cc3>] xfs_ilock+0x42/0x15a [xfs]
 [<ffffffffa0215fe4>] xfs_ireclaim+0xae/0xcc [xfs]
 [<ffffffffa024e85c>] xfs_reclaim_inode+0x138/0x146 [xfs]
 [<ffffffffa024f72d>] xfs_inode_ag_walk+0xf9/0x1c5 [xfs]
 [<ffffffffa024e724>] ? xfs_reclaim_inode+0x0/0x146 [xfs]
 [<ffffffffa024f8b1>] xfs_inode_ag_iterator+0xb8/0x178 [xfs]
 [<ffffffffa024e724>] ? xfs_reclaim_inode+0x0/0x146 [xfs]
 [<ffffffff810b2327>] ? rt_down_read+0x10/0x12
 [<ffffffffa024fa0b>] xfs_reclaim_inode_shrink+0x9a/0x1a0 [xfs]
 [<ffffffff81132df9>] shrink_slab+0x151/0x21b
 [<ffffffff8113373d>] balance_pgdat+0x4a0/0x798
 [<ffffffff8112fa10>] ? isolate_pages_global+0x0/0x337
 [<ffffffff81133d14>] kswapd+0x2df/0x2f5
 [<ffffffff8108cdd6>] ? autoremove_wake_function+0x0/0x4f
 [<ffffffff810449cd>] ? need_resched+0x3f/0x45
 [<ffffffff81133a35>] ? kswapd+0x0/0x2f5
 [<ffffffff8108c8f6>] kthread+0xa4/0xac
 [<ffffffff810045d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81522100>] ? restore_args+0x0/0x30
 [<ffffffff8108c852>] ? kthread+0x0/0xac
 [<ffffffff810045d0>] ? kernel_thread_helper+0x0/0x10

