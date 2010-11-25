Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0KYGTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:19:24 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:45079 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0KYGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:19:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: 2.6.37-rc3-mmotm1123 -  arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290665937_5841P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Nov 2010 01:18:57 -0500
Message-ID: <6340.1290665937@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4CEDFFD2.0042,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290665937_5841P
Content-Type: text/plain; charset=us-ascii

(Appears to have been present in -rc2-mmotm1117 as well, and maybe earlier. I
suspect mcelog wasn't getting run at boot due to my fighting with systemd, so I
didn't see it).

[  146.195836] ===================================================
[  146.195839] [ INFO: suspicious rcu_dereference_check() usage. ]
[  146.195841] ---------------------------------------------------
[  146.195844] arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!
[  146.195847] 
[  146.195847] other info that might help us debug this:
[  146.195848] 
[  146.195850] 
[  146.195850] rcu_scheduler_active = 1, debug_locks = 1
[  146.195853] no locks held by mcelog/3806.
[  146.195855] 
[  146.195855] stack backtrace:
[  146.195858] Pid: 3806, comm: mcelog Tainted: G        W   2.6.37-rc3-mmotm1123 #4
[  146.195860] Call Trace:
[  146.195869]  [<ffffffff81069538>] lockdep_rcu_dereference+0x9d/0xa5
[  146.195875]  [<ffffffff810139ea>] mce_poll+0x66/0x74
[  146.195880]  [<ffffffff8110a62e>] do_sys_poll+0x23b/0x3a5
[  146.195885]  [<ffffffff811095ad>] ? __pollwait+0x0/0xc7
[  146.195889]  [<ffffffff81109674>] ? pollwake+0x0/0x4f
[  146.195893]  [<ffffffff81109674>] ? pollwake+0x0/0x4f
[  146.195898]  [<ffffffff81094c0e>] ? __rcu_read_unlock+0x28f/0x2ab
[  146.195903]  [<ffffffff810d565f>] ? __do_fault+0x256/0x3e5
[  146.195908]  [<ffffffff81068775>] ? look_up_lock_class+0x5f/0xc4
[  146.195912]  [<ffffffff810d565f>] ? __do_fault+0x256/0x3e5
[  146.195916]  [<ffffffff81068c42>] ? register_lock_class+0x1e/0x2d3
[  146.195921]  [<ffffffff810a5c05>] ? trace_preempt_on+0x15/0x28
[  146.195925]  [<ffffffff810d5755>] ? __do_fault+0x34c/0x3e5
[  146.195931]  [<ffffffff8155adbc>] ? _raw_spin_unlock+0x30/0x69
[  146.195935]  [<ffffffff8106a45e>] ? mark_lock+0x2d/0x1d8
[  146.195940]  [<ffffffff810ba69c>] ? unlock_page+0x25/0x2a
[  146.195944]  [<ffffffff8106ab57>] ? __lock_acquire+0x54e/0xd4e
[  146.195948]  [<ffffffff810d790d>] ? handle_mm_fault+0x193/0x7c3
[  146.195953]  [<ffffffff8104acaa>] ? sigprocmask+0x2f/0xc5
[  146.195957]  [<ffffffff8104acaa>] ? sigprocmask+0x2f/0xc5
[  146.195962]  [<ffffffff810d4cc0>] ? might_fault+0x4e/0x9e
[  146.195966]  [<ffffffff8155aea0>] ? _raw_spin_unlock_irq+0x2b/0x70
[  146.195970]  [<ffffffff810a5c05>] ? trace_preempt_on+0x15/0x28
[  146.195974]  [<ffffffff8104ad35>] ? sigprocmask+0xba/0xc5
[  146.195978]  [<ffffffff8155aeab>] ? _raw_spin_unlock_irq+0x36/0x70
[  146.195983]  [<ffffffff8155e378>] ? sub_preempt_count+0x35/0x49
[  146.195987]  [<ffffffff8155aed7>] ? _raw_spin_unlock_irq+0x62/0x70
[  146.195992]  [<ffffffff8110a973>] sys_ppoll+0xd3/0x13c
[  146.195996]  [<ffffffff8106bc89>] ? trace_hardirqs_on_caller+0x117/0x13b
[  146.196087]  [<ffffffff8155a60b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  146.196094]  [<ffffffff8100277b>] system_call_fastpath+0x16/0x1b


--==_Exmh_1290665937_5841P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7f/RcC3lWbTT17ARAn6hAKDFEqg/P7PKylbOLNW+4Jv7XW1lAgCgw21w
Kg8qI9Z5/LWppEtz3JZivJw=
=W/Xg
-----END PGP SIGNATURE-----

--==_Exmh_1290665937_5841P--

