Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab0DHX6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:58:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41206 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab0DHX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:58:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-04-05 - another RCU whinge (not network this time)
In-Reply-To: Your message of "Mon, 05 Apr 2010 16:09:45 PDT."
             <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1270771048_4354P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Apr 2010 19:57:28 -0400
Message-ID: <6417.1270771048@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BBE6D69.022F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1270771048_4354P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Apr 2010 16:09:45 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-04-05-16-09 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Hit another one.  I seem to be on a roll...

Seen in dmesg, happened near end of the initrd..

[   26.756864] 
[   26.756866] ===================================================
[   26.756869] [ INFO: suspicious rcu_dereference_check() usage. ]
[   26.756871] ---------------------------------------------------
[   26.756874] fs/proc/array.c:241 invoked rcu_dereference_check() without protection!
[   26.756876] 
[   26.756877] other info that might help us debug this:
[   26.756877] 
[   26.756879] 
[   26.756880] rcu_scheduler_active = 1, debug_locks = 0
[   26.756883] 2 locks held by pidof/2197:
[   26.756884]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff810f4c2a>] seq_read+0x3a/0x42d
[   26.756894]  #1:  (&(&sighand->siglock)->rlock){......}, at: [<ffffffff81047eff>] lock_task_sighand+0x79/0xcf
[   26.756903] 
[   26.756903] stack backtrace:
[   26.756906] Pid: 2197, comm: pidof Not tainted 2.6.34-rc3-mmotm0405 #3
[   26.756909] Call Trace:
[   26.756914]  [<ffffffff810638c5>] lockdep_rcu_dereference+0xaa/0xb2
[   26.756919]  [<ffffffff8112ed88>] collect_sigign_sigcatch+0x37/0xa0
[   26.756923]  [<ffffffff8112f066>] do_task_stat+0x275/0x837
[   26.756927]  [<ffffffff81063f83>] ? mark_held_locks+0x52/0x70
[   26.756931]  [<ffffffff810af6be>] ? get_page_from_freelist+0x390/0x5ab
[   26.756935]  [<ffffffff81062e7b>] ? register_lock_class+0x1e/0x325
[   26.756938]  [<ffffffff8106421a>] ? trace_hardirqs_on+0xd/0xf
[   26.756942]  [<ffffffff810af742>] ? get_page_from_freelist+0x414/0x5ab
[   26.756946]  [<ffffffff81063d32>] ? mark_lock+0x2d/0x22c
[   26.756949]  [<ffffffff81063d32>] ? mark_lock+0x2d/0x22c
[   26.756953]  [<ffffffff81064fe7>] ? __lock_acquire+0x391/0xcfc
[   26.756956]  [<ffffffff810b006f>] ? __alloc_pages_nodemask+0x796/0x823
[   26.756961]  [<ffffffff810d4e60>] ? ____cache_alloc+0x10a/0x5cb
[   26.756964]  [<ffffffff810d4e60>] ? ____cache_alloc+0x10a/0x5cb
[   26.756969]  [<ffffffff8159f84c>] ? sub_preempt_count+0x35/0x49
[   26.756973]  [<ffffffff8112f637>] proc_tgid_stat+0xf/0x11
[   26.756977]  [<ffffffff8112c005>] proc_single_show+0x57/0x74
[   26.756980]  [<ffffffff810f4ca1>] ? seq_read+0xb1/0x42d
[   26.756983]  [<ffffffff810f4dc3>] seq_read+0x1d3/0x42d
[   26.756988]  [<ffffffff810da357>] vfs_read+0xe0/0x140
[   26.756991]  [<ffffffff810da46d>] sys_read+0x45/0x69
[   26.756996]  [<ffffffff810026eb>] system_call_fastpath+0x16/0x1b
[   26.788544] dracut: Switching root


--==_Exmh_1270771048_4354P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLvm1ocC3lWbTT17ARAhGOAJ9fmU2xZpkTuCWRWTE35okHEM80OwCgos8j
5BqORk/D7y9tkKaNG9cKI6M=
=Km4u
-----END PGP SIGNATURE-----

--==_Exmh_1270771048_4354P--

