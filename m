Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab1KWDi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:38:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1KWDiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:38:55 -0500
Date: Tue, 22 Nov 2011 22:38:50 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: tty related lockdep trace during bootup on 3.2-rc2
Message-ID: <20111123033850.GA11380@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Havard Skinnemoen <hskinnemoen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Linus' current tree...

related to 5dc2470c602da8851907ec18942cd876c3b4ecc1 maybe ?

	Dave

[   40.778011] ======================================================
[   40.780010] [ INFO: possible circular locking dependency detected ]
[   40.780010] 3.2.0-rc2+ #8
[   40.780010] -------------------------------------------------------
[   40.780010] modem-manager/1141 is trying to acquire lock:
[   40.780010]  (big_tty_mutex){+.+.+.}, at: [<ffffffff81682807>] tty_lock+0x17/0x19
[   40.780010] 
[   40.780010] but task is already holding lock:
[   40.780010]  (open_mutex){+.+...}, at: [<ffffffffa032b321>] acm_tty_close+0x41/0xc0 [cdc_acm]
[   40.780010] 
[   40.780010] which lock already depends on the new lock.
[   40.780010] 
[   40.780010] 
[   40.780010] the existing dependency chain (in reverse order) is:
[   40.780010] 
[   40.780010] -> #1 (open_mutex){+.+...}:
[   40.780010]        [<ffffffff810c1d9d>] lock_acquire+0x9d/0x210
[   40.780010]        [<ffffffff8168003e>] __mutex_lock_common+0x5e/0x4f0
[   40.780010]        [<ffffffff81680604>] mutex_lock_nested+0x44/0x50
[   40.780010]        [<ffffffffa032b715>] acm_tty_open+0x35/0x230 [cdc_acm]
[   40.780010]        [<ffffffff813c1087>] tty_open+0x247/0x5d0
[   40.780010]        [<ffffffff811b5408>] chrdev_open+0x258/0x350
[   40.780010]        [<ffffffff811ad9a4>] __dentry_open+0x384/0x550
[   40.780010]        [<ffffffff811af194>] nameidata_to_filp+0x74/0x80
[   40.780010]        [<ffffffff811c0b6c>] do_last+0x26c/0x920
[   40.780010]        [<ffffffff811c1335>] path_openat+0xd5/0x3e0
[   40.780010]        [<ffffffff811c1762>] do_filp_open+0x42/0xa0
[   40.780010]        [<ffffffff811af297>] do_sys_open+0xf7/0x1d0
[   40.780010]        [<ffffffff811af390>] sys_open+0x20/0x30
[   40.780010]        [<ffffffff81689f82>] system_call_fastpath+0x16/0x1b
[   40.780010] 
[   40.780010] -> #0 (big_tty_mutex){+.+.+.}:
[   40.780010]        [<ffffffff810c112e>] __lock_acquire+0x16ce/0x1c40
[   40.780010]        [<ffffffff810c1d9d>] lock_acquire+0x9d/0x210
[   40.780010]        [<ffffffff8168003e>] __mutex_lock_common+0x5e/0x4f0
[   40.780010]        [<ffffffff81680604>] mutex_lock_nested+0x44/0x50
[   40.780010]        [<ffffffff81682807>] tty_lock+0x17/0x19
[   40.780010]        [<ffffffff813c91ad>] tty_port_close_start+0x17d/0x210
[   40.780010]        [<ffffffffa032b32f>] acm_tty_close+0x4f/0xc0 [cdc_acm]
[   40.780010]        [<ffffffff813c09e7>] tty_release+0x167/0x5c0
[   40.780010]        [<ffffffff811b252e>] fput+0xfe/0x2d0
[   40.780010]        [<ffffffff811adee9>] filp_close+0x69/0x90
[   40.780010]        [<ffffffff811ae1d0>] sys_close+0xc0/0x1a0
[   40.780010]        [<ffffffff81689f82>] system_call_fastpath+0x16/0x1b
[   40.780010] 
[   40.780010] other info that might help us debug this:
[   40.780010] 
[   40.780010]  Possible unsafe locking scenario:
[   40.780010] 
[   40.780010]        CPU0                    CPU1
[   40.780010]        ----                    ----
[   40.780010]   lock(open_mutex);
[   40.780010]                                lock(big_tty_mutex);
[   40.780010]                                lock(open_mutex);
[   40.780010]   lock(big_tty_mutex);
[   40.780010] 
[   40.780010]  *** DEADLOCK ***
[   40.780010] 
[   40.780010] 1 lock held by modem-manager/1141:
[   40.780010]  #0:  (open_mutex){+.+...}, at: [<ffffffffa032b321>] acm_tty_close+0x41/0xc0 [cdc_acm]
[   40.780010] 
[   40.780010] stack backtrace:
[   40.780010] Pid: 1141, comm: modem-manager Not tainted 3.2.0-rc2+ #8
[   40.780010] Call Trace:
[   40.780010]  [<ffffffff81675378>] print_circular_bug+0x202/0x213
[   40.780010]  [<ffffffff810c112e>] __lock_acquire+0x16ce/0x1c40
[   40.780010]  [<ffffffff81021f62>] ? native_sched_clock+0x22/0x70
[   40.780010]  [<ffffffff810ae2c5>] ? sched_clock_local+0x25/0x90
[   40.780010]  [<ffffffff810c1d9d>] lock_acquire+0x9d/0x210
[   40.780010]  [<ffffffff81682807>] ? tty_lock+0x17/0x19
[   40.780010]  [<ffffffff810c180a>] ? lock_release_non_nested+0x16a/0x350
[   40.780010]  [<ffffffff8168003e>] __mutex_lock_common+0x5e/0x4f0
[   40.780010]  [<ffffffff81682807>] ? tty_lock+0x17/0x19
[   40.780010]  [<ffffffff810c2796>] ? mark_held_locks+0x86/0x150
[   40.780010]  [<ffffffff816807ae>] ? mutex_unlock+0xe/0x10
[   40.780010]  [<ffffffff81682807>] ? tty_lock+0x17/0x19
[   40.780010]  [<ffffffff81680604>] mutex_lock_nested+0x44/0x50
[   40.780010]  [<ffffffff81682807>] tty_lock+0x17/0x19
[   40.780010]  [<ffffffff813c91ad>] tty_port_close_start+0x17d/0x210
[   40.780010]  [<ffffffffa032b32f>] acm_tty_close+0x4f/0xc0 [cdc_acm]
[   40.780010]  [<ffffffff813c09e7>] tty_release+0x167/0x5c0
[   40.780010]  [<ffffffff81021fb9>] ? sched_clock+0x9/0x10
[   40.780010]  [<ffffffff810ae2c5>] ? sched_clock_local+0x25/0x90
[   40.780010]  [<ffffffff811b252e>] fput+0xfe/0x2d0
[   40.780010]  [<ffffffff811adee9>] filp_close+0x69/0x90
[   40.780010]  [<ffffffff811ae1d0>] sys_close+0xc0/0x1a0
[   40.780010]  [<ffffffff81689f82>] system_call_fastpath+0x16/0x1b

