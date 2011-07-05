Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1GEWTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:19:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52585 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1GEWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:19:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: 3.0.0-rc5-mmotm0630 - rcu_update whinge in cpu_idle
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309904282_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 18:18:02 -0400
Message-ID: <61640.1309904282@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E138D9C.0060,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309904282_18528P
Content-Type: text/plain; charset=us-ascii

(Sorry if this is already reported, I'm back from 10 days off and am about 8,423 mails
behind on lkml ;)

Seen at boot of 3.0.0-rc5-mmotm0630:

[    0.411716] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.411716] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.411716] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.417076] Switching to clocksource hpet
[    0.417601] Warning: could not register annotated branches stats
[    0.417925] Switched to NOHz mode on CPU #1
[    0.417966] ------------[ cut here ]------------
[    0.417973] WARNING: at include/linux/rcupdate.h:256 rcu_lock_acquire+0x6a/0xc5()
[    0.417976] Hardware name: Latitude E6500                  
[    0.417978] Modules linked in:
[    0.417983] Pid: 0, comm: kworker/0:0 Not tainted 3.0.0-rc5-mmotm0630 #1
[    0.417985] Call Trace:
[    0.417991]  [<ffffffff810383f6>] warn_slowpath_common+0x7e/0x96
[    0.417995]  [<ffffffff81038423>] warn_slowpath_null+0x15/0x17
[    0.417999]  [<ffffffff8105c062>] rcu_lock_acquire+0x6a/0xc5
[    0.418005]  [<ffffffff8158e6c4>] __atomic_notifier_call_chain+0x2c/0x62
[    0.418009]  [<ffffffff8158e709>] atomic_notifier_call_chain+0xf/0x11
[    0.418014]  [<ffffffff81000771>] enter_idle+0x20/0x22
[    0.418018]  [<ffffffff81000821>] cpu_idle+0x73/0xf9
[    0.418024]  [<ffffffff81b6b7ca>] start_secondary+0x9a/0x9c
[    0.418068] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.418070] ------------[ cut here ]------------
[    0.418074] WARNING: at include/linux/rcupdate.h:262 rcu_lock_release+0x66/0xb1()
[    0.418077] Hardware name: Latitude E6500                  
[    0.418079] Modules linked in:
[    0.418083] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.0.0-rc5-mmotm0630 #1
[    0.418085] Call Trace:
[    0.418089]  [<ffffffff810383f6>] warn_slowpath_common+0x7e/0x96
[    0.418093]  [<ffffffff81038423>] warn_slowpath_null+0x15/0x17
[    0.418097]  [<ffffffff8105c123>] rcu_lock_release+0x66/0xb1
[    0.418102]  [<ffffffff8158e6eb>] __atomic_notifier_call_chain+0x53/0x62
[    0.418106]  [<ffffffff8158e709>] atomic_notifier_call_chain+0xf/0x11
[    0.418110]  [<ffffffff81000771>] enter_idle+0x20/0x22
[    0.418114]  [<ffffffff81000821>] cpu_idle+0x73/0xf9
[    0.418119]  [<ffffffff81b6b7ca>] start_secondary+0x9a/0x9c
[    0.418122] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.424803] Switched to NOHz mode on CPU #0


--==_Exmh_1309904282_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE42acC3lWbTT17ARAlKsAKC2rZ5Qk04/ChhMgyop4Q/Rc4FETgCfb0Oq
bmrL1s3CCh8sqifTMk+35BY=
=eneX
-----END PGP SIGNATURE-----

--==_Exmh_1309904282_18528P--

