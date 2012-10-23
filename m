Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2JWNup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:50:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43748 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2JWNuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:50:44 -0400
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 09:50:42 -0400
Message-ID: <CAHFgRy_oKH2iMLC39JfGDaO9sziHwcXOpctuncKHssh5BQM0Cw@mail.gmail.com>
Subject: GIT 3.7.0-rc2+ -- INFO: suspicious RCU usage -- include/linux/cgroup.h:566
 suspicious rcu_dereference_check() usage!
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    3.110632] [ INFO: suspicious RCU usage. ]
[    3.110632] 3.7.0-rc2+ #44 Not tainted
[    3.110632] -------------------------------
[    3.110632] include/linux/cgroup.h:566 suspicious
rcu_dereference_check() usage!
[    3.110632]
[    3.110632] other info that might help us debug this:
[    3.110632]
[    3.110632]
[    3.110632] rcu_scheduler_active = 1, debug_locks = 1
[    3.110632] 2 locks held by kdevtmpfs/22:
[    3.110632]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff810f896e>]
mnt_want_write+0x1f/0x46
[    3.110632]  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at:
[<ffffffff810e9e98>] kern_path_create+0x7e/0x13f
[    3.110632]
[    3.110632] stack backtrace:
[    3.110632] Pid: 22, comm: kdevtmpfs Not tainted 3.7.0-rc2+ #44
[    3.110632] Call Trace:
[    3.110632]  [<ffffffff8106b054>] lockdep_rcu_suspicious+0xfc/0x105
[    3.110632]  [<ffffffff8119a707>] task_subsys_state.constprop.8+0x68/0x70
[    3.110632]  [<ffffffff8119adbe>] devcgroup_inode_mknod+0x20/0x9e
[    3.110632]  [<ffffffff81192798>] ? security_capable+0x13/0x15
[    3.110632]  [<ffffffff81037ce4>] ? ns_capable+0x48/0x60
[    3.110632]  [<ffffffff810ea36f>] vfs_mknod+0x64/0xb0
[    3.110632]  [<ffffffff81251468>] handle_create.isra.2+0x13f/0x1b0
[    3.110632]  [<ffffffff81251582>] ? devtmpfsd+0xa9/0x156
[    3.110632]  [<ffffffff812515a5>] ? devtmpfsd+0xcc/0x156
[    3.110632]  [<ffffffff812514d9>] ? handle_create.isra.2+0x1b0/0x1b0
[    3.110632]  [<ffffffff812515c7>] devtmpfsd+0xee/0x156
[    3.110632]  [<ffffffff812514d9>] ? handle_create.isra.2+0x1b0/0x1b0
[    3.110632]  [<ffffffff81047ffb>] kthread+0xac/0xb4
[    3.110632]  [<ffffffff81047f4f>] ? __kthread_parkme+0x60/0x60
[    3.110632]  [<ffffffff81363e6c>] ret_from_fork+0x7c/0xb0
[    3.110632]  [<ffffffff81047f4f>] ? __kthread_parkme+0x60/0x60
