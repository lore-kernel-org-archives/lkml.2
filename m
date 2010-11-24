Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab0KXFCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:02:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36672 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0KXFB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:01:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: mmotm 2010-11-23 + autogroups -> inconsistent lock state
In-Reply-To: Your message of "Tue, 23 Nov 2010 16:13:06 PST."
             <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290574869_5261P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Nov 2010 00:01:09 -0500
Message-ID: <6003.1290574869@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4CEC9C16.021E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290574869_5261P
Content-Type: text/plain; charset=us-ascii

On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

(I appear to be on a roll tonight - 3 splats before I even had a chance to login. :)

mmotm + Ingo's cleanup of Mike's autogroups patch.

[  114.569222] =================================
[  114.578171] [ INFO: inconsistent lock state ]
[  114.578171] 2.6.37-rc3-mmotm1123 #3
[  114.578171] ---------------------------------
[  114.578171] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  114.578171] kworker/0:0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  114.578171]  (&(&sighand->siglock)->rlock){?.+...}, at: [<ffffffff8104bfb1>] __lock_task_sighand+0x88/0xd6
[  114.578171] {HARDIRQ-ON-W} state was registered at:
[  114.578171]   [<ffffffff8106a9a9>] __lock_acquire+0x358/0xd4e
[  114.578171]   [<ffffffff8106b8b1>] lock_acquire+0x100/0x126
[  114.578171]   [<ffffffff8155a849>] _raw_spin_lock+0x36/0x45
[  114.578171]   [<ffffffff81030bc6>] sched_autogroup_fork+0x30/0x61
[  114.578171]   [<ffffffff8103995a>] copy_process+0x994/0x1325
[  114.578171]   [<ffffffff8103a4ca>] do_fork+0x1ae/0x3e3
[  114.578171]   [<ffffffff81009603>] kernel_thread+0x6b/0x6d
[  114.578171]   [<ffffffff8105832e>] kthreadd+0xdd/0x11f
[  114.578171]   [<ffffffff810035d4>] kernel_thread_helper+0x4/0x10
[  114.578171] irq event stamp: 1137212
[  114.578171] hardirqs last  enabled at (1137209): [<ffffffff8155ae6f>] _raw_spin_unlock_irqrestore+0x3a/0x80
[  114.578171] hardirqs last disabled at (1137210): [<ffffffff8155b467>] save_args+0x67/0x70
[  114.578171] softirqs last  enabled at (1137212): [<ffffffff810414f3>] _local_bh_enable+0xe/0x10
[  114.578171] softirqs last disabled at (1137211): [<ffffffff81041edd>] irq_enter+0x3d/0x6f
[  114.578171] 
[  114.578171] other info that might help us debug this:
[  114.578171] 3 locks held by kworker/0:0/0:
[  114.578171]  #0:  (&(&new_timer->it_lock)->rlock){-.....}, at: [<ffffffff81056e7b>] posix_timer_fn+0x24/0xc7
[  114.578171]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81056d77>] rcu_read_lock+0x0/0x35
[  114.578171]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff8104a6e6>] rcu_read_lock+0x0/0x35
[  114.578171] 
[  114.578171] stack backtrace:
[  114.578171] Pid: 0, comm: kworker/0:0 Tainted: G        W   2.6.37-rc3-mmotm1123 #3
[  114.578171] Call Trace:
[  114.578171]  <IRQ>  [<ffffffff8106a467>] valid_state+0x17c/0x18e
[  114.578171]  [<ffffffff81069d2c>] ? check_usage_forwards+0x0/0x87
[  114.578171]  [<ffffffff8106a558>] mark_lock+0xdf/0x1d8
[  114.578171]  [<ffffffff81069d2c>] ? check_usage_forwards+0x0/0x87
[  114.578171]  [<ffffffff8106a928>] __lock_acquire+0x2d7/0xd4e
[  114.578171]  [<ffffffff8106a4a6>] ? mark_lock+0x2d/0x1d8
[  114.578171]  [<ffffffff8104bfb1>] ? __lock_task_sighand+0x88/0xd6
[  114.578171]  [<ffffffff8106b8b1>] lock_acquire+0x100/0x126
[  114.578171]  [<ffffffff8104bfb1>] ? __lock_task_sighand+0x88/0xd6
[  114.578171]  [<ffffffff8155a942>] _raw_spin_lock_irqsave+0x44/0x57
[  114.578171]  [<ffffffff8104bfb1>] ? __lock_task_sighand+0x88/0xd6
[  114.578171]  [<ffffffff8104bfb1>] __lock_task_sighand+0x88/0xd6
[  114.578171]  [<ffffffff8104c6b3>] send_sigqueue+0x51/0x162
[  114.578171]  [<ffffffff81056e42>] posix_timer_event+0x3f/0x54
[  114.578171]  [<ffffffff81056ea1>] posix_timer_fn+0x4a/0xc7
[  114.578171]  [<ffffffff812294fd>] ? do_raw_spin_unlock+0xd0/0xfa
[  114.578171]  [<ffffffff8105bb7e>] __run_hrtimer+0x13e/0x27a
[  114.578171]  [<ffffffff81056e57>] ? posix_timer_fn+0x0/0xc7
[  114.578171]  [<ffffffff8105c5f3>] hrtimer_interrupt+0xea/0x1d6
[  114.578171]  [<ffffffff8101ad4f>] smp_apic_timer_interrupt+0x74/0x87
[  114.578171]  [<ffffffff81003193>] apic_timer_interrupt+0x13/0x20
[  114.578171]  <EOI>  [<ffffffff81000cf5>] ? cpu_idle+0x42/0x14e
[  114.578171]  [<ffffffff81000dd5>] ? cpu_idle+0x122/0x14e
[  114.578171]  [<ffffffff81b57170>] start_secondary+0x1a9/0x1ad
~                                                                    

--==_Exmh_1290574869_5261P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7JwVcC3lWbTT17ARAolRAJ42GnZ8ckvf89KJMQLAj0gnqCLdtACffLdt
5DRVKj6W+Gs0O1jhgM/xBfA=
=qg7J
-----END PGP SIGNATURE-----

--==_Exmh_1290574869_5261P--

