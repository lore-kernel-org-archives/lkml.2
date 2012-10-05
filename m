Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2JEWyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:54:35 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:35157 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JEWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:54:33 -0400
Message-ID: <506F649F.4050109@opensuse.org>
Date: Fri, 05 Oct 2012 19:52:15 -0300
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
I am getting this in the current linus tree.

[    0.408781] ===============================
[    0.408783] [ INFO: suspicious RCU usage. ]
[    0.408786] 3.6.0-canneverbe-07124-g5f3d2f2 #18 Not tainted
[    0.408789] -------------------------------
[    0.408791] include/linux/cgroup.h:566 suspicious
rcu_dereference_check() usage!
[    0.408795]
[    0.408795] other info that might help us debug this:
[    0.408795]
[    0.408799]
[    0.408799] rcu_scheduler_active = 1, debug_locks = 0
[    0.408802] 2 locks held by kdevtmpfs/49:
[    0.408804]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff8119a2ef>]
mnt_want_write+0x1f/0x50
[    0.408814]  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at:
[<ffffffff811857cf>] kern_path_create+0x7f/0x170
[    0.408822]
[    0.408822] stack backtrace:
[    0.408825] Pid: 49, comm: kdevtmpfs Not tainted
3.6.0-canneverbe-07124-g5f3d2f2 #18
[    0.408829] Call Trace:
[    0.408834]  [<ffffffff8109fabd>] lockdep_rcu_suspicious+0xfd/0x130
[    0.408838]  [<ffffffff812a876d>] devcgroup_inode_mknod+0x18d/0x230
[    0.408843]  [<ffffffff8126f923>] ? security_capable+0x13/0x20
[    0.408848]  [<ffffffff8104a06f>] ? ns_capable+0x3f/0x80
[    0.408851]  [<ffffffff81186c09>] vfs_mknod+0x79/0x140
[    0.408856]  [<ffffffff813a6df2>] handle_create.isra.2+0x72/0x200
[    0.408860]  [<ffffffff813a702c>] ? devtmpfsd+0xac/0x140
[    0.408863]  [<ffffffff813a7094>] devtmpfsd+0x114/0x140
[    0.408867]  [<ffffffff813a6f80>] ? handle_create.isra.2+0x200/0x200
[    0.408871]  [<ffffffff81064de6>] kthread+0xd6/0xe0
[    0.408877]  [<ffffffff81578cb4>] kernel_thread_helper+0x4/0x10
[    0.408881]  [<ffffffff8156f85c>] ? retint_restore_args+0xe/0xe
[    0.408885]  [<ffffffff81064d10>] ? flush_kthread_work+0x190/0x190
[    0.408889]  [<ffffffff81578cb0>] ? gs_change+0xb/0xb


Hope someone can take a look at it.
