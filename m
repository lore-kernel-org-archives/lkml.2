Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0JFJeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:34:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54886 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab0JFJeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:34:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process 
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1286357577_11346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Oct 2010 05:32:57 -0400
Message-ID: <108598.1286357577@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CAC424A.00CB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1286357577_11346P
Content-Type: text/plain; charset=us-ascii

Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.

Have seen this three times now while trying to attach gdb to a hung Firefox
process.

[20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
[20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d

Here's the stack traceback:

[20669.480761] Process gdb (pid: 60320, threadinfo ffff8800a0e4c000, task ffff8800c62acc80)
[20669.480763] Stack:
[20669.480765]  ffff8801188c2eac ffffffff81a40750 0000000100000000 ffffffff81a406b0
[20669.480771] <0> ffffffff8100b469 ffff8800a0d6c400 0000000000000000 ffffffff81a406b0
[20669.480777] <0> ffffffff8100b469 0000000000000000 ffff8800a0e4dcf8 ffffffff810b83e5
[20669.480784] Call Trace:
[20669.480789]  [<ffffffff8100b469>] ? ptrace_triggered+0x0/0x39
[20669.480793]  [<ffffffff8100b469>] ? ptrace_triggered+0x0/0x39
[20669.480797]  [<ffffffff810b83e5>] reserve_bp_slot+0x22/0x3b
[20669.480800]  [<ffffffff810b6805>] ? perf_init_event+0x0/0xc9
[20669.480804]  [<ffffffff810b8487>] register_perf_hw_breakpoint+0x11/0x36
[20669.480808]  [<ffffffff810b84cb>] hw_breakpoint_event_init+0x1f/0x34
[20669.480811]  [<ffffffff8100b469>] ? ptrace_triggered+0x0/0x39
[20669.480815]  [<ffffffff810b685a>] perf_init_event+0x55/0xc9
[20669.480818]  [<ffffffff810b6805>] ? perf_init_event+0x0/0xc9
[20669.480822]  [<ffffffff810b6a74>] perf_event_alloc+0x1a6/0x3ef
[20669.480826]  [<ffffffff810b6f92>] perf_event_create_kernel_counter+0x22/0x185
[20669.480830]  [<ffffffff810b7d9b>] register_user_hw_breakpoint+0xf/0x11
[20669.480834]  [<ffffffff8100c7d3>] ptrace_set_debugreg+0xaa/0x257
[20669.480838]  [<ffffffff8156bfab>] ? sub_preempt_count+0x35/0x48
[20669.480844]  [<ffffffff81568957>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[20669.480848]  [<ffffffff8100cd48>] arch_ptrace+0x126/0x214
[20669.480852]  [<ffffffff81045609>] sys_ptrace+0x7e/0x99
[20669.480857]  [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b

Any thoughts? I haven't gotten any further than "the big honking commits
against perf in linux-next".  Probably bisectable with some effort - I've got
a fairly replicable Firefox hang that seems to trigger the gdb indigestion.,


--==_Exmh_1286357577_11346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMrEJJcC3lWbTT17ARAhCQAJ9+60uLVy4Sk+iTnVY31836l9587wCdG4Sb
KYerzz92WjQNZV0pUUDOMyc=
=Z4bk
-----END PGP SIGNATURE-----

--==_Exmh_1286357577_11346P--

