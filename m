Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2JEV7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2JEV7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:59:33 -0400
Date: Fri, 5 Oct 2012 17:59:29 -0400
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aris@redhat.com
Subject: suspicious RCU usage in cgroup
Message-ID: <20121005215926.GA2406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, aris@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On boot in Linus' current tree..


===============================
[ INFO: suspicious RCU usage. ]
3.6.0+ #22 Not tainted
-------------------------------
include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks on stack by kdevtmpfs/59:
 #0: blocked:  (sb_writers){.+.+.+}, instance: ffff88014595a9a0, at: [<ffffffff81207bc4>] mnt_want_write+0x24/0x50
 #1: held:     (&sb->s_type->i_mutex_key#3/1){+.+.+.}, instance: ffff880145b1f5c8, at: [<ffffffff811f26d4>] kern_path_create+0x84/0x170

stack backtrace:
Pid: 59, comm: kdevtmpfs Not tainted 3.6.0+ #22
Call Trace:
 [<ffffffff810df1f2>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81317cad>] devcgroup_inode_mknod+0x19d/0x240
 [<ffffffff812f54d8>] ? security_capable+0x18/0x20
 [<ffffffff8107e214>] ? ns_capable+0x44/0x80
 [<ffffffff811f3b0e>] vfs_mknod+0x7e/0x140
 [<ffffffff81452967>] handle_create.isra.2+0x77/0x210
 [<ffffffff810ddd6c>] ? lock_release_holdtime.part.26+0xcc/0x140
 [<ffffffff810afbf1>] ? get_parent_ip+0x11/0x50
 [<ffffffff816bacd9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff81452c47>] devtmpfsd+0x147/0x170
 [<ffffffff81452b00>] ? handle_create.isra.2+0x210/0x210
 [<ffffffff8109bf8d>] kthread+0xed/0x100
 [<ffffffff816bacd9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816c04a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810a9fdc>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816b62db>] ? _raw_spin_unlock_irq+0x4b/0x80
 [<ffffffff816b6d37>] ? retint_restore_args+0x13/0x13
 [<ffffffff8109bea0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c04a0>] ? gs_change+0x13/0x13

