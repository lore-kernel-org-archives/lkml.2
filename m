Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab0HLQUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:20:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35194 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab0HLQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:20:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-08-11 - RCU whinge during very early boot
In-Reply-To: Your message of "Wed, 11 Aug 2010 16:10:49 PDT."
             <201008112340.o7BNenDe021017@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1281629887_8850P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Aug 2010 12:18:07 -0400
Message-ID: <10167.1281629887@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C641EE3.00FA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1281629887_8850P
Content-Type: text/plain; charset=us-ascii

On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Throws a RCU complaint.  Hopefully somebody on the cc: list knows what it is about...

[    0.026136] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a
[    0.028399] NMI watchdog enabled, takes one hw-pmu counter.
[    0.030019] lockdep: fixing up alternatives.
[    0.031178] 
[    0.031179] ===================================================
[    0.031182] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.031184] ---------------------------------------------------
[    0.031187] kernel/sched.c:618 invoked rcu_dereference_check() without protection!
[    0.031189] 
[    0.031189] other info that might help us debug this:
[    0.031190] 
[    0.031192] 
[    0.031193] rcu_scheduler_active = 1, debug_locks = 1
[    0.031195] 3 locks held by kworker/0:0/4:
[    0.031197]  #0:  (events){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
[    0.031210]  #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
[    0.031217]  #2:  (&rq->lock){-.-...}, at: [<ffffffff81b5f9b8>] init_idle+0x2b/0x114
[    0.031225] 
[    0.031226] stack backtrace:
[    0.031229] Pid: 4, comm: kworker/0:0 Not tainted 2.6.35-mmotm0811 #1
[    0.031232] Call Trace:
[    0.031237]  [<ffffffff810661eb>] lockdep_rcu_dereference+0x9d/0xa5
[    0.031242]  [<ffffffff8102b751>] task_group+0x7b/0x8a
[    0.031246]  [<ffffffff81b5f9b8>] ? init_idle+0x2b/0x114
[    0.031250]  [<ffffffff8102b775>] set_task_rq+0x15/0x6e
[    0.031253]  [<ffffffff81b5fa5e>] init_idle+0xd1/0x114
[    0.031257]  [<ffffffff81b5fb44>] fork_idle+0x8e/0x9d
[    0.031261]  [<ffffffff81b5de6f>] do_fork_idle+0x17/0x28
[    0.031265]  [<ffffffff8105052b>] process_one_work+0x217/0x37d
[    0.031269]  [<ffffffff810504ca>] ? process_one_work+0x1b6/0x37d
[    0.031273]  [<ffffffff81b5de58>] ? do_fork_idle+0x0/0x28
[    0.031277]  [<ffffffff81051775>] worker_thread+0x17e/0x251
[    0.031281]  [<ffffffff810515f7>] ? worker_thread+0x0/0x251
[    0.031285]  [<ffffffff8105544a>] kthread+0x7d/0x85
[    0.031290]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[    0.031295]  [<ffffffff81558d80>] ? restore_args+0x0/0x30
[    0.031299]  [<ffffffff810553cd>] ? kthread+0x0/0x85
[    0.031303]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
[    0.031333] Booting Node   0, Processors  #1 Ok.
[    0.103111] NMI watchdog enabled, takes one hw-pmu counter.
[    0.104013] Brought up 2 CPUs


--==_Exmh_1281629887_8850P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMZB6/cC3lWbTT17ARAjekAJ4yM0pB2kH725CnZUgVmPZhJtkNtQCg+cpa
yDelc9uCU2a9I3Etmsdck2Q=
=1wJe
-----END PGP SIGNATURE-----

--==_Exmh_1281629887_8850P--

