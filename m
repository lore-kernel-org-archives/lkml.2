Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1DPTSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:18:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58223 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1DPTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=EqRoStHFk+FbsW+TGgvaOa4mFuv4hX0aJHh9OB/vQ1agKJ4veHjJvqlqWdbLi36pEC
         s0HpFdoHffH9iIyS3wfQ0fTo24snRwb5AjDyAl9GJFoSQmNDuY7+gQNiwUcKsQ9FKjwc
         PY/NKBDX8AlYgnfsGgNdDmSstxASrUbsABUNY=
Subject: PROBLEM: some unknown oops (?)
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 16 Apr 2011 21:18:09 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 
Content-Transfer-Encoding: 7bit
Message-ID: <1302981491.30598.4.camel@soho.example.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some problem with 2.6.38.2 but not with 2.6.37.6

I don't know what's the problem is and I can't trigger the bug. May be
it's nvidia module or something in gnome 3 ??

first and second time it leads to X freeze and a switch to a console I
was able to type username and password but never got a shell prompt

third time: X was still up
some process seemed dead (jdownloader), and running "ps aux" in a
terminal did not complete. First time it blocked on "jdownloader"
and after I killed jdownloader process, "ps aux" blocked on kblocker or
"klog" something ?

$ cat /proc/version           # this is official archlinux kernel
Linux version 2.6.38-ARCH (tobias@T-POWA-LX) (gcc version 4.6.0 (GCC) )
#1 SMP PREEMPT Wed Mar 30 07:14:27 UTC 2011

All I can offer is the log with the oops:
the first I thought of something related to disk or reiserfs
Apr  9 15:57:09 soho kernel: gnome-shell[10766]: segfault at 938 ip
b5304518 sp bfa9b0b0 error 4 in libnvidia-glcore.so.270.30[b447d000
+16b3000]
Apr  9 15:57:14 soho kernel: gnome-shell[7539]: segfault at 938 ip
b51ad518 sp bfa1e6b0 error 4 in libnvidia-glcore.so.270.30[b4326000
+16b3000]
Apr  9 17:26:31 soho kernel: gnome-settings-[8635]: segfault at b45a4160
ip b45a4160 sp bfd189cc error 4
Apr  9 19:27:00 soho kernel: convert[20862]: segfault at 75007668 ip
b75170d3 sp bf8041ec error 4 in libc-2.13.so[b74a1000+15f000]
Apr 10 00:02:07 soho kernel: conky           D de29f088     0  2085
1931 0x00000000
Apr 10 00:02:07 soho kernel: de407ce8 00200086 00000001 de29f088
de29f0cc f4404a00 de29f080 de407cf3
Apr 10 00:02:07 soho kernel: 0000000b de407cb4 f425fc00 00111006
f425fc00 f5806380 c14c0380 f3668cf0
Apr 10 00:02:07 soho kernel: f3668eb4 5b15fafe 00002b94 c14c0380
f5806380 f3668cf0 f3668450 de407cb4
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaac883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacb1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacaa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:02:07 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:02:07 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:02:07 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:02:07 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 10 00:02:07 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 10 00:02:07 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:02:07 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<faa928a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:02:07 soho kernel: [<faa92840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: evolution-alarm D ee117db4     0  2019
1931 0x00000000
Apr 10 00:02:07 soho kernel: ee117e4c 00000086 c101db16 ee117db4
c1030070 c1323600 ee117dc8 c10352cd
Apr 10 00:02:07 soho kernel: 00000000 00000003 00000086 ee117e08
c103e367 f5a06380 c14c0380 f3cbab20
Apr 10 00:02:07 soho kernel: f3cbace4 78b252cb 00002ba6 c14c0380
f5a06380 f3cbab20 f1d89e30 00000086
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c101db16>] ? native_smp_send_reschedule
+0x36/0x50
Apr 10 00:02:07 soho kernel: [<c1030070>] ? resched_task+0x60/0x70
Apr 10 00:02:07 soho kernel: [<c10352cd>] ? check_preempt_curr+0x5d/0x80
Apr 10 00:02:07 soho kernel: [<c103e367>] ? try_to_wake_up+0x1a7/0x350
Apr 10 00:02:07 soho kernel: [<c103e51b>] ? default_wake_function
+0xb/0x10
Apr 10 00:02:07 soho kernel: [<c11148cd>] ? pollwake+0x5d/0x70
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<c1318f3d>] __mutex_lock_slowpath
+0x10d/0x2b0
Apr 10 00:02:07 soho kernel: [<c13190eb>] mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<c10c01fb>] generic_file_aio_write
+0x4b/0xd0
Apr 10 00:02:07 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c1115fe4>] ? __d_free+0x34/0x50
Apr 10 00:02:07 soho kernel: [<c11176b5>] ? d_free+0x45/0x50
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<faa928a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:02:07 soho kernel: [<faa92840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: gpodder         D f37d7d20     0 13836
1931 0x00000000
Apr 10 00:02:07 soho kernel: f37d7d30 00200086 00000002 f37d7d20
00000022 00000000 00000000 00000000
Apr 10 00:02:07 soho kernel: f3cfa550 00000000 ed94a0c0 00000000
f37d7cf0 f5a06380 c14c0380 ee04b810
Apr 10 00:02:07 soho kernel: ee04b9d4 f8dcd180 f62a5800 c14c0380
f5a06380 ee04b810 f4462f70 f3f66000
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c1295682>] ? sch_direct_xmit+0x42/0x180
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c102bfbc>] ? __kunmap_atomic+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:02:07 soho kernel: [<c10c06e0>] generic_file_aio_read
+0x460/0x730
Apr 10 00:02:07 soho kernel: [<c11044c4>] do_sync_read+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c110881c>] ? cp_new_stat64+0xdc/0xf0
Apr 10 00:02:07 soho kernel: [<c116f86c>] ? security_file_permission
+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 10 00:02:07 soho kernel: [<c1104ca3>] vfs_read+0x83/0x160
Apr 10 00:02:07 soho kernel: [<c1104420>] ? do_sync_read+0x0/0xe0
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104db8>] sys_read+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: chromium        D f376dd20     0  2734
1 0x00000000
Apr 10 00:02:07 soho kernel: f376dd30 00200086 00000002 f376dd20
00000000 f376dce8 c103cf87 00000000
Apr 10 00:02:07 soho kernel: c100a278 f376dce8 c106738b 00002b99
87f4a5ef f5806380 c14c0380 f3e6ef70
Apr 10 00:02:07 soho kernel: f3e6f134 f1f98f00 f1f98f00 c14c0380
f5806380 f3e6ef70 c1429f60 f376dda0
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c103cf87>] ? update_curr+0x167/0x250
Apr 10 00:02:07 soho kernel: [<c100a278>] ? sched_clock+0x8/0x10
Apr 10 00:02:07 soho kernel: [<c106738b>] ? sched_clock_local+0xcb/0x1c0
Apr 10 00:02:07 soho kernel: [<faa8a5bf>] ? search_by_entry_key
+0x1f/0x260 [reiserfs]
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1118a62>] ? d_splice_alias+0x92/0xe0
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c102bfbc>] ? __kunmap_atomic+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:02:07 soho kernel: [<c10c06e0>] generic_file_aio_read
+0x460/0x730
Apr 10 00:02:07 soho kernel: [<c11044c4>] do_sync_read+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f86c>] ? security_file_permission
+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 10 00:02:07 soho kernel: [<c1104ca3>] vfs_read+0x83/0x160
Apr 10 00:02:07 soho kernel: [<c1104420>] ? do_sync_read+0x0/0xe0
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104db8>] sys_read+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: chromium        D ed85fcd8     0  2735
1 0x00000000
Apr 10 00:02:07 soho kernel: ed85fce8 00200086 00000002 ed85fcd8
eed4c04c dbe26048 eed4c000 00000000
Apr 10 00:02:07 soho kernel: 0000000d ed85fcb4 f425fc00 001113a8
f425fc00 f5806380 c14c0380 f39e8000
Apr 10 00:02:07 soho kernel: f39e81c4 f425fc00 f430a248 c14c0380
f5806380 f39e8000 c1429f60 ed85fcb4
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaac883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacb1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacaa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:02:07 soho kernel: [<c100271e>] ? __switch_to+0xce/0x180
Apr 10 00:02:07 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:02:07 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:02:07 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:02:07 soho kernel: [<c102eb6f>] ? __wake_up_common+0x3f/0x70
Apr 10 00:02:07 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:02:07 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<faa928a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:02:07 soho kernel: [<faa92840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: chromium        D f3295b08     0  2737
1 0x00000000
Apr 10 00:02:07 soho kernel: f2e2bcf0 00200086 ee684ba8 f3295b08
f3295b4c 00000000 f3295b00 f2e2bcfb
Apr 10 00:02:07 soho kernel: 0000000d f2e2bcbc f425fc00 001113a8
f425fc00 f5a06380 c14c0380 f39e8cf0
Apr 10 00:02:07 soho kernel: f39e8eb4 3f3f3601 00002b96 c14c0380
f5a06380 f39e8cf0 d2d0eb20 f2e2bcbc
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaac883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacb1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacaa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:02:07 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:02:07 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:02:07 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:02:07 soho kernel: [<c102eb6f>] ? __wake_up_common+0x3f/0x70
Apr 10 00:02:07 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:02:07 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<faa928a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:02:07 soho kernel: [<faa92840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104f43>] sys_pwrite64+0x63/0x80
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: chromium        D eab63d20     0  2820
1 0x00000000
Apr 10 00:02:07 soho kernel: eab63d30 00000086 00000002 eab63d20
00000000 00000000 00000000 00000000
Apr 10 00:02:07 soho kernel: 00000000 00000000 00000001 00000001
00000001 f5a06380 c14c0380 d9e073c0
Apr 10 00:02:07 soho kernel: d9e07584 00000002 eab63d58 c14c0380
f5a06380 d9e073c0 f4462f70 eab63df8
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c11a6878>] ? timerqueue_add+0x58/0xb0
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c102bfbc>] ? __kunmap_atomic+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:02:07 soho kernel: [<c10c06e0>] generic_file_aio_read
+0x460/0x730
Apr 10 00:02:07 soho kernel: [<c10da895>] ? do_wp_page+0x325/0x780
Apr 10 00:02:07 soho kernel: [<c11044c4>] do_sync_read+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f86c>] ? security_file_permission
+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 10 00:02:07 soho kernel: [<c1104ca3>] vfs_read+0x83/0x160
Apr 10 00:02:07 soho kernel: [<c1104420>] ? do_sync_read+0x0/0xe0
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104db8>] sys_read+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: gvfsd-metadata  D 00000000     0  4949
1 0x00000000
Apr 10 00:02:07 soho kernel: eac71d54 00000086 c103e510 00000000
00000000 ed221df8 ead2e430 eac71ce4
Apr 10 00:02:07 soho kernel: c102eb6f 000000c3 00000001 00000001
ed221e04 f5a06380 c14c0380 de42c000
Apr 10 00:02:07 soho kernel: de42c1c4 ba3e67af 00002b98 c14c0380
f5a06380 de42c000 c56e0450 e00b7200
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<c102eb6f>] ? __wake_up_common+0x3f/0x70
Apr 10 00:02:07 soho kernel: [<faa8a877>] ? reiserfs_find_entry
+0x77/0x330 [reiserfs]
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa8c0b4>] reiserfs_create+0xa4/0x200
[reiserfs]
Apr 10 00:02:07 soho kernel: [<faaacd40>] ? reiserfs_permission+0x0/0x50
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c116f5a5>] ? security_inode_permission
+0x15/0x20
Apr 10 00:02:07 soho kernel: [<c1110373>] vfs_create+0x93/0x100
Apr 10 00:02:07 soho kernel: [<c11113df>] do_last+0x29f/0x320
Apr 10 00:02:07 soho kernel: [<c111177d>] do_filp_open+0x31d/0x6a0
Apr 10 00:02:07 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:02:07 soho kernel: [<c1104015>] do_sys_open+0x55/0xf0
Apr 10 00:02:07 soho kernel: [<c11040d9>] sys_open+0x29/0x40
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: totem           D f1f9be3c     0 14105
1 0x00000000
Apr 10 00:02:07 soho kernel: f1f9be4c 00200086 00000002 f1f9be3c
c126c11a 00001000 f614e7a0 00000000
Apr 10 00:02:07 soho kernel: 00000000 f614e7c0 f1f9be38 c10c4778
00000001 f5806380 c14c0380 ed9ab810
Apr 10 00:02:07 soho kernel: ed9ab9d4 00000000 ed9ab810 c14c0380
f5806380 ed9ab810 c1429f60 00000000
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c126c11a>] ? sock_recvmsg+0xfa/0x120
Apr 10 00:02:07 soho kernel: [<c10c4778>] ? get_page_from_freelist
+0x278/0x4e0
Apr 10 00:02:07 soho kernel: [<c11a0911>] ? cpumask_any_but+0x21/0x40
Apr 10 00:02:07 soho kernel: [<c1318f3d>] __mutex_lock_slowpath
+0x10d/0x2b0
Apr 10 00:02:07 soho kernel: [<c13190eb>] mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<c10c01fb>] generic_file_aio_write
+0x4b/0xd0
Apr 10 00:02:07 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:02:07 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:02:07 soho kernel: [<faa928a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:02:07 soho kernel: [<faa92840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:02:07 soho kernel: chromium        D e91f7d20     0 13838
1 0x00000000
Apr 10 00:02:07 soho kernel: e91f7d30 00000086 00000002 e91f7d20
f4404a00 f50a0464 f4404a00 00000000
Apr 10 00:02:07 soho kernel: e91f7cb8 c10fd74a e91f7cb0 f50a0464
00000000 f5a06380 c14c0380 f38259e0
Apr 10 00:02:07 soho kernel: f3825ba4 00001000 f6a7b2a0 c14c0380
f5a06380 f38259e0 f4462f70 e91f7cf4
Apr 10 00:02:07 soho kernel: Call Trace:
Apr 10 00:02:07 soho kernel: [<c10fd74a>] ? __mem_cgroup_commit_charge
+0x7a/0x120
Apr 10 00:02:07 soho kernel: [<c10e3c1c>] ? page_add_new_anon_rmap
+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c10dcaeb>] ? handle_pte_fault+0x3bb/0x8d0
Apr 10 00:02:07 soho kernel: [<faaa42ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:02:07 soho kernel: [<faaa9729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:02:07 soho kernel: [<c10276d3>] ? do_page_fault+0x193/0x430
Apr 10 00:02:07 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:02:07 soho kernel: [<faaa9920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:02:07 soho kernel: [<faa983fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:02:07 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:02:07 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:02:07 soho kernel: [<c131ad5b>] ? error_code+0x67/0x6c
Apr 10 00:02:07 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:02:07 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:02:07 soho kernel: [<c10c06e0>] generic_file_aio_read
+0x460/0x730
Apr 10 00:02:07 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 10 00:02:07 soho kernel: [<c11044c4>] do_sync_read+0xa4/0xe0
Apr 10 00:02:07 soho kernel: [<c116f86c>] ? security_file_permission
+0x8c/0xa0
Apr 10 00:02:07 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 10 00:02:07 soho kernel: [<c1104ca3>] vfs_read+0x83/0x160
Apr 10 00:02:07 soho kernel: [<c1104420>] ? do_sync_read+0x0/0xe0
Apr 10 00:02:07 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:02:07 soho kernel: [<c1104db8>] sys_read+0x38/0x70
Apr 10 00:02:07 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:11:59 soho kernel: conky           D ef76fcd8     0  4539
4415 0x00000000
Apr 10 00:11:59 soho kernel: ef76fce8 00200086 00000002 ef76fcd8
efd81ecc f4404a00 efd81e80 00000000
Apr 10 00:11:59 soho kernel: 0000000b ef76fcb4 f41c3180 00005ba8
f41c3180 f5806380 c14c0380 f385b810
Apr 10 00:11:59 soho kernel: f385b9d4 f41c3180 f43fe248 c14c0380
f5806380 f385b810 c1429f60 ef76fcb4
Apr 10 00:11:59 soho kernel: Call Trace:
Apr 10 00:11:59 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:11:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:11:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:11:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:11:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:11:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38b1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38aa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:11:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:11:59 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:11:59 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:11:59 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:11:59 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:11:59 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 10 00:11:59 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 10 00:11:59 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:11:59 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:11:59 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:11:59 soho kernel: [<fab1e8a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:11:59 soho kernel: [<fab1e840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:11:59 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:11:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:11:59 soho kernel: chromium        D ee895ed0     0  5523
1 0x00000000
Apr 10 00:11:59 soho kernel: ee895ee0 00200086 00000002 ee895ed0
f5806380 ee90f810 c1429f60 00000000
Apr 10 00:11:59 soho kernel: 00026f20 00200286 f4480000 ee895e74
c1051cb6 f5806380 c14c0380 ee90f810
Apr 10 00:11:59 soho kernel: ee90f9d4 543e9415 0000002e c14c0380
f5806380 ee90f810 c1429f60 00486a41
Apr 10 00:11:59 soho kernel: Call Trace:
Apr 10 00:11:59 soho kernel: [<c1051cb6>] ? lock_timer_base.isra.31
+0x26/0x50
Apr 10 00:11:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:11:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:11:59 soho kernel: [<fab35e84>] reiserfs_commit_for_inode
+0xf4/0x1f0 [reiserfs]
Apr 10 00:11:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:11:59 soho kernel: [<fab1e7e2>] reiserfs_sync_file+0x42/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c1128f22>] vfs_fsync_range+0x52/0x80
Apr 10 00:11:59 soho kernel: [<c1128ff2>] vfs_fsync+0x22/0x30
Apr 10 00:11:59 soho kernel: [<c1129244>] sys_fdatasync+0x24/0x50
Apr 10 00:11:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:11:59 soho kernel: chromium        D ea92ae08     0  5524
1 0x00000000
Apr 10 00:11:59 soho kernel: ee567ce8 00200086 ea9458c8 ea92ae08
ea92ae4c eada6060 ea92ae00 ee567cf3
Apr 10 00:11:59 soho kernel: 0000000b ee567cb4 f41c3180 00005aee
f41c3180 f5a06380 c14c0380 ee90de30
Apr 10 00:11:59 soho kernel: ee90dff4 f41c3180 f43fe248 c14c0380
f5a06380 ee90de30 f4462f70 ee567cb4
Apr 10 00:11:59 soho kernel: Call Trace:
Apr 10 00:11:59 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:11:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:11:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:11:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:11:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:11:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38b1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<fab38aa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:11:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:11:59 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:11:59 soho kernel: [<c100271e>] ? __switch_to+0xce/0x180
Apr 10 00:11:59 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:11:59 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:11:59 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:11:59 soho kernel: [<c102eb6f>] ? __wake_up_common+0x3f/0x70
Apr 10 00:11:59 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:11:59 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:11:59 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:11:59 soho kernel: [<fab1e8a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:11:59 soho kernel: [<fab1e840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:11:59 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:11:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:11:59 soho kernel: chromium        D c110ef7a     0  5526
1 0x00000000
Apr 10 00:11:59 soho kernel: ee50fd34 00200086 ee50fcac c110ef7a
f43fe264 00000000 ee50fcbc f41c3180
Apr 10 00:11:59 soho kernel: ee50fcfb f41c3080 ee50fcd0 f43fe264
ee50fcc8 f5a06380 c14c0380 ee90e6d0
Apr 10 00:11:59 soho kernel: ee90e894 1c944294 00000033 c14c0380
f5a06380 ee90e6d0 eefe08a0 fab41643
Apr 10 00:11:59 soho kernel: Call Trace:
Apr 10 00:11:59 soho kernel: [<c110ef7a>] ? __lookup_hash+0x6a/0x100
Apr 10 00:11:59 soho kernel: [<c103d060>] ? update_curr+0x240/0x250
Apr 10 00:11:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:11:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:11:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:11:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c11a43c9>] ? __prop_inc_single+0x49/0x60
Apr 10 00:11:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:11:59 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:11:59 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:11:59 soho kernel: [<c10da8d7>] do_wp_page+0x367/0x780
Apr 10 00:11:59 soho kernel: [<c10dc962>] handle_pte_fault+0x232/0x8d0
Apr 10 00:11:59 soho kernel: [<c10d9fa9>] ? __pte_alloc+0xa9/0x100
Apr 10 00:11:59 soho kernel: [<c10dd109>] handle_mm_fault+0x109/0x200
Apr 10 00:11:59 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:11:59 soho kernel: [<c1027661>] do_page_fault+0x121/0x430
Apr 10 00:11:59 soho kernel: [<c106ae54>] ? ktime_get_ts+0xe4/0x110
Apr 10 00:11:59 soho kernel: [<c11aaa84>] ? copy_to_user+0x34/0x50
Apr 10 00:11:59 soho kernel: [<c1060616>] ? sys_clock_gettime+0x66/0xa0
Apr 10 00:11:59 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 10 00:11:59 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 10 00:11:59 soho kernel: chromium        D ef7b3d20     0  5619
1 0x00000000
Apr 10 00:11:59 soho kernel: ef7b3d30 00000086 00000002 ef7b3d20
00000000 00000000 00000000 00000000
Apr 10 00:11:59 soho kernel: 00000000 00000000 00000001 00000001
00000001 f5806380 c14c0380 ef7a9140
Apr 10 00:11:59 soho kernel: ef7a9304 00000002 ef7b3d58 c14c0380
f5806380 ef7a9140 c1429f60 ef7b3df8
Apr 10 00:11:59 soho kernel: Call Trace:
Apr 10 00:11:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:11:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c11a6878>] ? timerqueue_add+0x58/0xb0
Apr 10 00:11:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:11:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:11:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:11:59 soho kernel: [<c1064d50>] ? lock_hrtimer_base.isra.25
+0x20/0x50
Apr 10 00:11:59 soho kernel: [<c1064e3f>] ? hrtimer_try_to_cancel
+0x6f/0xe0
Apr 10 00:11:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:11:59 soho kernel: [<c102bfbc>] ? __kunmap_atomic+0x8c/0xa0
Apr 10 00:11:59 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:11:59 soho kernel: [<c10c06e0>] generic_file_aio_read
+0x460/0x730
Apr 10 00:11:59 soho kernel: [<c11044c4>] do_sync_read+0xa4/0xe0
Apr 10 00:11:59 soho kernel: [<c116f86c>] ? security_file_permission
+0x8c/0xa0
Apr 10 00:11:59 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 10 00:11:59 soho kernel: [<c1104ca3>] vfs_read+0x83/0x160
Apr 10 00:11:59 soho kernel: [<c1104420>] ? do_sync_read+0x0/0xe0
Apr 10 00:11:59 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:11:59 soho kernel: [<c1104db8>] sys_read+0x38/0x70
Apr 10 00:11:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:13:59 soho kernel: khugepaged      D f47b9ec8     0    26
2 0x00000000
Apr 10 00:13:59 soho kernel: f47b9ed8 00000046 00000002 f47b9ec8
f5a06380 00000000 00000000 00000000
Apr 10 00:13:59 soho kernel: 00000000 c1451224 c14c0380 c1451904
f44d5590 f5a06380 c14c0380 f44d5590
Apr 10 00:13:59 soho kernel: f44d5754 f6da9000 c1451200 c14c0380
f5a06380 f44d5590 f4462f70 00000002
Apr 10 00:13:59 soho kernel: Call Trace:
Apr 10 00:13:59 soho kernel: [<c10c50dd>] ? __alloc_pages_nodemask
+0xed/0x750
Apr 10 00:13:59 soho kernel: [<c1051e01>] ? del_timer_sync+0x21/0x40
Apr 10 00:13:59 soho kernel: [<c1318121>] ? schedule_timeout+0x131/0x2e0
Apr 10 00:13:59 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 10 00:13:59 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 10 00:13:59 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 10 00:13:59 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 10 00:13:59 soho kernel: [<c10f88ed>] khugepaged+0x25d/0xdd0
Apr 10 00:13:59 soho kernel: [<c1061240>] ? autoremove_wake_function
+0x0/0x40
Apr 10 00:13:59 soho kernel: [<c10f8690>] ? khugepaged+0x0/0xdd0
Apr 10 00:13:59 soho kernel: [<c1060ba8>] kthread+0x68/0x70
Apr 10 00:13:59 soho kernel: [<c1060b40>] ? kthread+0x0/0x70
Apr 10 00:13:59 soho kernel: [<c1003d7e>] kernel_thread_helper+0x6/0x18
Apr 10 00:13:59 soho kernel: preload         D f3e07ed0     0  2907
1 0x00000000
Apr 10 00:13:59 soho kernel: f3e07ee0 00000086 00000002 f3e07ed0
ebbacf00 f3e07f00 eff0e680 00000000
Apr 10 00:13:59 soho kernel: c110ed8d 0000416d 00000001 f449ef00
f3e07e78 f5a06380 c14c0380 f385af70
Apr 10 00:13:59 soho kernel: f385b134 c114ccd0 f3e07ed4 c14c0380
f5a06380 f385af70 f4462f70 f62e4cc0
Apr 10 00:13:59 soho kernel: Call Trace:
Apr 10 00:13:59 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 10 00:13:59 soho kernel: [<c114ccd0>] ? proc_pid_follow_link
+0x0/0x40
Apr 10 00:13:59 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 10 00:13:59 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 10 00:13:59 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 10 00:13:59 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 10 00:13:59 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 10 00:13:59 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 10 00:13:59 soho kernel: [<c114e9b8>] get_mm_exe_file+0x18/0x40
Apr 10 00:13:59 soho kernel: [<c114ea1e>] proc_exe_link+0x3e/0x90
Apr 10 00:13:59 soho kernel: [<c114cd3f>] proc_pid_readlink+0x2f/0xc0
Apr 10 00:13:59 soho kernel: [<c1119afc>] ? touch_atime+0x5c/0x140
Apr 10 00:13:59 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 10 00:13:59 soho kernel: [<c1108ec9>] sys_readlinkat+0x89/0x90
Apr 10 00:13:59 soho kernel: [<c1108ef7>] sys_readlink+0x27/0x30
Apr 10 00:13:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:13:59 soho kernel: gnome-settings- D f3b7fe30     0  4459
4415 0x00000000
Apr 10 00:13:59 soho kernel: f3b7fe40 00000086 00000002 f3b7fe30
00502a45 005028e3 00502a2c 00000000
Apr 10 00:13:59 soho kernel: 00500c0f 005034e3 f3fff014 f3b7fde8
c131901b f5a06380 c14c0380 ee914450
Apr 10 00:13:59 soho kernel: ee914614 22222222 22222222 c14c0380
f5a06380 ee914450 f4462f70 ea9c5e68
Apr 10 00:13:59 soho kernel: Call Trace:
Apr 10 00:13:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:13:59 soho kernel: [<c1318e28>] ? mutex_unlock+0x8/0x10
Apr 10 00:13:59 soho kernel: [<fab390d7>] ? reiserfs_write_unlock
+0x37/0x40 [reiserfs]
Apr 10 00:13:59 soho kernel: [<fab1f2be>] ? reiserfs_readdir_dentry
+0x39e/0x530 [reiserfs]
Apr 10 00:13:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:13:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:13:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:13:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c10dd103>] ? handle_mm_fault+0x103/0x200
Apr 10 00:13:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:13:59 soho kernel: [<c131883f>] ?
__mutex_lock_killable_slowpath+0x1ff/0x340
Apr 10 00:13:59 soho kernel: [<c1119b98>] touch_atime+0xf8/0x140
Apr 10 00:13:59 soho kernel: [<c1114361>] vfs_readdir+0xb1/0xc0
Apr 10 00:13:59 soho kernel: [<c1114040>] ? filldir64+0x0/0xe0
Apr 10 00:13:59 soho kernel: [<c11144e3>] sys_getdents64+0x63/0xc0
Apr 10 00:13:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:13:59 soho kernel: conky           D ef76fcd8     0  4539
4415 0x00000000
Apr 10 00:13:59 soho kernel: ef76fce8 00200086 00000002 ef76fcd8
efd81ecc f4404a00 efd81e80 00000000
Apr 10 00:13:59 soho kernel: 0000000b ef76fcb4 f41c3180 00005ba8
f41c3180 f5806380 c14c0380 f385b810
Apr 10 00:13:59 soho kernel: f385b9d4 f41c3180 f43fe248 c14c0380
f5806380 f385b810 c1429f60 ef76fcb4
Apr 10 00:13:59 soho kernel: Call Trace:
Apr 10 00:13:59 soho kernel: [<c1118096>] ? dput+0xe6/0x160
Apr 10 00:13:59 soho kernel: [<fab302ed>] queue_log_writer+0x6d/0xa0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c103e510>] ? default_wake_function
+0x0/0x10
Apr 10 00:13:59 soho kernel: [<fab35729>] do_journal_begin_r+0x1e9/0x360
[reiserfs]
Apr 10 00:13:59 soho kernel: [<fab38883>] ? reiserfs_xattr_get
+0x33/0x250 [reiserfs]
Apr 10 00:13:59 soho kernel: [<c131901b>] ? __mutex_lock_slowpath
+0x1eb/0x2b0
Apr 10 00:13:59 soho kernel: [<fab35920>] journal_begin+0x80/0x160
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c13190eb>] ? mutex_lock+0xb/0x20
Apr 10 00:13:59 soho kernel: [<fab243fe>] reiserfs_dirty_inode+0x2e/0xb0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<fab38b1c>] ? reiserfs_getxattr+0x7c/0xa0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<fab38aa0>] ? reiserfs_getxattr+0x0/0xa0
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c116e856>] ? cap_inode_need_killpriv
+0x26/0x40
Apr 10 00:13:59 soho kernel: [<c1124d69>] __mark_inode_dirty+0x29/0x1b0
Apr 10 00:13:59 soho kernel: [<c10be61f>] ? file_remove_suid+0x1f/0x70
Apr 10 00:13:59 soho kernel: [<c111d35b>] ? mnt_clone_write+0xb/0x50
Apr 10 00:13:59 soho kernel: [<c1119a39>] file_update_time+0xb9/0x120
Apr 10 00:13:59 soho kernel: [<c10bff13>] __generic_file_aio_write
+0x223/0x4c0
Apr 10 00:13:59 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 10 00:13:59 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 10 00:13:59 soho kernel: [<c10c020e>] generic_file_aio_write
+0x5e/0xd0
Apr 10 00:13:59 soho kernel: [<c11043e4>] do_sync_write+0xa4/0xe0
Apr 10 00:13:59 soho kernel: [<c116f7ff>] ? security_file_permission
+0x1f/0xa0
Apr 10 00:13:59 soho kernel: [<fab1e8a8>] reiserfs_file_write+0x68/0x90
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c1104b46>] vfs_write+0x86/0x160
Apr 10 00:13:59 soho kernel: [<fab1e840>] ? reiserfs_file_write+0x0/0x90
[reiserfs]
Apr 10 00:13:59 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 10 00:13:59 soho kernel: [<c1104e28>] sys_write+0x38/0x70
Apr 10 00:13:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 10 00:13:59 soho kernel: chromium        D ef717f2c     0  5513
1 0x00000000
Apr 10 00:13:59 soho kernel: ef717f3c 00000086 00000002 ef717f2c
00000000 00000101 00000024 00000000
Apr 10 00:13:59 soho kernel: c11115ae ef717ee8 00000001 c1335880
00000001 f5806380 c14c0380 eefe1140
Apr 10 00:13:59 soho kernel: eefe1304 c11aaa84 ef717f60 c14c0380
f5806380 eefe1140 c1429f60 bfc23270
Apr 10 00:13:59 soho kernel: Call Trace:
Apr 10 00:13:59 soho kernel: [<c11115ae>] ? do_filp_open+0x14e/0x6a0
Apr 10 00:13:59 soho kernel: [<c11aaa84>] ? copy_to_user+0x34/0x50
Apr 10 00:13:59 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 10 00:13:59 soho kernel: [<c1319bf2>] rwsem_down_write_failed
+0x12/0x20
Apr 10 00:13:59 soho kernel: [<c1319c5a>] call_rwsem_down_write_failed
+0x6/0x8
Apr 10 00:13:59 soho kernel: [<c1319405>] ? down_write+0x15/0x17
Apr 10 00:13:59 soho kernel: [<c10e1210>] sys_mmap_pgoff+0xd0/0x1c0
Apr 10 00:13:59 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28

Second time
Apr 12 22:51:21 soho kernel: flush-8:0       D f3af2700     0  2359
2 0x00000000
Apr 12 22:51:21 soho kernel: f3ec5d3c 00000046 f3cb8000 f3af2700
f3cb8000 f3cb8000 f4585800 f3cb8000
Apr 12 22:51:21 soho kernel: f3ec5ccc c11a1f9d f3ec5cd4 f3cb8300
000000d8 f5a06380 c14c0380 f3988cf0
Apr 12 22:51:21 soho kernel: f3988eb4 64a2a0fb 00000bd7 c14c0380
f5a06380 f3988cf0 f21ad9e0 00000000
Apr 12 22:51:21 soho kernel: Call Trace:
Apr 12 22:51:21 soho kernel: [<c11a1f9d>] ? kobject_put+0x1d/0x50
Apr 12 22:51:21 soho kernel: [<c106ae54>] ? ktime_get_ts+0xe4/0x110
Apr 12 22:51:21 soho kernel: [<c1317d8c>] io_schedule+0x5c/0xa0
Apr 12 22:51:21 soho kernel: [<c10beba5>] sync_page+0x35/0x40
Apr 12 22:51:21 soho kernel: [<c1318457>] __wait_on_bit_lock+0x47/0x90
Apr 12 22:51:21 soho kernel: [<c10beb70>] ? sync_page+0x0/0x40
Apr 12 22:51:21 soho kernel: [<c10beb53>] __lock_page+0x73/0x80
Apr 12 22:51:21 soho kernel: [<c1061280>] ? wake_bit_function+0x0/0x60
Apr 12 22:51:21 soho kernel: [<c10c6768>] write_cache_pages+0x338/0x3d0
Apr 12 22:51:21 soho kernel: [<c103cf4e>] ? update_curr+0x12e/0x250
Apr 12 22:51:21 soho kernel: [<c10c61c0>] ? __writepage+0x0/0x30
Apr 12 22:51:21 soho kernel: [<c10c6823>] generic_writepages+0x23/0x30
Apr 12 22:51:21 soho kernel: [<c10c7585>] do_writepages+0x25/0x30
Apr 12 22:51:21 soho kernel: [<c11245f4>] writeback_single_inode
+0x74/0x1d0
Apr 12 22:51:21 soho kernel: [<c1124c51>] writeback_sb_inodes+0xa1/0x140
Apr 12 22:51:21 soho kernel: [<c11257a6>] writeback_inodes_wb+0xc6/0x150
Apr 12 22:51:21 soho kernel: [<c1125b62>] wb_writeback+0x332/0x3e0
Apr 12 22:51:21 soho kernel: [<c111b118>] ? get_nr_dirty_inodes+0x8/0x20
Apr 12 22:51:21 soho kernel: [<c1125e1b>] wb_do_writeback+0x20b/0x220
Apr 12 22:51:21 soho kernel: [<c1051270>] ? process_timeout+0x0/0x10
Apr 12 22:51:21 soho kernel: [<c1125e9d>] bdi_writeback_thread
+0x6d/0x290
Apr 12 22:51:21 soho kernel: [<c1125e30>] ? bdi_writeback_thread
+0x0/0x290
Apr 12 22:51:21 soho kernel: [<c1060ba8>] kthread+0x68/0x70
Apr 12 22:51:21 soho kernel: [<c1060b40>] ? kthread+0x0/0x70
Apr 12 22:51:21 soho kernel: [<c1003d7e>] kernel_thread_helper+0x6/0x18
Apr 12 22:51:21 soho kernel: conky           D f05df208     0  4305
4208 0x00000000
Apr 12 22:51:21 soho kernel: f24a5ce8 00200086 00000001 f05df208
f05df24c f4404a00 f05dApr 12 23:10:36 soho kernel: Initializing cgroup
subsys cpuset


third time

Apr 16 18:27:43 soho pulseaudio[3983]: ratelimit.c: 4 events suppressed
Apr 16 18:33:36 soho pulseaudio[3983]: ratelimit.c: 48 events suppressed
Apr 16 18:34:39 soho pulseaudio[3983]: ratelimit.c: 166 events
suppressed
Apr 16 18:38:48 soho kernel: preload         D f3adbed0     0  2701
1 0x00000000
Apr 16 18:38:48 soho kernel: f3adbee0 00000086 00000002 f3adbed0
f2341380 f3adbf00 f2341b00 00000000
Apr 16 18:38:48 soho kernel: c110ed8d 0000416d 00000001 f449ef00
f3adbe78 f5a06380 c14c0380 f3fb9590
Apr 16 18:38:48 soho kernel: f3fb9754 c114ccd0 f3adbed4 c14c0380
f5a06380 f3fb9590 f4462f70 f5ef59c0
Apr 16 18:38:48 soho kernel: Call Trace:
Apr 16 18:38:48 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 16 18:38:48 soho kernel: [<c114ccd0>] ? proc_pid_follow_link
+0x0/0x40
Apr 16 18:38:48 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 16 18:38:48 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 16 18:38:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:38:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:38:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:38:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:38:48 soho kernel: [<c114e9b8>] get_mm_exe_file+0x18/0x40
Apr 16 18:38:48 soho kernel: [<c114ea1e>] proc_exe_link+0x3e/0x90
Apr 16 18:38:48 soho kernel: [<c114cd3f>] proc_pid_readlink+0x2f/0xc0
Apr 16 18:38:48 soho kernel: [<c1119afc>] ? touch_atime+0x5c/0x140
Apr 16 18:38:48 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 16 18:38:48 soho kernel: [<c1108ec9>] sys_readlinkat+0x89/0x90
Apr 16 18:38:48 soho kernel: [<c1108ef7>] sys_readlink+0x27/0x30
Apr 16 18:38:48 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 16 18:38:48 soho kernel: java            D 00000001     0 12589
12578 0x00000000
Apr 16 18:38:48 soho kernel: f447ff3c 00200086 c10e3c1c 00000001
f1679af8 f029f738 f447ff00 f447ff00
Apr 16 18:38:48 soho kernel: c10dcaeb 00000000 00000000 f447fedc
00200286 f5806380 c14c0380 f3c0eb20
Apr 16 18:38:48 soho kernel: f3c0ece4 31679067 f64aff60 c14c0380
f5806380 f3c0eb20 c1429f60 97a4e067
Apr 16 18:38:48 soho kernel: Call Trace:
Apr 16 18:38:48 soho kernel: [<c10e3c1c>] ? page_add_new_anon_rmap
+0x8c/0xa0
Apr 16 18:38:48 soho kernel: [<c10dcaeb>] ? handle_pte_fault+0x3bb/0x8d0
Apr 16 18:38:48 soho kernel: [<c10dd109>] ? handle_mm_fault+0x109/0x200
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:38:48 soho kernel: [<c1319bf2>] rwsem_down_write_failed
+0x12/0x20
Apr 16 18:38:48 soho kernel: [<c1319c5a>] call_rwsem_down_write_failed
+0x6/0x8
Apr 16 18:38:48 soho kernel: [<c1319405>] ? down_write+0x15/0x17
Apr 16 18:38:48 soho kernel: [<c10e1210>] sys_mmap_pgoff+0xd0/0x1c0
Apr 16 18:38:48 soho kernel: [<c104ab97>] ? irq_exit+0x37/0x70
Apr 16 18:38:48 soho kernel: [<c101e956>] ? smp_apic_timer_interrupt
+0x56/0x90
Apr 16 18:38:48 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 16 18:38:48 soho kernel: java            D c1072f6f     0 12591
12578 0x00000000
Apr 16 18:38:48 soho kernel: e1373ee0 00200086 e1373ef4 c1072f6f
e1373e64 e1373e9c e1373f98 f3694000
Apr 16 18:38:48 soho kernel: 00000001 09fcbe94 00000000 ffffff92
e1373e70 f5a06380 c14c0380 f3694000
Apr 16 18:38:48 soho kernel: f36941c4 efc47c98 0000130d c14c0380
f5a06380 f3694000 f259f3c0 00000000
Apr 16 18:38:48 soho kernel: Call Trace:
Apr 16 18:38:48 soho kernel: [<c1072f6f>] ? futex_wait+0x19f/0x280
Apr 16 18:38:48 soho kernel: [<c1072b2d>] ? get_futex_key+0x6d/0x1d0
Apr 16 18:38:48 soho kernel: [<c1073195>] ? futex_wake+0xe5/0x100
Apr 16 18:38:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:38:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:38:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:38:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:38:48 soho kernel: [<c1065777>] ? hrtimer_interrupt
+0x127/0x240
Apr 16 18:38:48 soho kernel: [<c1074fd4>] ? sys_futex+0xc4/0x130
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:38:48 soho kernel: java            D 00000014     0 12599
12578 0x00000000
Apr 16 18:38:48 soho kernel: ec01dee0 00200086 f5a063c4 00000014
cdb55b00 00000000 00000040 ec01de5c
Apr 16 18:38:48 soho kernel: c1369da0 00001000 00000040 ec01ded0
c126cea4 f5806380 c14c0380 f35df810
Apr 16 18:38:48 soho kernel: f35df9d4 32bd6f81 0000130d c14c0380
f5806380 f35df810 f268d9e0 00000040
Apr 16 18:38:48 soho kernel: Call Trace:
Apr 16 18:38:48 soho kernel: [<c126cea4>] ? sock_aio_read+0x114/0x130
Apr 16 18:38:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:38:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:38:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:38:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:38:48 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 16 18:38:48 soho kernel: [<c1104d69>] ? vfs_read+0x149/0x160
Apr 16 18:38:48 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 16 18:38:48 soho kernel: [<c1104dd4>] ? sys_read+0x54/0x70
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:38:48 soho kernel: java            D c1072f6f     0 13316
12578 0x00000000
Apr 16 18:38:48 soho kernel: cf1e1ee0 00000086 cf1e1ef4 c1072f6f
cf1e1e64 cf1e1e9c cf1e1f98 cb5e48a0
Apr 16 18:38:48 soho kernel: 00000001 0a0cc23c 00000000 ffffff92
cf1e1e70 f5806380 c14c0380 cb5e48a0
Apr 16 18:38:48 soho kernel: cb5e4a64 f4d82347 0000130d c14c0380
f5806380 cb5e48a0 f020b3c0 00000000
Apr 16 18:38:48 soho kernel: Call Trace:
Apr 16 18:38:48 soho kernel: [<c1072f6f>] ? futex_wait+0x19f/0x280
Apr 16 18:38:48 soho kernel: [<c1072b2d>] ? get_futex_key+0x6d/0x1d0
Apr 16 18:38:48 soho kernel: [<c1073195>] ? futex_wake+0xe5/0x100
Apr 16 18:38:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:38:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:38:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:38:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:38:48 soho kernel: [<c106afcb>] ? getnstimeofday+0x4b/0x110
Apr 16 18:38:48 soho kernel: [<c11aaa84>] ? copy_to_user+0x34/0x50
Apr 16 18:38:48 soho kernel: [<c104926d>] ? sys_gettimeofday+0x2d/0x70
Apr 16 18:38:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:38:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:40:48 soho kernel: preload         D f3adbed0     0  2701
1 0x00000000
Apr 16 18:40:48 soho kernel: f3adbee0 00000086 00000002 f3adbed0
f2341380 f3adbf00 f2341b00 00000000
Apr 16 18:40:48 soho kernel: c110ed8d 0000416d 00000001 f449ef00
f3adbe78 f5a06380 c14c0380 f3fb9590
Apr 16 18:40:48 soho kernel: f3fb9754 c114ccd0 f3adbed4 c14c0380
f5a06380 f3fb9590 f4462f70 f5ef59c0
Apr 16 18:40:48 soho kernel: Call Trace:
Apr 16 18:40:48 soho kernel: [<c110ed8d>] ? do_lookup+0xdd/0x260
Apr 16 18:40:48 soho kernel: [<c114ccd0>] ? proc_pid_follow_link
+0x0/0x40
Apr 16 18:40:48 soho kernel: [<c111deb5>] ? mntput_no_expire+0x25/0xd0
Apr 16 18:40:48 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 16 18:40:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:40:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:40:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:40:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:40:48 soho kernel: [<c114e9b8>] get_mm_exe_file+0x18/0x40
Apr 16 18:40:48 soho kernel: [<c114ea1e>] proc_exe_link+0x3e/0x90
Apr 16 18:40:48 soho kernel: [<c114cd3f>] proc_pid_readlink+0x2f/0xc0
Apr 16 18:40:48 soho kernel: [<c1119afc>] ? touch_atime+0x5c/0x140
Apr 16 18:40:48 soho kernel: [<c111df73>] ? mntput+0x13/0x20
Apr 16 18:40:48 soho kernel: [<c1108ec9>] sys_readlinkat+0x89/0x90
Apr 16 18:40:48 soho kernel: [<c1108ef7>] sys_readlink+0x27/0x30
Apr 16 18:40:48 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 16 18:40:48 soho kernel: java            D f25139dc     0 12584
12578 0x00000000
Apr 16 18:40:48 soho kernel: f3ca3ee0 00200086 056a069b f25139dc
f275d5bc 56e6ba66 0000018a f3ca3e78
Apr 16 18:40:48 soho kernel: 00000000 00001321 f25139c0 f5a06380
00000008 f5a06380 c14c0380 f16c9e30
Apr 16 18:40:48 soho kernel: f16c9ff4 056a7124 00001321 c14c0380
f5a06380 f16c9e30 f275d590 f25139c0
Apr 16 18:40:48 soho kernel: Call Trace:
Apr 16 18:40:48 soho kernel: [<c1072b2d>] ? get_futex_key+0x6d/0x1d0
Apr 16 18:40:48 soho kernel: [<c103e367>] ? try_to_wake_up+0x1a7/0x350
Apr 16 18:40:48 soho kernel: [<c1073195>] ? futex_wake+0xe5/0x100
Apr 16 18:40:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:40:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:40:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:40:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:40:48 soho kernel: [<c1065777>] ? hrtimer_interrupt
+0x127/0x240
Apr 16 18:40:48 soho kernel: [<c106afcb>] ? getnstimeofday+0x4b/0x110
Apr 16 18:40:48 soho kernel: [<c11aaa84>] ? copy_to_user+0x34/0x50
Apr 16 18:40:48 soho kernel: [<c104926d>] ? sys_gettimeofday+0x2d/0x70
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:40:48 soho kernel: java            D 00000001     0 12589
12578 0x00000000
Apr 16 18:40:48 soho kernel: f447ff3c 00200086 c10e3c1c 00000001
f1679af8 f029f738 f447ff00 f447ff00
Apr 16 18:40:48 soho kernel: c10dcaeb 00000000 00000000 f447fedc
00200286 f5806380 c14c0380 f3c0eb20
Apr 16 18:40:48 soho kernel: f3c0ece4 31679067 f64aff60 c14c0380
f5806380 f3c0eb20 c1429f60 97a4e067
Apr 16 18:40:48 soho kernel: Call Trace:
Apr 16 18:40:48 soho kernel: [<c10e3c1c>] ? page_add_new_anon_rmap
+0x8c/0xa0
Apr 16 18:40:48 soho kernel: [<c10dcaeb>] ? handle_pte_fault+0x3bb/0x8d0
Apr 16 18:40:48 soho kernel: [<c10dd109>] ? handle_mm_fault+0x109/0x200
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:40:48 soho kernel: [<c1319bf2>] rwsem_down_write_failed
+0x12/0x20
Apr 16 18:40:48 soho kernel: [<c1319c5a>] call_rwsem_down_write_failed
+0x6/0x8
Apr 16 18:40:48 soho kernel: [<c1319405>] ? down_write+0x15/0x17
Apr 16 18:40:48 soho kernel: [<c10e1210>] sys_mmap_pgoff+0xd0/0x1c0
Apr 16 18:40:48 soho kernel: [<c104ab97>] ? irq_exit+0x37/0x70
Apr 16 18:40:48 soho kernel: [<c101e956>] ? smp_apic_timer_interrupt
+0x56/0x90
Apr 16 18:40:48 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 16 18:40:48 soho kernel: java            D c1072f6f     0 12591
12578 0x00000000
Apr 16 18:40:48 soho kernel: e1373ee0 00200086 e1373ef4 c1072f6f
e1373e64 e1373e9c e1373f98 f3694000
Apr 16 18:40:48 soho kernel: 00000001 09fcbe94 00000000 ffffff92
e1373e70 f5a06380 c14c0380 f3694000
Apr 16 18:40:48 soho kernel: f36941c4 efc47c98 0000130d c14c0380
f5a06380 f3694000 f259f3c0 00000000
Apr 16 18:40:48 soho kernel: Call Trace:
Apr 16 18:40:48 soho kernel: [<c1072f6f>] ? futex_wait+0x19f/0x280
Apr 16 18:40:48 soho kernel: [<c1072b2d>] ? get_futex_key+0x6d/0x1d0
Apr 16 18:40:48 soho kernel: [<c1073195>] ? futex_wake+0xe5/0x100
Apr 16 18:40:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:40:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:40:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:40:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:40:48 soho kernel: [<c1065777>] ? hrtimer_interrupt
+0x127/0x240
Apr 16 18:40:48 soho kernel: [<c1074fd4>] ? sys_futex+0xc4/0x130
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:40:48 soho kernel: java            D 00000014     0 12599
12578 0x00000000
Apr 16 18:40:48 soho kernel: ec01dee0 00200086 f5a063c4 00000014
cdb55b00 00000000 00000040 ec01de5c
Apr 16 18:40:48 soho kernel: c1369da0 00001000 00000040 ec01ded0
c126cea4 f5806380 c14c0380 f35df810
Apr 16 18:40:48 soho kernel: f35df9d4 32bd6f81 0000130d c14c0380
f5806380 f35df810 f268d9e0 00000040
Apr 16 18:40:48 soho kernel: Call Trace:
Apr 16 18:40:48 soho kernel: [<c126cea4>] ? sock_aio_read+0x114/0x130
Apr 16 18:40:48 soho kernel: [<c1319b95>] rwsem_down_failed_common
+0x95/0xe0
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c1319c12>] rwsem_down_read_failed
+0x12/0x14
Apr 16 18:40:48 soho kernel: [<c1319c4f>] call_rwsem_down_read_failed
+0x7/0xc
Apr 16 18:40:48 soho kernel: [<c13193ed>] ? down_read+0xd/0x10
Apr 16 18:40:48 soho kernel: [<c102769a>] do_page_fault+0x15a/0x430
Apr 16 18:40:48 soho kernel: [<c11047e7>] ? rw_verify_area+0x67/0x120
Apr 16 18:40:48 soho kernel: [<c1104d69>] ? vfs_read+0x149/0x160
Apr 16 18:40:48 soho kernel: [<c110606b>] ? fget_light+0x6b/0xc0
Apr 16 18:40:48 soho kernel: [<c1104dd4>] ? sys_read+0x54/0x70
Apr 16 18:40:48 soho kernel: [<c1027540>] ? do_page_fault+0x0/0x430
Apr 16 18:40:48 soho kernel: [<c131ad5b>] error_code+0x67/0x6c
Apr 16 18:47:12 soho -- MARK --
Apr 16 18:54:31 soho kernel: gnome-settings-[4003]: segfault at b45fd160
ip b45fd160 sp bfbc69fc error 4 in libdbus-1.so.3.5.3[b465e000+3b000]
Apr 16 18:54:31 soho shutdown[14469]: shutting down for system reboot

$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux soho 2.6.38-ARCH #1 SMP PREEMPT Wed Mar 30 07:14:27 UTC 2011 i686
AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD GNU/Linux
 
Gnu C                  4.6.0
Gnu make               3.82
binutils               2.21.0.20110326
util-linux             2.19
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.14
jfsutils               1.1.14
reiserfsprogs          3.6.21
xfsprogs               3.1.5
pcmciautils            017
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Linux C++ Library      6.0.16
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.11
wireless-tools         29
Modules Loaded         cpufreq_ondemand ext2 xfs exportfs reiserfs xts
gf128mul dm_crypt dm_mod ide_pci_generic pata_acpi snd_hda_codec_realtek
nvidia snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device ata_generic btrfs zlib_deflate crc32c snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc
libcrc32c loop joydev kvm_amd amd74xx ide_core kvm sr_mod cdrom fan
evdev agpgart i2c_nforce2 i2c_core aes_i586 thermal button aes_generic
powernow_k8 freq_table mperf fuse psmouse sg k8temp processor dcdbas
serio_raw forcedeth ext4 mbcache jbd2 crc16 usbhid hid ohci_hcd ehci_hcd
usbcore sd_mod sata_nv ahci libahci libata scsi_mod

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
3dnowprefetch lbrv
bogomips	: 2009.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
3dnowprefetch lbrv
bogomips	: 2009.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

$ cat /proc/modules
cpufreq_ondemand 7119 1 - Live 0xfb6e8000
ext2 54539 1 - Live 0xfacf0000
xfs 657734 2 - Live 0xfac27000
exportfs 2971 1 xfs, Live 0xfab4b000
reiserfs 221230 1 - Live 0xfaa4e000
xts 1897 4 - Live 0xfa9a4000
gf128mul 5694 1 xts, Live 0xfa999000
dm_crypt 12887 2 - Live 0xfa969000
dm_mod 55464 5 dm_crypt, Live 0xfa94b000
ide_pci_generic 2100 0 - Live 0xfa92c000
pata_acpi 2292 0 - Live 0xfa922000
snd_hda_codec_realtek 223389 1 - Live 0xfa87f000
nvidia 9593002 30 - Live 0xf9aa0000 (P)
snd_seq_dummy 1095 0 - Live 0xfa77a000
snd_seq_oss 24256 0 - Live 0xfa769000
snd_seq_midi_event 4416 1 snd_seq_oss, Live 0xfa757000
snd_seq 40160 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live
0xfa741000
snd_seq_device 4220 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xfa729000
ata_generic 2455 0 - Live 0xfa71e000
btrfs 492278 1 - Live 0xfa689000
zlib_deflate 17878 1 btrfs, Live 0xfa5ea000
crc32c 2332 1 - Live 0xfa5dd000
snd_hda_intel 18909 2 - Live 0xfa5cd000
snd_hda_codec 64013 2 snd_hda_codec_realtek,snd_hda_intel, Live
0xfa5a8000
snd_hwdep 4719 1 snd_hda_codec, Live 0xfa588000
snd_pcm 58607 2 snd_hda_intel,snd_hda_codec, Live 0xfa56b000
snd_timer 15182 2 snd_seq,snd_pcm, Live 0xfa54a000
snd 42019 13
snd_hda_codec_realtek,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, Live 0xfa52d000
soundcore 4858 1 snd, Live 0xfa514000
snd_page_alloc 5805 2 snd_hda_intel,snd_pcm, Live 0xfa508000
libcrc32c 714 1 btrfs, Live 0xfa4fd000
loop 13767 2 - Live 0xfa4f0000
joydev 7343 0 - Live 0xfa4e1000
kvm_amd 43183 0 - Live 0xfa4c9000
amd74xx 3928 0 - Live 0xfa3d3000
ide_core 76500 2 ide_pci_generic,amd74xx, Live 0xf9a82000
kvm 273982 1 kvm_amd, Live 0xf8fc6000
sr_mod 12668 0 - Live 0xf8f60000
cdrom 30893 1 sr_mod, Live 0xf8f4b000
fan 1838 0 - Live 0xf8f38000
evdev 7086 5 - Live 0xf8f2d000
agpgart 21392 1 nvidia, Live 0xf8f1a000
i2c_nforce2 4328 0 - Live 0xf8f08000
i2c_core 15688 2 nvidia,i2c_nforce2, Live 0xf8eeb000
aes_i586 6908 8 - Live 0xf8efc000
thermal 6403 0 - Live 0xf8eda000
button 3858 0 - Live 0xf8ec3000
aes_generic 25638 1 aes_i586, Live 0xf8eb2000
powernow_k8 12045 1 - Live 0xf8ea0000
freq_table 2015 2 cpufreq_ondemand,powernow_k8, Live 0xf8e93000
mperf 995 1 powernow_k8, Live 0xf8e89000
fuse 56745 9 - Live 0xf8e6f000
psmouse 54703 0 - Live 0xf8e41000
sg 20662 0 - Live 0xf8e1d000
k8temp 2583 0 - Live 0xf8e0c000
processor 21396 1 powernow_k8, Live 0xf8dfb000
dcdbas 4148 0 - Live 0xf8de8000
serio_raw 3358 0 - Live 0xf8ddd000
forcedeth 46645 0 - Live 0xf8dc3000
ext4 304408 1 - Live 0xf8d53000
mbcache 4185 2 ext2,ext4, Live 0xf8ce7000
jbd2 58650 1 ext4, Live 0xf8cca000
crc16 1069 1 ext4, Live 0xf8cab000
usbhid 30269 0 - Live 0xf8c2d000
hid 61230 1 usbhid, Live 0xf8c0a000
ohci_hcd 19364 0 - Live 0xf8be2000
ehci_hcd 34917 0 - Live 0xf8bc7000
usbcore 113783 4 usbhid,ohci_hcd,ehci_hcd, Live 0xf8b3a000
sd_mod 24780 10 - Live 0xf8b02000
sata_nv 17524 9 - Live 0xf8ae4000
ahci 17797 0 - Live 0xf8acf000
libahci 15830 1 ahci, Live 0xf8001000
libata 150313 5 pata_acpi,ata_generic,sata_nv,ahci,libahci, Live
0xf8a9d000
scsi_mod 105492 4 sr_mod,sg,sd_mod,libata, Live 0xf803d000

$ cat /proc/ioports
0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0073 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:06.0
    0170-0177 : amd74xx
  01f0-01f7 : 0000:00:06.0
    01f0-01f7 : amd74xx
  0294-0297 : pnp 00:02
  0376-0376 : 0000:00:06.0
    0376-0376 : amd74xx
03b0-03df : PCI Bus 0000:00
  03c0-03df : vesafb
03e0-0cf7 : PCI Bus 0000:00
  03f6-03f6 : 0000:00:06.0
    03f6-03f6 : amd74xx
  04d0-04d1 : pnp 00:02
  0800-087f : pnp 00:02
  0960-0967 : 0000:00:08.1
    0960-0967 : sata_nv
  0970-0977 : 0000:00:08.0
    0970-0977 : sata_nv
  09e0-09e7 : 0000:00:08.1
    09e0-09e7 : sata_nv
  09f0-09f7 : 0000:00:08.0
    09f0-09f7 : sata_nv
  0b60-0b63 : 0000:00:08.1
    0b60-0b63 : sata_nv
  0b70-0b73 : 0000:00:08.0
    0b70-0b73 : sata_nv
  0be0-0be3 : 0000:00:08.1
    0be0-0be3 : sata_nv
  0bf0-0bf3 : 0000:00:08.0
    0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
1000-107f : pnp 00:01
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  101c-101c : ACPI PM2_CNT_BLK
  1020-1027 : ACPI GPE0_BLK
1080-10ff : pnp 00:01
1400-147f : pnp 00:01
1480-14ff : pnp 00:01
  14a0-14af : ACPI GPE1_BLK
1800-187f : pnp 00:01
1880-18ff : pnp 00:01
1c00-1c7f : PCI Bus 0000:00
  1c00-1c3f : 0000:00:01.1
    1c00-1c3f : nForce2_smbus
  1c40-1c7f : 0000:00:01.1
    1c40-1c7f : nForce2_smbus
9000-ffff : PCI Bus 0000:00
  9000-9fff : PCI Bus 0000:03
  a000-afff : PCI Bus 0000:02
    ac00-ac7f : 0000:02:00.0
  b000-bfff : PCI Bus 0000:01
  c400-c40f : 0000:00:08.1
    c400-c40f : sata_nv
  d800-d80f : 0000:00:08.0
    d800-d80f : sata_nv
  ec00-ec07 : 0000:00:07.0
    ec00-ec07 : forcedeth
  f000-f00f : 0000:00:06.0
    f000-f00f : amd74xx
  fc00-fc3f : 0000:00:01.1
$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000ccdff : Video ROM
000cce00-000cffff : pnp 00:09
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bfedffff : System RAM
  01000000-0131b86a : Kernel code
  0131b86b-014569ff : Kernel data
  014c5000-015a9fff : Kernel bss
bfee0000-bfee2fff : ACPI Non-volatile Storage
bfee3000-bfeeffff : ACPI Tables
bfef0000-bfefffff : reserved
bff00000-bfffffff : RAM buffer
c0000000-efffffff : PCI Bus 0000:00
  e0000000-efffffff : PCI Bus 0000:02
    e0000000-efffffff : 0000:02:00.0
f0000000-f3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f0000000-f3ffffff : reserved
    f0000000-f3ffffff : pnp 00:08
f4000000-fe02ffff : PCI Bus 0000:00
  f8000000-fbffffff : PCI Bus 0000:02
    f8000000-f9ffffff : 0000:02:00.0
      f9000000-f9dfffff : vesafb
    fa000000-faffffff : 0000:02:00.0
      fa000000-faffffff : nvidia
    fbfe0000-fbffffff : 0000:02:00.0
  fdb00000-fdbfffff : PCI Bus 0000:03
  fdc00000-fdcfffff : PCI Bus 0000:03
  fdd00000-fddfffff : PCI Bus 0000:01
  fde00000-fdefffff : PCI Bus 0000:01
  fe024000-fe027fff : 0000:00:05.0
    fe024000-fe027fff : ICH HD audio
  fe02b000-fe02bfff : 0000:00:08.1
    fe02b000-fe02bfff : sata_nv
  fe02c000-fe02cfff : 0000:00:08.0
    fe02c000-fe02cfff : sata_nv
  fe02d000-fe02dfff : 0000:00:07.0
    fe02d000-fe02dfff : forcedeth
  fe02e000-fe02e0ff : 0000:00:02.1
    fe02e000-fe02e0ff : ehci_hcd
  fe02f000-fe02ffff : 0000:00:02.0
    fe02f000-fe02ffff : ohci_hcd
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fee00000-feefffff : pnp 00:09
    fee00000-fee00fff : Local APIC
  fefff000-fefff3ff : HPET 0
    fefff000-fefff0ff : pnp 00:09
  fff80000-fff80fff : pnp 00:09
  fff90000-fffbffff : pnp 00:09
  fffed000-fffeffff : pnp 00:09
  ffff0000-ffffffff : pnp 00:09

# lspci -vvv
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
	Subsystem: Dell Inspiron 531
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=17 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at fc00 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
	Subsystem: Dell Inspiron 531
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-

00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
(prog-if 10 [OHCI])
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
(prog-if 20 [EHCI])
	Subsystem: Dell Inspiron 531
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 23
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: fdd00000-fddfffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Dell Inspiron 531
	Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000

00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio
(rev a2)
	Subsystem: Dell Inspiron 531
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at fe024000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2) (prog-if 8a
[Master SecP PriP])
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: AMD_IDE
	Kernel modules: pata_amd, amd74xx

00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at ec00 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
		Address: 00000000fee0300c  Data: 4171
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
(prog-if 85 [Master SecO PriO])
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at d800 [size=16]
	Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: sata_nv

00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
(prog-if 85 [Master SecO PriO])
	Subsystem: Dell Inspiron 531
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at 09e0 [size=8]
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: sata_nv

00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f8000000-fbffffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Dell Inspiron 531
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4129
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fdc00000-fdcfffff
	Prefetchable memory behind bridge: 00000000fdb00000-00000000fdbfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Dell Inspiron 531
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4141
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave-
<EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS-
UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp

02:00.0 VGA compatible controller: nVidia Corporation G86 [GeForce 8300
GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: nVidia Corporation Device 0494
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ac00 [size=128]
	[virtual] Expansion ROM at fbfe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM unknown, Latency L0
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1
Len=024 <?>
	Kernel driver in use: nvidia
	Kernel modules: nouveau, nvidia, nvidiafb




