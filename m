Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0LVRuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:50:11 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:48422 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0LVRuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=uGnDm3NEGBi0dk86MtLqLJUAEdKyQnshEIOJzPxieKvisiKqK5tN7xij0MivCCiXXf
         pBRoiSEYNe9bz0W+rls2DM0CaywJPp0sSpyHELJKVtQS02cnBOKVTbnjYAXYPDGhsQD7
         rcO+qyOoA7PGAKn4UH4zaP5lznyqx3PonMUJU=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Reiserfs deadlock in  2.6.36
Date: Wed, 22 Dec 2010 18:50:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201011181650.00152.roucaries.bastien@gmail.com> <20101202174328.GA1750@nowhere> <201012161449.52318.roucaries.bastien@gmail.com>
In-Reply-To: <201012161449.52318.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012221850.51242.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 décembre 2010 14:49:48, Bastien ROUCARIES a écrit :
> Le jeudi 2 décembre 2010 18:43:32, vous avez écrit :
> > On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
> > > Dear frederic,
I achieve to reproduce it. BTW it is my home partition with acl enable

Dec 22 10:35:12 portablebastien task_manager[2573]: main::next_cmd() --> new task eval_bouncers (23 Thu Dec 2010  10 h 35 min 12 
s)
Dec 22 17:30:26 portablebastien kernel: [33019.797853] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:30:39 portablebastien kernel: [33033.023862] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:30:43 portablebastien kernel: [33036.933685] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:30:46 portablebastien kernel: [33039.384323] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:30:57 portablebastien kernel: [33051.226402] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:31:06 portablebastien kernel: [33060.128207] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:31:15 portablebastien kernel: [33069.210581] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:31:23 portablebastien kernel: [33076.652067] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:31:47 portablebastien kernel: [33101.117649] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
Dec 22 17:32:00 portablebastien kernel: [33113.941578] SysRq : Show Locks Held
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 
Dec 22 17:32:00 portablebastien kernel: [33113.944010] Showing all locks held in the system:
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by sync_supers/17:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104ca8>] 
sync_supers+0x64/0xd6
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by startpar/1921:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by getty/2609:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by getty/2610:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by getty/2611:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by getty/2612:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 2 locks held by bash/2692:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff81240dd4>] 
__handle_sysrq+0x23/0x156
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #1:  (tasklist_lock){.?.?.-}, at: [<ffffffff810747c3>] 
debug_show_all_locks+0x4c/0x178
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by kded4/2957:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by kglobalaccel/3009:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3078:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3081:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3091:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by kalarm/3095:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3106:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3110:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by kmail/3151:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8112459e>] 
vfs_fsync_range+0x45/0x7d
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/3197:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/4101:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by pidgin/4421:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by bash/7333:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by git/7392:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81110ce5>] 
vfs_readdir+0x51/0xb1
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 1 lock held by sync/7527:
Dec 22 17:32:00 portablebastien kernel: [33113.944010]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104bd9>] 
iterate_supers+0x5d/0xc8
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 
Dec 22 17:32:00 portablebastien kernel: [33113.944010] =============================================
Dec 22 17:32:00 portablebastien kernel: [33113.944010] 
Dec 22 17:32:07 portablebastien kernel: [33120.829139] kded4         D 00000001007cad85     0  2957      1 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.829149]  ffff8800d788bb28 0000000000000046 ffff8800d788baa8 ffffffff00000000
Dec 22 17:32:07 portablebastien kernel: [33120.829159]  ffff8800d788a010 ffff8800d788bfd8 ffff88011cda0fe0 ffff88011cda12b0
Dec 22 17:32:07 portablebastien kernel: [33120.829167]  ffff88011cda12a8 0000000000014d80 0000000000014d80 ffff8800d788bfd8
Dec 22 17:32:07 portablebastien kernel: [33120.829176] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.829218]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.829228]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.829249]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.829269]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.829284]  [<ffffffffa01efbb6>] reiserfs_create+0x105/0x233 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.829293]  [<ffffffff8110b589>] ? generic_permission+0x17/0x9a
Dec 22 17:32:07 portablebastien kernel: [33120.829300]  [<ffffffff81171e71>] ? security_inode_permission+0x1c/0x1e
Dec 22 17:32:07 portablebastien kernel: [33120.829307]  [<ffffffff8110c42f>] vfs_create+0x6b/0x8d
Dec 22 17:32:07 portablebastien kernel: [33120.829313]  [<ffffffff8110cdfa>] do_last+0x26c/0x532
Dec 22 17:32:07 portablebastien kernel: [33120.829320]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:32:07 portablebastien kernel: [33120.829328]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:32:07 portablebastien kernel: [33120.829335]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:32:07 portablebastien kernel: [33120.829342]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:32:07 portablebastien kernel: [33120.829348]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:32:07 portablebastien kernel: [33120.829355]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:32:07 portablebastien kernel: [33120.829362]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.829368] 1 lock held by kded4/2957:
Dec 22 17:32:07 portablebastien kernel: [33120.829371]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:32:07 portablebastien kernel: [33120.835114] kglobalaccel  D ffffc90005781178     0  3009      1 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.835122]  ffff8800d7b3da98 0000000000000046 ffff8800d7b3da18 ffffffff81074d94
Dec 22 17:32:07 portablebastien kernel: [33120.835132]  ffff8800d7b3c010 ffff8800d7b3dfd8 ffff8800d7a02fa0 ffff8800d7a03270
Dec 22 17:32:07 portablebastien kernel: [33120.835140]  ffff8800d7a03268 0000000000014d80 0000000000014d80 ffff8800d7b3dfd8
Dec 22 17:32:07 portablebastien kernel: [33120.835149] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.835157]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:32:07 portablebastien kernel: [33120.835180]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835187]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.835206]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835226]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835244]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835264]  [<ffffffffa02123f8>] ? security_get+0x41/0x43 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835271]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:32:07 portablebastien kernel: [33120.835278]  [<ffffffff81115c8e>] file_update_time+0x104/0x128
Dec 22 17:32:07 portablebastien kernel: [33120.835285]  [<ffffffff8134a7ea>] ? __mutex_lock_common+0x34a/0x36f
Dec 22 17:32:07 portablebastien kernel: [33120.835293]  [<ffffffff810c3620>] __generic_file_aio_write+0x162/0x27f
Dec 22 17:32:07 portablebastien kernel: [33120.835300]  [<ffffffff810c3797>] generic_file_aio_write+0x5a/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.835307]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:32:07 portablebastien kernel: [33120.835313]  [<ffffffff81102995>] ? do_sync_read+0xc6/0x103
Dec 22 17:32:07 portablebastien kernel: [33120.835321]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:32:07 portablebastien kernel: [33120.835337]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.835344]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:32:07 portablebastien kernel: [33120.835351]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:32:07 portablebastien kernel: [33120.835358]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:32:07 portablebastien kernel: [33120.835365]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.835370] 1 lock held by kglobalaccel/3009:
Dec 22 17:32:07 portablebastien kernel: [33120.835373]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.841178] kalarm        D 00000001007cb8e4     0  3095      1 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.841186]  ffff8800befd9cc8 0000000000000046 fffffff500000001 0000000000000000
Dec 22 17:32:07 portablebastien kernel: [33120.841195]  ffff8800befd8010 ffff8800befd9fd8 ffff8800bc938fe0 ffff8800bc9392b0
Dec 22 17:32:07 portablebastien kernel: [33120.841205]  ffff8800bc9392a8 0000000000014d80 0000000000014d80 ffff8800befd9fd8
Dec 22 17:32:07 portablebastien kernel: [33120.841213] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.841221]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.841228]  [<ffffffff8134a6da>] __mutex_lock_common+0x23a/0x36f
Dec 22 17:32:07 portablebastien kernel: [33120.841235]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.841241]  [<ffffffff8134a8c4>] mutex_lock_nested+0x39/0x3e
Dec 22 17:32:07 portablebastien kernel: [33120.841248]  [<ffffffff810c3784>] generic_file_aio_write+0x47/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.841255]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:32:07 portablebastien kernel: [33120.841261]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:32:07 portablebastien kernel: [33120.841268]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:32:07 portablebastien kernel: [33120.841287]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.841294]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:32:07 portablebastien kernel: [33120.841300]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:32:07 portablebastien kernel: [33120.841306]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:32:07 portablebastien kernel: [33120.841313]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:32:07 portablebastien kernel: [33120.841320]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.841325] 1 lock held by kalarm/3095:
Dec 22 17:32:07 portablebastien kernel: [33120.841328]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:07 portablebastien kernel: [33120.847036] akregator     D ffffc90005781178     0  3105      1 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.847044]  ffff8800bcae1ae8 0000000000000046 0000000000000006 ffffc900057811b8
Dec 22 17:32:07 portablebastien kernel: [33120.847053]  ffff8800bcae0010 ffff8800bcae1fd8 ffff8800bc93bf80 ffff8800bc93c250
Dec 22 17:32:07 portablebastien kernel: [33120.847062]  ffff8800bc93c248 0000000000014d80 0000000000014d80 ffff8800bcae1fd8
Dec 22 17:32:07 portablebastien kernel: [33120.847071] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.847094]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.847102]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.847122]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.847142]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.847159]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.847167]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:32:07 portablebastien kernel: [33120.847173]  [<ffffffff81115db4>] touch_atime+0x102/0x125
Dec 22 17:32:07 portablebastien kernel: [33120.847180]  [<ffffffff810c4565>] generic_file_aio_read+0x562/0x5b7
Dec 22 17:32:07 portablebastien kernel: [33120.847188]  [<ffffffff81102995>] do_sync_read+0xc6/0x103
Dec 22 17:32:07 portablebastien kernel: [33120.847194]  [<ffffffff8110327a>] ? generic_file_llseek+0x2a/0x5b
Dec 22 17:32:07 portablebastien kernel: [33120.847201]  [<ffffffff811721b6>] ? fsnotify_perm+0x45/0x4b
Dec 22 17:32:07 portablebastien kernel: [33120.847207]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:32:07 portablebastien kernel: [33120.847213]  [<ffffffff81102fd3>] vfs_read+0xa6/0x102
Dec 22 17:32:07 portablebastien kernel: [33120.847219]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:32:07 portablebastien kernel: [33120.847227]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:32:07 portablebastien kernel: [33120.847233]  [<ffffffff811030e5>] sys_read+0x45/0x69
Dec 22 17:32:07 portablebastien kernel: [33120.847240]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.847245] no locks held by akregator/3105.
Dec 22 17:32:07 portablebastien kernel: [33120.852961] kmail         D ffffc90005781178     0  3151      1 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.852969]  ffff8800bcb6fdb8 0000000000000046 ffff8800bcb6fd38 ffffffff81074d94
Dec 22 17:32:07 portablebastien kernel: [33120.852978]  ffff8800bcb6e010 ffff8800bcb6ffd8 ffff8800ab054f60 ffff8800ab055230
Dec 22 17:32:07 portablebastien kernel: [33120.852987]  ffff8800ab055228 0000000000014d80 0000000000014d80 ffff8800bcb6ffd8
Dec 22 17:32:07 portablebastien kernel: [33120.852996] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.853003]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:32:07 portablebastien kernel: [33120.853026]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.853033]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.853053]  [<ffffffffa020d6c7>] reiserfs_commit_for_inode+0xd8/0x218 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.853060]  [<ffffffff8134a8c4>] ? mutex_lock_nested+0x39/0x3e
Dec 22 17:32:07 portablebastien kernel: [33120.853077]  [<ffffffffa01f4bbb>] reiserfs_sync_file+0x52/0xab [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.853084]  [<ffffffff811245ab>] vfs_fsync_range+0x52/0x7d
Dec 22 17:32:07 portablebastien kernel: [33120.853090]  [<ffffffff81124631>] vfs_fsync+0x17/0x19
Dec 22 17:32:07 portablebastien kernel: [33120.853096]  [<ffffffff8112465c>] do_fsync+0x29/0x3e
Dec 22 17:32:07 portablebastien kernel: [33120.853102]  [<ffffffff8112468e>] sys_fsync+0xb/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.853109]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.853114] 1 lock held by kmail/3151:
Dec 22 17:32:07 portablebastien kernel: [33120.853117]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8112459e>] 
vfs_fsync_range+0x45/0x7d
Dec 22 17:32:07 portablebastien kernel: [33120.858837] sync          D 00000001007cb9b0     0  7527   7521 0x00000000
Dec 22 17:32:07 portablebastien kernel: [33120.858845]  ffff8800736cbd48 0000000000000046 ffff8800736cbcc8 ffffffff00000000
Dec 22 17:32:07 portablebastien kernel: [33120.858855]  ffff8800736ca010 ffff8800736cbfd8 ffff8800997dbf80 ffff8800997dc250
Dec 22 17:32:07 portablebastien kernel: [33120.858866]  ffff8800997dc248 0000000000014d80 0000000000014d80 ffff8800736cbfd8
Dec 22 17:32:07 portablebastien kernel: [33120.858877] Call Trace:
Dec 22 17:32:07 portablebastien kernel: [33120.858900]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.858908]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:32:07 portablebastien kernel: [33120.858928]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.858941]  [<ffffffff8112476b>] ? sync_one_sb+0x0/0x1d
Dec 22 17:32:07 portablebastien kernel: [33120.858960]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.858978]  [<ffffffffa01fb450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Dec 22 17:32:07 portablebastien kernel: [33120.858985]  [<ffffffff81124753>] __sync_filesystem+0x66/0x7e
Dec 22 17:32:07 portablebastien kernel: [33120.858991]  [<ffffffff81124786>] sync_one_sb+0x1b/0x1d
Dec 22 17:32:07 portablebastien kernel: [33120.858998]  [<ffffffff81104be9>] iterate_supers+0x6d/0xc8
Dec 22 17:32:07 portablebastien kernel: [33120.859004]  [<ffffffff811247b2>] sys_sync+0x2a/0x57
Dec 22 17:32:07 portablebastien kernel: [33120.859011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:32:07 portablebastien kernel: [33120.859016] 1 lock held by sync/7527:
Dec 22 17:32:07 portablebastien kernel: [33120.859019]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104bd9>] 
iterate_supers+0x5d/0xc8
Dec 22 17:32:19 portablebastien kernel: [33133.227955] SysRq : Show Locks Held
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 
Dec 22 17:32:19 portablebastien kernel: [33133.228832] Showing all locks held in the system:
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by sync_supers/17:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104ca8>] 
sync_supers+0x64/0xd6
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by startpar/1921:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by getty/2609:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by getty/2610:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by getty/2611:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by getty/2612:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 2 locks held by bash/2692:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff81240dd4>] 
__handle_sysrq+0x23/0x156
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #1:  (tasklist_lock){.?.?.-}, at: [<ffffffff810747c3>] 
debug_show_all_locks+0x4c/0x178
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by kded4/2957:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by kglobalaccel/3009:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3078:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3081:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3091:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by kalarm/3095:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3106:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3110:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by kmail/3151:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8112459e>] 
vfs_fsync_range+0x45/0x7d
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/3197:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/4101:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by pidgin/4421:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by bash/7333:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by git/7392:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81110ce5>] 
vfs_readdir+0x51/0xb1
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 1 lock held by sync/7527:
Dec 22 17:32:19 portablebastien kernel: [33133.228832]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104bd9>] 
iterate_supers+0x5d/0xc8
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 
Dec 22 17:32:19 portablebastien kernel: [33133.228832] =============================================
Dec 22 17:32:19 portablebastien kernel: [33133.228832] 
Dec 22 17:33:33 portablebastien kernel: [33206.596866] SysRq : Show Locks Held
Dec 22 17:33:33 portablebastien kernel: [33206.598784] 
Dec 22 17:33:33 portablebastien kernel: [33206.598785] Showing all locks held in the system:
Dec 22 17:33:33 portablebastien kernel: [33206.598794] 1 lock held by sync_supers/17:
Dec 22 17:33:33 portablebastien kernel: [33206.598797]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104ca8>] 
sync_supers+0x64/0xd6
Dec 22 17:33:33 portablebastien kernel: [33206.598829] 1 lock held by startpar/1921:
Dec 22 17:33:33 portablebastien kernel: [33206.598832]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.598851] 1 lock held by getty/2609:
Dec 22 17:33:33 portablebastien kernel: [33206.598854]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.598866] 1 lock held by getty/2610:
Dec 22 17:33:33 portablebastien kernel: [33206.598869]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.598881] 1 lock held by getty/2611:
Dec 22 17:33:33 portablebastien kernel: [33206.598884]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.598896] 1 lock held by getty/2612:
Dec 22 17:33:33 portablebastien kernel: [33206.598899]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.598921] 2 locks held by bash/2692:
Dec 22 17:33:33 portablebastien kernel: [33206.598924]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff81240dd4>] 
__handle_sysrq+0x23/0x156
Dec 22 17:33:33 portablebastien kernel: [33206.598936]  #1:  (tasklist_lock){.?.?.-}, at: [<ffffffff810747c3>] 
debug_show_all_locks+0x4c/0x178
Dec 22 17:33:33 portablebastien kernel: [33206.598952] 1 lock held by kded4/2957:
Dec 22 17:33:33 portablebastien kernel: [33206.598955]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:33:33 portablebastien kernel: [33206.598970] 1 lock held by kglobalaccel/3009:
Dec 22 17:33:33 portablebastien kernel: [33206.598973]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:33:33 portablebastien kernel: [33206.598997] 1 lock held by bash/3078:
Dec 22 17:33:33 portablebastien kernel: [33206.599000]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599012] 1 lock held by bash/3081:
Dec 22 17:33:33 portablebastien kernel: [33206.599015]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599027] 1 lock held by bash/3091:
Dec 22 17:33:33 portablebastien kernel: [33206.599030]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599042] 1 lock held by kalarm/3095:
Dec 22 17:33:33 portablebastien kernel: [33206.599045]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:33:33 portablebastien kernel: [33206.599059] 1 lock held by bash/3106:
Dec 22 17:33:33 portablebastien kernel: [33206.599062]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599074] 1 lock held by bash/3110:
Dec 22 17:33:33 portablebastien kernel: [33206.599077]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599090] 1 lock held by kmail/3151:
Dec 22 17:33:33 portablebastien kernel: [33206.599093]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8112459e>] 
vfs_fsync_range+0x45/0x7d
Dec 22 17:33:33 portablebastien kernel: [33206.599107] 3 locks held by okular/3153:
Dec 22 17:33:33 portablebastien kernel: [33206.599110]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff811021b8>] 
do_truncate+0x5b/0x84
Dec 22 17:33:33 portablebastien kernel: [33206.599122]  #1:  (&sb->s_type->i_alloc_sem_key#3){+.+.+.}, at: [<ffffffff8111755d>] 
notify_change+0x185/0x298
Dec 22 17:33:33 portablebastien kernel: [33206.599134]  #2:  (&ei->tailpack){+.+...}, at: [<ffffffffa01f4b4f>] 
reiserfs_vfs_truncate_file+0x1b/0x35 [reiserfs]
Dec 22 17:33:33 portablebastien kernel: [33206.599177] 1 lock held by bash/3197:
Dec 22 17:33:33 portablebastien kernel: [33206.599180]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599202] 1 lock held by bash/4101:
Dec 22 17:33:33 portablebastien kernel: [33206.599205]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599217] 1 lock held by pidgin/4421:
Dec 22 17:33:33 portablebastien kernel: [33206.599220]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:33:33 portablebastien kernel: [33206.599239] 3 locks held by okular/7048:
Dec 22 17:33:33 portablebastien kernel: [33206.599241]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff811021b8>] 
do_truncate+0x5b/0x84
Dec 22 17:33:33 portablebastien kernel: [33206.599253]  #1:  (&sb->s_type->i_alloc_sem_key#3){+.+.+.}, at: [<ffffffff8111755d>] 
notify_change+0x185/0x298
Dec 22 17:33:33 portablebastien kernel: [33206.599265]  #2:  (&ei->tailpack){+.+...}, at: [<ffffffffa01f4b4f>] 
reiserfs_vfs_truncate_file+0x1b/0x35 [reiserfs]
Dec 22 17:33:33 portablebastien kernel: [33206.599288] 1 lock held by bash/7333:
Dec 22 17:33:33 portablebastien kernel: [33206.599291]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8122f233>] 
n_tty_read+0x27c/0x7af
Dec 22 17:33:33 portablebastien kernel: [33206.599303] 1 lock held by git/7392:
Dec 22 17:33:33 portablebastien kernel: [33206.599306]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81110ce5>] 
vfs_readdir+0x51/0xb1
Dec 22 17:33:33 portablebastien kernel: [33206.599320] 1 lock held by sync/7527:
Dec 22 17:33:33 portablebastien kernel: [33206.599323]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81104bd9>] 
iterate_supers+0x5d/0xc8
Dec 22 17:33:33 portablebastien kernel: [33206.599336] 
Dec 22 17:33:33 portablebastien kernel: [33206.599338] =============================================
Dec 22 17:33:33 portablebastien kernel: [33206.599340] 
Dec 22 17:34:03 portablebastien kernel: [33237.063879] SysRq : Show Blocked State
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   task                        PC stack   pid father
Dec 22 17:34:03 portablebastien kernel: [33237.064011] sync_supers   D ffffc90005781178     0    17      2 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88011f761ca0 0000000000000046 ffff88011f761c20 ffffffff81074d94
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88011f760010 ffff88011f761fd8 ffff88011f6d9fc0 ffff88011f6da290
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88011f6da288 0000000000014d80 0000000000014d80 ffff88011f761fd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020c4cb>] do_journal_end+0x201/0xda8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d4ab>] ? do_journal_begin_r+0x297/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810d803a>] ? bdi_sync_supers+0x0/0x51
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d0e6>] journal_end_sync+0x74/0x7d [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb464>] reiserfs_sync_fs+0x3b/0x5e [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810d803a>] ? bdi_sync_supers+0x0/0x51
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134abfe>] ? down_read+0x47/0x5c
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb495>] reiserfs_write_super+0xe/0x10 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81104cbf>] sync_supers+0x7b/0xd6
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810d8079>] bdi_sync_supers+0x3f/0x51
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810d803a>] ? bdi_sync_supers+0x0/0x51
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810642ae>] kthread+0x8c/0x94
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134c150>] ? restore_args+0x0/0x30
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81064222>] ? kthread+0x0/0x94
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Dec 22 17:34:03 portablebastien kernel: [33237.064011] kded4         D 00000001007cad85     0  2957      1 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800d788bb28 0000000000000046 ffff8800d788baa8 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800d788a010 ffff8800d788bfd8 ffff88011cda0fe0 ffff88011cda12b0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88011cda12a8 0000000000014d80 0000000000014d80 ffff8800d788bfd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01efbb6>] reiserfs_create+0x105/0x233 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110b589>] ? generic_permission+0x17/0x9a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81171e71>] ? security_inode_permission+0x1c/0x1e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110c42f>] vfs_create+0x6b/0x8d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110cdfa>] do_last+0x26c/0x532
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] kglobalaccel  D ffffc90005781178     0  3009      1 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800d7b3da98 0000000000000046 ffff8800d7b3da18 ffffffff81074d94
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800d7b3c010 ffff8800d7b3dfd8 ffff8800d7a02fa0 ffff8800d7a03270
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800d7a03268 0000000000014d80 0000000000014d80 ffff8800d7b3dfd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa02123f8>] ? security_get+0x41/0x43 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81115c8e>] file_update_time+0x104/0x128
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134a7ea>] ? __mutex_lock_common+0x34a/0x36f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c3620>] __generic_file_aio_write+0x162/0x27f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c3797>] generic_file_aio_write+0x5a/0xa8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102995>] ? do_sync_read+0xc6/0x103
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] kalarm        D 00000001007cb8e4     0  3095      1 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800befd9cc8 0000000000000046 fffffff500000001 0000000000000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800befd8010 ffff8800befd9fd8 ffff8800bc938fe0 ffff8800bc9392b0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bc9392a8 0000000000014d80 0000000000014d80 ffff8800befd9fd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134a6da>] __mutex_lock_common+0x23a/0x36f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134a8c4>] mutex_lock_nested+0x39/0x3e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c3784>] generic_file_aio_write+0x47/0xa8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] akregator     D ffffc90005781178     0  3105      1 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bcae1ae8 0000000000000046 0000000000000006 ffffc900057811b8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bcae0010 ffff8800bcae1fd8 ffff8800bc93bf80 ffff8800bc93c250
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bc93c248 0000000000014d80 0000000000014d80 ffff8800bcae1fd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81115db4>] touch_atime+0x102/0x125
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810c4565>] generic_file_aio_read+0x562/0x5b7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102995>] do_sync_read+0xc6/0x103
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110327a>] ? generic_file_llseek+0x2a/0x5b
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811721b6>] ? fsnotify_perm+0x45/0x4b
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81102fd3>] vfs_read+0xa6/0x102
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811030e5>] sys_read+0x45/0x69
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] kmail         D ffffc90005781178     0  3151      1 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bcb6fdb8 0000000000000046 ffff8800bcb6fd38 ffffffff81074d94
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800bcb6e010 ffff8800bcb6ffd8 ffff8800ab054f60 ffff8800ab055230
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800ab055228 0000000000014d80 0000000000014d80 ffff8800bcb6ffd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d6c7>] reiserfs_commit_for_inode+0xd8/0x218 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134a8c4>] ? mutex_lock_nested+0x39/0x3e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4bbb>] reiserfs_sync_file+0x52/0xab [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811245ab>] vfs_fsync_range+0x52/0x7d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81124631>] vfs_fsync+0x17/0x19
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8112465c>] do_fsync+0x29/0x3e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8112468e>] sys_fsync+0xb/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] okular        D 00000001007d45b7     0  3153   2954 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b84479c8 0000000000000046 ffff8800b8447948 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b8446010 ffff8800b8447fd8 ffff8800b2454f60 ffff8800b2455230
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b2455228 0000000000014d80 0000000000014d80 ffff8800b8447fd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f2a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810ccd49>] vmtruncate+0x3f/0x4a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f0cfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81117575>] notify_change+0x19d/0x298
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811021c4>] do_truncate+0x67/0x84
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110b466>] ? get_write_access+0x41/0x48
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110cff1>] do_last+0x463/0x532
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] okular        D 00000001007da057     0  3166   2954 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b87df9c8 0000000000000046 ffff8800b87df948 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b87de010 ffff8800b87dffd8 ffff8800b87e0000 ffff8800b87e02d0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800b87e02c8 0000000000014d80 0000000000014d80 ffff8800b87dffd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f2a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810ccd49>] vmtruncate+0x3f/0x4a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f0cfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81117575>] notify_change+0x19d/0x298
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811021c4>] do_truncate+0x67/0x84
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110b466>] ? get_write_access+0x41/0x48
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110cff1>] do_last+0x463/0x532
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] pidgin        D 00000001007cebac     0  4421   3030 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800ab04fb28 0000000000000046 ffff8800ab04faa8 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800ab04e010 ffff8800ab04ffd8 ffff8800a1e50000 ffff8800a1e502d0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800a1e502c8 0000000000014d80 0000000000014d80 ffff8800ab04ffd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01efbb6>] reiserfs_create+0x105/0x233 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110b589>] ? generic_permission+0x17/0x9a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81171e71>] ? security_inode_permission+0x1c/0x1e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110c42f>] vfs_create+0x6b/0x8d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110cdfa>] do_last+0x26c/0x532
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] okular        D 00000001007d419d     0  7048   4998 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88007342d9c8 0000000000000046 ffff88007342d948 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88007342c010 ffff88007342dfd8 ffff88011f782fa0 ffff88011f783270
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88011f783268 0000000000014d80 0000000000014d80 ffff88007342dfd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f2a05>] reiserfs_truncate_file+0x191/0x29f [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f4b5c>] reiserfs_vfs_truncate_file+0x28/0x35 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff810ccd49>] vmtruncate+0x3f/0x4a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01f0cfe>] reiserfs_setattr+0x29f/0x328 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81117575>] notify_change+0x19d/0x298
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811021c4>] do_truncate+0x67/0x84
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110b466>] ? get_write_access+0x41/0x48
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110cff1>] do_last+0x463/0x532
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] git           D 00000001007cd72e     0  7392   7270 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff880052961cb8 0000000000000046 ffff880052961c38 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff880052960010 ffff880052961fd8 ffff88008711bf80 ffff88008711c250
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff88008711c248 0000000000014d80 0000000000014d80 ffff880052961fd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8134a7fe>] ? __mutex_lock_common+0x35e/0x36f
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81115db4>] touch_atime+0x102/0x125
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81110b14>] ? filldir+0x0/0xcb
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81110d1e>] vfs_readdir+0x8a/0xb1
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81110e84>] sys_getdents+0x7c/0xcc
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] sync          D 00000001007cb9b0     0  7527   7521 0x00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800736cbd48 0000000000000046 ffff8800736cbcc8 ffffffff00000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800736ca010 ffff8800736cbfd8 ffff8800997dbf80 ffff8800997dc250
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  ffff8800997dc248 0000000000014d80 0000000000014d80 ffff8800736cbfd8
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Call Trace:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff8112476b>] ? sync_one_sb+0x0/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffffa01fb450>] reiserfs_sync_fs+0x27/0x5e [reiserfs]
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81124753>] __sync_filesystem+0x66/0x7e
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81124786>] sync_one_sb+0x1b/0x1d
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81104be9>] iterate_supers+0x6d/0xc8
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff811247b2>] sys_sync+0x2a/0x57
Dec 22 17:34:03 portablebastien kernel: [33237.064011]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:03 portablebastien kernel: [33237.064011] Sched Debug Version: v0.09, 2.6.36 #5
Dec 22 17:34:03 portablebastien kernel: [33237.064011] now at 33237070.334696 msecs
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .jiffies                                 : 4303201561
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_latency                    : 12.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_min_granularity            : 1.500000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_wakeup_granularity         : 2.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_child_runs_first           : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_features                   : 15471
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] cpu#0, 2094.603 MHz
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_running                    : 3
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .load                          : 3072
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_switches                   : 21336055
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_load_updates               : 2285052
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_uninterruptible            : 7
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .next_balance                  : 4303.201606
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .curr->pid                     : 2692
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .clock                         : 33237060.027075
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[0]                   : 2048
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[1]                   : 1024
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[2]                   : 512
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[3]                   : 256
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[4]                   : 128
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] cfs_rq[0]:/
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .exec_clock                    : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .MIN_vruntime                  : 8368928.247552
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .min_vruntime                  : 8368934.247552
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .max_vruntime                  : 8368934.252419
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .spread                        : 6.004867
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .spread0                       : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_running                    : 3
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .load                          : 3072
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_spread_over                : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .shares                        : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] rt_rq[0]:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_nr_running                 : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_throttled                  : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_time                       : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_runtime                    : 900.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] runnable tasks:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]             task   PID         tree-key  switches  prio     exec-runtime         
sum-exec        sum-sleep
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
----------------------------------------------------------------------------------------------------------
Dec 22 17:34:03 portablebastien kernel: [33237.064011] R           bash  2692   8368928.839476       500   120               0               
0               0.000000               0.000000               0.000000 /
Dec 22 17:34:03 portablebastien kernel: [33237.064011]       kde4-gnash  6731   8368934.252419    611851   120               0               
0               0.000000               0.000000               0.000000 /
Dec 22 17:34:03 portablebastien kernel: [33237.064011]      kworker/0:2  7544   8368928.247552       670   120               0               
0               0.000000               0.000000               0.000000 /
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] cpu#1, 2094.603 MHz
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_running                    : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .load                          : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_switches                   : 21399117
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_load_updates               : 2414140
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_uninterruptible            : 5
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .next_balance                  : 4303.201540
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .curr->pid                     : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .clock                         : 33237059.523887
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[0]                   : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[1]                   : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[2]                   : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[3]                   : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .cpu_load[4]                   : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] cfs_rq[1]:/
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .exec_clock                    : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .MIN_vruntime                  : 0.000001
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .min_vruntime                  : 8546850.473854
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .max_vruntime                  : 0.000001
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .spread                        : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .spread0                       : 177916.226302
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_running                    : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .load                          : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .nr_spread_over                : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .shares                        : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] rt_rq[1]:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_nr_running                 : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_throttled                  : 0
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_time                       : 0.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011]   .rt_runtime                    : 1000.000000
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:03 portablebastien kernel: [33237.064011] runnable tasks:
Dec 22 17:34:03 portablebastien kernel: [33237.064011]             task   PID         tree-key  switches  prio     exec-runtime         
sum-exec        sum-sleep
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
----------------------------------------------------------------------------------------------------------
Dec 22 17:34:03 portablebastien kernel: [33237.064011] 
Dec 22 17:34:07 portablebastien kernel: [33240.858295] kded4         D 00000001007cad85     0  2957      1 0x00000000
Dec 22 17:34:07 portablebastien kernel: [33240.858304]  ffff8800d788bb28 0000000000000046 ffff8800d788baa8 ffffffff00000000
Dec 22 17:34:07 portablebastien kernel: [33240.858314]  ffff8800d788a010 ffff8800d788bfd8 ffff88011cda0fe0 ffff88011cda12b0
Dec 22 17:34:07 portablebastien kernel: [33240.858323]  ffff88011cda12a8 0000000000014d80 0000000000014d80 ffff8800d788bfd8
Dec 22 17:34:07 portablebastien kernel: [33240.858332] Call Trace:
Dec 22 17:34:07 portablebastien kernel: [33240.858373]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.858383]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:07 portablebastien kernel: [33240.858403]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.858423]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.858439]  [<ffffffffa01efbb6>] reiserfs_create+0x105/0x233 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.858447]  [<ffffffff8110b589>] ? generic_permission+0x17/0x9a
Dec 22 17:34:07 portablebastien kernel: [33240.858454]  [<ffffffff81171e71>] ? security_inode_permission+0x1c/0x1e
Dec 22 17:34:07 portablebastien kernel: [33240.858461]  [<ffffffff8110c42f>] vfs_create+0x6b/0x8d
Dec 22 17:34:07 portablebastien kernel: [33240.858467]  [<ffffffff8110cdfa>] do_last+0x26c/0x532
Dec 22 17:34:07 portablebastien kernel: [33240.858474]  [<ffffffff8110eba2>] do_filp_open+0x203/0x599
Dec 22 17:34:07 portablebastien kernel: [33240.858484]  [<ffffffff8134bd3b>] ? _raw_spin_unlock+0x26/0x2a
Dec 22 17:34:07 portablebastien kernel: [33240.858491]  [<ffffffff811184ac>] ? alloc_fd+0x170/0x182
Dec 22 17:34:07 portablebastien kernel: [33240.858498]  [<ffffffff81101372>] do_sys_open+0x5b/0xf7
Dec 22 17:34:07 portablebastien kernel: [33240.858505]  [<ffffffff8134b49e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 22 17:34:07 portablebastien kernel: [33240.858511]  [<ffffffff81101437>] sys_open+0x1b/0x1d
Dec 22 17:34:07 portablebastien kernel: [33240.858518]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:07 portablebastien kernel: [33240.858524] 1 lock held by kded4/2957:
Dec 22 17:34:07 portablebastien kernel: [33240.858527]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8110cd3c>] 
do_last+0x1ae/0x532
Dec 22 17:34:07 portablebastien kernel: [33240.860687] kglobalaccel  D ffffc90005781178     0  3009      1 0x00000000
Dec 22 17:34:07 portablebastien kernel: [33240.860695]  ffff8800d7b3da98 0000000000000046 ffff8800d7b3da18 ffffffff81074d94
Dec 22 17:34:07 portablebastien kernel: [33240.860707]  ffff8800d7b3c010 ffff8800d7b3dfd8 ffff8800d7a02fa0 ffff8800d7a03270
Dec 22 17:34:07 portablebastien kernel: [33240.860719]  ffff8800d7a03268 0000000000014d80 0000000000014d80 ffff8800d7b3dfd8
Dec 22 17:34:07 portablebastien kernel: [33240.860730] Call Trace:
Dec 22 17:34:07 portablebastien kernel: [33240.860740]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Dec 22 17:34:07 portablebastien kernel: [33240.860763]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860770]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:07 portablebastien kernel: [33240.860791]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860811]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860830]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860850]  [<ffffffffa02123f8>] ? security_get+0x41/0x43 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860858]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:34:07 portablebastien kernel: [33240.860865]  [<ffffffff81115c8e>] file_update_time+0x104/0x128
Dec 22 17:34:07 portablebastien kernel: [33240.860873]  [<ffffffff8134a7ea>] ? __mutex_lock_common+0x34a/0x36f
Dec 22 17:34:07 portablebastien kernel: [33240.860882]  [<ffffffff810c3620>] __generic_file_aio_write+0x162/0x27f
Dec 22 17:34:07 portablebastien kernel: [33240.860890]  [<ffffffff810c3797>] generic_file_aio_write+0x5a/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.860898]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:34:07 portablebastien kernel: [33240.860905]  [<ffffffff81102995>] ? do_sync_read+0xc6/0x103
Dec 22 17:34:07 portablebastien kernel: [33240.860912]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:07 portablebastien kernel: [33240.860930]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.860937]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:34:07 portablebastien kernel: [33240.860945]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:07 portablebastien kernel: [33240.860952]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:34:07 portablebastien kernel: [33240.860960]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:07 portablebastien kernel: [33240.860965] 1 lock held by kglobalaccel/3009:
Dec 22 17:34:07 portablebastien kernel: [33240.860969]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.863178] kalarm        D 00000001007cb8e4     0  3095      1 0x00000000
Dec 22 17:34:07 portablebastien kernel: [33240.863185]  ffff8800befd9cc8 0000000000000046 fffffff500000001 0000000000000000
Dec 22 17:34:07 portablebastien kernel: [33240.863194]  ffff8800befd8010 ffff8800befd9fd8 ffff8800bc938fe0 ffff8800bc9392b0
Dec 22 17:34:07 portablebastien kernel: [33240.863204]  ffff8800bc9392a8 0000000000014d80 0000000000014d80 ffff8800befd9fd8
Dec 22 17:34:07 portablebastien kernel: [33240.863215] Call Trace:
Dec 22 17:34:07 portablebastien kernel: [33240.863224]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.863231]  [<ffffffff8134a6da>] __mutex_lock_common+0x23a/0x36f
Dec 22 17:34:07 portablebastien kernel: [33240.863238]  [<ffffffff810c3784>] ? generic_file_aio_write+0x47/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.863246]  [<ffffffff8134a8c4>] mutex_lock_nested+0x39/0x3e
Dec 22 17:34:07 portablebastien kernel: [33240.863253]  [<ffffffff810c3784>] generic_file_aio_write+0x47/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.863261]  [<ffffffff81102892>] do_sync_write+0xc6/0x103
Dec 22 17:34:07 portablebastien kernel: [33240.863268]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:07 portablebastien kernel: [33240.863275]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:07 portablebastien kernel: [33240.863295]  [<ffffffffa01f4fb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.863302]  [<ffffffff81102df7>] vfs_write+0xa9/0x105
Dec 22 17:34:07 portablebastien kernel: [33240.863308]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:07 portablebastien kernel: [33240.863316]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:07 portablebastien kernel: [33240.863323]  [<ffffffff81102f09>] sys_write+0x45/0x69
Dec 22 17:34:07 portablebastien kernel: [33240.863330]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:07 portablebastien kernel: [33240.863335] 1 lock held by kalarm/3095:
Dec 22 17:34:07 portablebastien kernel: [33240.863339]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c3784>] 
generic_file_aio_write+0x47/0xa8
Dec 22 17:34:07 portablebastien kernel: [33240.865707] akregator     D ffffc90005781178     0  3105      1 0x00000000
Dec 22 17:34:07 portablebastien kernel: [33240.865715]  ffff8800bcae1ae8 0000000000000046 0000000000000006 ffffc900057811b8
Dec 22 17:34:07 portablebastien kernel: [33240.865724]  ffff8800bcae0010 ffff8800bcae1fd8 ffff8800bc93bf80 ffff8800bc93c250
Dec 22 17:34:07 portablebastien kernel: [33240.865733]  ffff8800bc93c248 0000000000014d80 0000000000014d80 ffff8800bcae1fd8
Dec 22 17:34:07 portablebastien kernel: [33240.865742] Call Trace:
Dec 22 17:34:07 portablebastien kernel: [33240.865764]  [<ffffffffa0209454>] queue_log_writer+0x7e/0xaf [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.865772]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Dec 22 17:34:07 portablebastien kernel: [33240.865792]  [<ffffffffa020d402>] do_journal_begin_r+0x1ee/0x2d8 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.865811]  [<ffffffffa020d5ae>] journal_begin+0xc2/0x103 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.865829]  [<ffffffffa01fb4f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Dec 22 17:34:07 portablebastien kernel: [33240.865836]  [<ffffffff81120c40>] __mark_inode_dirty+0x2f/0x1d2
Dec 22 17:34:07 portablebastien kernel: [33240.865842]  [<ffffffff81115db4>] touch_atime+0x102/0x125
Dec 22 17:34:07 portablebastien kernel: [33240.865849]  [<ffffffff810c4565>] generic_file_aio_read+0x562/0x5b7
Dec 22 17:34:07 portablebastien kernel: [33240.865857]  [<ffffffff81102995>] do_sync_read+0xc6/0x103
Dec 22 17:34:07 portablebastien kernel: [33240.865863]  [<ffffffff8110327a>] ? generic_file_llseek+0x2a/0x5b
Dec 22 17:34:07 portablebastien kernel: [33240.865870]  [<ffffffff811721b6>] ? fsnotify_perm+0x45/0x4b
Dec 22 17:34:07 portablebastien kernel: [33240.865876]  [<ffffffff81172213>] ? security_file_permission+0x29/0x2e
Dec 22 17:34:07 portablebastien kernel: [33240.865882]  [<ffffffff81102fd3>] vfs_read+0xa6/0x102
Dec 22 17:34:07 portablebastien kernel: [33240.865888]  [<ffffffff81103ab1>] ? fget_light+0x41/0xcf
Dec 22 17:34:07 portablebastien kernel: [33240.865895]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Dec 22 17:34:07 portablebastien kernel: [33240.865901]  [<ffffffff811030e5>] sys_read+0x45/0x69
Dec 22 17:34:07 portablebastien kernel: [33240.865908]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Dec 22 17:34:07 portablebastien kernel: [33240.865913] no locks held by akregator/3105.
Dec 22 17:40:50 portablebastien kernel: [33643.963347] SysRq : Emergency Sync
Dec 22 17:40:51 portablebastien kernel: [33645.346903] SysRq : Emergency Sync
Dec 22 17:40:58 portablebastien kernel: [33652.098945] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) 
nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-
tasks(W) dump-ftrace-buffer(Z) 
