Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1KRKUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:20:47 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:42686 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1KRKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:20:45 -0500
Message-ID: <4EC63170.9020204@t-online.de>
Date: Fri, 18 Nov 2011 11:20:32 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [BUG] 3.1.0 possible recursive locking detected
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: TFtY+2ZeYhLTXJege3kRWVKEpcy+hM4bmy2zrRdjfhj6E1upnLP6eMByCdQ4v2Ggd-
X-TOI-MSGID: 0c9939f6-57b1-42f7-915a-d0a1868cb06d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two other locking problems:
======================

Nov 17 18:35:01 linux-iffr kernel: [10382.580318]
Nov 17 18:35:01 linux-iffr kernel: [10382.580322] =============================================
Nov 17 18:35:01 linux-iffr kernel: [10382.580359] [ INFO: possible recursive locking detected ]
Nov 17 18:35:01 linux-iffr kernel: [10382.580379] 3.1.0-main+ #26
Nov 17 18:35:01 linux-iffr kernel: [10382.580392] ---------------------------------------------
Nov 17 18:35:01 linux-iffr kernel: [10382.580411] rpm/14406 is trying to acquire lock:
Nov 17 18:35:01 linux-iffr kernel: [10382.580429]  (&(&parent->list_lock)->rlock){-.-...}, at: [<c018fe75>] cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.580472]
Nov 17 18:35:01 linux-iffr kernel: [10382.580474] but task is already holding lock:
Nov 17 18:35:01 linux-iffr kernel: [10382.580497]  (&(&parent->list_lock)->rlock){-.-...}, at: [<c018fe75>] cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.580533]
Nov 17 18:35:01 linux-iffr kernel: [10382.580535] other info that might help us debug this:
Nov 17 18:35:01 linux-iffr kernel: [10382.580559]  Possible unsafe locking scenario:
Nov 17 18:35:01 linux-iffr kernel: [10382.580561]
Nov 17 18:35:01 linux-iffr kernel: [10382.580582]        CPU0
Nov 17 18:35:01 linux-iffr kernel: [10382.580594]        ----
Nov 17 18:35:01 linux-iffr kernel: [10382.580606]   lock(&(&parent->list_lock)->rlock);
Nov 17 18:35:01 linux-iffr kernel: [10382.580628]   lock(&(&parent->list_lock)->rlock);
Nov 17 18:35:01 linux-iffr kernel: [10382.580649]
Nov 17 18:35:01 linux-iffr kernel: [10382.580651]  *** DEADLOCK ***
Nov 17 18:35:01 linux-iffr kernel: [10382.580653]
Nov 17 18:35:01 linux-iffr kernel: [10382.580678]  May be due to missing lock nesting notation
Nov 17 18:35:01 linux-iffr kernel: [10382.580681]
Nov 17 18:35:01 linux-iffr kernel: [10382.580705] 6 locks held by rpm/14406:
Nov 17 18:35:01 linux-iffr kernel: [10382.580720]  #0:  (&sb->s_type->i_mutex_key#12/1){+.+.+.}, at: [<c019ae09>] lock_rename+0x20/0x8f
Nov 17 18:35:01 linux-iffr kernel: [10382.580766]  #1:  (&journal->j_mutex){+.+...}, at: [<c01f4e3e>] do_journal_end+0xac/0xaf3
Nov 17 18:35:01 linux-iffr kernel: [10382.580806]  #2:  (&journal->j_flush_mutex){+.+...}, at: [<c01f2d7c>] flush_journal_list+0x77/0x52d
Nov 17 18:35:01 linux-iffr kernel: [10382.580845]  #3:  (&jl->j_commit_mutex){+.+...}, at: [<c01f297f>] flush_commit_list+0xfb/0x481
Nov 17 18:35:01 linux-iffr kernel: [10382.580883]  #4:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c01f85fc>] reiserfs_write_lock+0x20/0x2a
Nov 17 18:35:01 linux-iffr kernel: [10382.580921]  #5:  (&(&parent->list_lock)->rlock){-.-...}, at: [<c018fe75>] cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.580960]
Nov 17 18:35:01 linux-iffr kernel: [10382.580962] stack backtrace:
Nov 17 18:35:01 linux-iffr kernel: [10382.580985] Pid: 14406, comm: rpm Not tainted 3.1.0-main+ #26
Nov 17 18:35:01 linux-iffr kernel: [10382.581004] Call Trace:
Nov 17 18:35:01 linux-iffr kernel: [10382.581025]  [<c0434974>] ? printk+0xf/0x13
Nov 17 18:35:01 linux-iffr kernel: [10382.581050]  [<c01497d4>] __lock_acquire+0x13f0/0x1472
Nov 17 18:35:01 linux-iffr kernel: [10382.581076]  [<c0147c6a>] ? check_irq_usage+0x99/0xac
Nov 17 18:35:01 linux-iffr kernel: [10382.581099]  [<c0146992>] ? trace_hardirqs_off+0xb/0xd
Nov 17 18:35:01 linux-iffr kernel: [10382.581122]  [<c0149c32>] lock_acquire+0x47/0x5e
Nov 17 18:35:01 linux-iffr kernel: [10382.581144]  [<c018fe75>] ? cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.581169]  [<c0436f40>] _raw_spin_lock+0x25/0x34
Nov 17 18:35:01 linux-iffr kernel: [10382.581191]  [<c018fe75>] ? cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.581214]  [<c018fe75>] cache_flusharray+0x21/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.581237]  [<c018ffb5>] kmem_cache_free+0x3a/0x66
Nov 17 18:35:01 linux-iffr kernel: [10382.581259]  [<c019001f>] slab_destroy+0x3e/0x42
Nov 17 18:35:01 linux-iffr kernel: [10382.581280]  [<c01900d0>] free_block+0xad/0xe6
Nov 17 18:35:01 linux-iffr kernel: [10382.581302]  [<c018feb4>] cache_flusharray+0x60/0x88
Nov 17 18:35:01 linux-iffr kernel: [10382.581325]  [<c018ff4f>] kfree+0x73/0x9f
Nov 17 18:35:01 linux-iffr kernel: [10382.581346]  [<c01f1d1a>] cleanup_bitmap_list+0x4a/0xb1
Nov 17 18:35:01 linux-iffr kernel: [10382.581370]  [<c01f2c07>] flush_commit_list+0x383/0x481
Nov 17 18:35:01 linux-iffr kernel: [10382.581405]  [<c01f2ea0>] flush_journal_list+0x19b/0x52d
Nov 17 18:35:01 linux-iffr kernel: [10382.581429]  [<c012de75>] ? mod_timer+0x121/0x135
Nov 17 18:35:01 linux-iffr kernel: [10382.581453]  [<c01f32ee>] flush_used_journal_lists+0xbc/0xc6
Nov 17 18:35:01 linux-iffr kernel: [10382.581478]  [<c01f559f>] do_journal_end+0x80d/0xaf3
Nov 17 18:35:01 linux-iffr kernel: [10382.581503]  [<c01f5a56>] do_journal_begin_r+0x1d1/0x247
Nov 17 18:35:01 linux-iffr kernel: [10382.581528]  [<c01f5b74>] journal_begin+0xa8/0xdb
Nov 17 18:35:01 linux-iffr kernel: [10382.581551]  [<c01f07ca>] reiserfs_do_truncate+0x3c1/0x446
Nov 17 18:35:01 linux-iffr kernel: [10382.581579]  [<c01f0878>] reiserfs_delete_object+0x29/0x60
Nov 17 18:35:01 linux-iffr kernel: [10382.581605]  [<c01dfbd1>] reiserfs_evict_inode+0xab/0x115
Nov 17 18:35:01 linux-iffr kernel: [10382.581631]  [<c01a4f27>] evict+0x85/0x126
Nov 17 18:35:01 linux-iffr kernel: [10382.581651]  [<c01a5109>] iput+0x141/0x146
Nov 17 18:35:01 linux-iffr kernel: [10382.581671]  [<c01a26cf>] d_kill+0xc9/0xe2
Nov 17 18:35:01 linux-iffr kernel: [10382.581691]  [<c01a2e29>] dput+0x127/0x132
Nov 17 18:35:01 linux-iffr kernel: [10382.581712]  [<c019e2a6>] sys_renameat+0x197/0x1dc
Nov 17 18:35:01 linux-iffr kernel: [10382.581739]  [<c0196673>] ? sys_lstat64+0x22/0x28
Nov 17 18:35:01 linux-iffr kernel: [10382.581763]  [<c019e2fd>] sys_rename+0x12/0x15
Nov 17 18:35:01 linux-iffr kernel: [10382.581786]  [<c043b10c>] sysenter_do_call+0x12/0x32




Nov 18 11:01:53 linux-iffr avahi-daemon[630]: Found user 'avahi' (UID 103) and group 'avahi' (GID 106).
Nov 18 11:01:53 linux-iffr avahi-daemon[630]: Successfully dropped root privileges.
Nov 18 11:01:53 linux-iffr avahi-daemon[630]: avahi-daemon 0.6.30 starting up.
Nov 18 11:01:53 linux-iffr auditd[659]: Started dispatcher: /sbin/audispd pid: 661
Nov 18 11:01:54 linux-iffr auditd[659]: Init complete, auditd 2.1.1 listening for events (startup state disable)
Nov 18 11:01:54 linux-iffr audispd: priority_boost_parser called with: 4
Nov 18 11:01:54 linux-iffr audispd: max_restarts_parser called with: 10
Nov 18 11:01:54 linux-iffr audispd: No plugins found, exiting
Nov 18 11:01:54 linux-iffr kernel: [   70.474167] ip6_tables: (C) 2000-2006 Netfilter Core Team
Nov 18 11:01:54 linux-iffr kernel: [   70.908318] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Nov 18 11:01:55 linux-iffr kernel: [   71.030405]
Nov 18 11:01:55 linux-iffr kernel: [   71.030409] =============================================
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] [ INFO: possible recursive locking detected ]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] 3.1.0-main+ #26
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] ---------------------------------------------
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] systemd-logind/585 is trying to acquire lock:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  (&ep->mtx){+.+.+.}, at: [<c01bc5f4>] ep_scan_ready_list+0x2d/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] but task is already holding lock:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  (&ep->mtx){+.+.+.}, at: [<c01bca67>] sys_epoll_ctl+0xfc/0x48f
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] other info that might help us debug this:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  Possible unsafe locking scenario:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]        CPU0
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]        ----
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]   lock(&ep->mtx);
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]   lock(&ep->mtx);
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  *** DEADLOCK ***
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  May be due to missing lock nesting notation
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] 2 locks held by systemd-logind/585:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  #0:  (epmutex){+.+.+.}, at: [<c01bca25>] sys_epoll_ctl+0xba/0x48f
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  #1:  (&ep->mtx){+.+.+.}, at: [<c01bca67>] sys_epoll_ctl+0xfc/0x48f
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] stack backtrace:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] Pid: 585, comm: systemd-logind Not tainted 3.1.0-main+ #26
Nov 18 11:01:55 linux-iffr kernel: [   71.032012] Call Trace:
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c0434974>] ? printk+0xf/0x13
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01497d4>] __lock_acquire+0x13f0/0x1472
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c014965a>] ? __lock_acquire+0x1276/0x1472
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c014965a>] ? __lock_acquire+0x1276/0x1472
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c0149c32>] lock_acquire+0x47/0x5e
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc5f4>] ? ep_scan_ready_list+0x2d/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc5f4>] ? ep_scan_ready_list+0x2d/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c04360ef>] mutex_lock_nested+0x35/0x26f
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc5f4>] ? ep_scan_ready_list+0x2d/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c014a23d>] ? mark_held_locks+0xae/0xd0
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc5f4>] ep_scan_ready_list+0x2d/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc098>] ? sys_inotify_rm_watch+0x85/0x85
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc727>] ep_poll_readyevents_proc+0xf/0x11
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc3d0>] ep_call_nested.clone.0+0x71/0xab
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc718>] ? ep_scan_ready_list+0x151/0x151
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc4c1>] ep_eventpoll_poll+0x37/0x4a
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bcb6d>] sys_epoll_ctl+0x202/0x48f
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c01bc2f3>] ? ep_remove+0x8c/0x8c
Nov 18 11:01:55 linux-iffr kernel: [   71.032012]  [<c04377d5>] syscall_call+0x7/0xb
Nov 18 11:01:55 linux-iffr systemd-logind[585]: New seat seat0.
Nov 18 11:01:55 linux-iffr avahi-daemon[630]: Loading service file /etc/avahi/services/sftp-ssh.service.
Nov 18 11:01:55 linux-iffr avahi-daemon[630]: Loading service file /etc/avahi/services/ssh.service.
Nov 18 11:01:55 linux-iffr avahi-daemon[630]: Loading service file /etc/avahi/services/udisks.service.


cu,
  Knut
