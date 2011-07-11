Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1GKMhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:37:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59471 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1GKMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:37:53 -0400
X-Nat-Received: from [202.181.97.72]:58765 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1310387871.2040
To: linux-kernel@vger.kernel.org
Subject: [3.0.0-rc6-git7] possible recursive locking at cache_alloc_refill
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201107112137.FAD00545.SHtLOFOJOMFQFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 11 Jul 2011 21:37:45 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 11072011 #5539294, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got this on CentOS 6. Is this known?

[   13.539510] 
[   13.539525] =============================================
[   13.540663] [ INFO: possible recursive locking detected ]
[   13.540663] 3.0.0-rc6-git7 #1
[   13.540663] ---------------------------------------------
[   13.540663] udevd/2017 is trying to acquire lock:
[   13.540663]  (&(&parent->list_lock)->rlock){-.-...}, at: [<c10c66c6>] cache_alloc_refill+0x66/0x2e0
[   13.540663] 
[   13.540663] but task is already holding lock:
[   13.540663]  (&(&parent->list_lock)->rlock){-.-...}, at: [<c10c5ad3>] cache_flusharray+0x43/0x110
[   13.540663] 
[   13.540663] other info that might help us debug this:
[   13.540663]  Possible unsafe locking scenario:
[   13.540663] 
[   13.540663]        CPU0
[   13.540663]        ----
[   13.540663]   lock(&(&parent->list_lock)->rlock);
[   13.540663]   lock(&(&parent->list_lock)->rlock);
[   13.540663] 
[   13.540663]  *** DEADLOCK ***
[   13.540663] 
[   13.540663]  May be due to missing lock nesting notation
[   13.540663] 
[   13.540663] 1 lock held by udevd/2017:
[   13.540663]  #0:  (&(&parent->list_lock)->rlock){-.-...}, at: [<c10c5ad3>] cache_flusharray+0x43/0x110
[   13.540663] 
[   13.540663] stack backtrace:
[   13.540663] Pid: 2017, comm: udevd Not tainted 3.0.0-rc6-git7 #1
[   13.540663] Call Trace:
[   13.540663]  [<c106b54e>] print_deadlock_bug+0xce/0xe0
[   13.540663]  [<c106d5fa>] validate_chain+0x5aa/0x720
[   13.540663]  [<c106da07>] __lock_acquire+0x297/0x480
[   13.540663]  [<c106e15b>] lock_acquire+0x7b/0xa0
[   13.540663]  [<c10c66c6>] ? cache_alloc_refill+0x66/0x2e0
[   13.540663]  [<c13ca4e6>] _raw_spin_lock+0x36/0x70
[   13.540663]  [<c10c66c6>] ? cache_alloc_refill+0x66/0x2e0
[   13.540663]  [<c11f6ac6>] ? __debug_object_init+0x346/0x360
[   13.540663]  [<c10c66c6>] cache_alloc_refill+0x66/0x2e0
[   13.540663]  [<c106da25>] ? __lock_acquire+0x2b5/0x480
[   13.540663]  [<c11f6ac6>] ? __debug_object_init+0x346/0x360
[   13.540663]  [<c10c635f>] kmem_cache_alloc+0x11f/0x140
[   13.540663]  [<c11f6ac6>] __debug_object_init+0x346/0x360
[   13.540663]  [<c106df62>] ? __lock_release+0x72/0x180
[   13.540663]  [<c11f6365>] ? debug_object_activate+0x85/0x130
[   13.540663]  [<c11f6b17>] debug_object_init+0x17/0x20
[   13.540663]  [<c10543da>] rcuhead_fixup_activate+0x1a/0x60
[   13.540663]  [<c11f6375>] debug_object_activate+0x95/0x130
[   13.540663]  [<c10c60a0>] ? kmem_cache_shrink+0x50/0x50
[   13.540663]  [<c108e60a>] __call_rcu+0x2a/0x180
[   13.540663]  [<c10c48b0>] ? slab_destroy_debugcheck+0x70/0x110
[   13.540663]  [<c108e77d>] call_rcu_sched+0xd/0x10
[   13.540663]  [<c10c58d3>] slab_destroy+0x73/0x80
[   13.540663]  [<c10c591f>] free_block+0x3f/0x1b0
[   13.540663]  [<c10c5ad3>] ? cache_flusharray+0x43/0x110
[   13.540663]  [<c10c5b03>] cache_flusharray+0x73/0x110
[   13.540663]  [<c10c5847>] kmem_cache_free+0xb7/0xd0
[   13.540663]  [<c10bbfb9>] __put_anon_vma+0x49/0xa0
[   13.540663]  [<c10bc5dc>] unlink_anon_vmas+0xfc/0x160
[   13.540663]  [<c10b451c>] free_pgtables+0x3c/0x90
[   13.540663]  [<c10b9a8f>] exit_mmap+0xbf/0xf0
[   13.540663]  [<c1039d3c>] mmput+0x4c/0xc0
[   13.540663]  [<c103d9bc>] exit_mm+0xec/0x130
[   13.540663]  [<c13cadc2>] ? _raw_spin_unlock_irq+0x22/0x30
[   13.540663]  [<c103fa03>] do_exit+0x123/0x390
[   13.540663]  [<c10cb9c5>] ? fput+0x15/0x20
[   13.540663]  [<c10c7c2d>] ? filp_close+0x4d/0x80
[   13.540663]  [<c103fca9>] do_group_exit+0x39/0xa0
[   13.540663]  [<c103fd23>] sys_exit_group+0x13/0x20
[   13.540663]  [<c13cb70c>] sysenter_do_call+0x12/0x32
