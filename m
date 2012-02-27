Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2B0FyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:54:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56885 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2B0FyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:54:06 -0500
Date: Mon, 27 Feb 2012 16:53:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227165356.6119ac92eabd7052fc56c741@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_16_53_56_+1100_10ea4Q9XuVr_Yeb4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_16_53_56_+1100_10ea4Q9XuVr_Yeb4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/syscalls/syscall_64.tbl between commit
arch/x86/syscalls/syscall_64.tbl ("x32: Add x32 system calls to
syscall/syscall_64.tbl") from the tip tree and commit "syscalls, x86: add
__NR_kcmp syscall" from the akpm tree.

I fixed it up (see below) but did not know if this call should be marked
"common".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_64.tbl
index 4aecc7e,ac3066f..0000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -304,50 -304,18 +304,51 @@@
  295	64	preadv			sys_preadv
  296	64	pwritev			sys_pwritev
  297	64	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo
 -298	64	perf_event_open		sys_perf_event_open
 +298	common	perf_event_open		sys_perf_event_open
  299	64	recvmmsg		sys_recvmmsg
 -300	64	fanotify_init		sys_fanotify_init
 -301	64	fanotify_mark		sys_fanotify_mark
 -302	64	prlimit64		sys_prlimit64
 -303	64	name_to_handle_at	sys_name_to_handle_at
 -304	64	open_by_handle_at	sys_open_by_handle_at
 -305	64	clock_adjtime		sys_clock_adjtime
 -306	64	syncfs			sys_syncfs
 +300	common	fanotify_init		sys_fanotify_init
 +301	common	fanotify_mark		sys_fanotify_mark
 +302	common	prlimit64		sys_prlimit64
 +303	common	name_to_handle_at	sys_name_to_handle_at
 +304	common	open_by_handle_at	sys_open_by_handle_at
 +305	common	clock_adjtime		sys_clock_adjtime
 +306	common	syncfs			sys_syncfs
  307	64	sendmmsg		sys_sendmmsg
 -308	64	setns			sys_setns
 -309	64	getcpu			sys_getcpu
 +308	common	setns			sys_setns
 +309	common	getcpu			sys_getcpu
  310	64	process_vm_readv	sys_process_vm_readv
  311	64	process_vm_writev	sys_process_vm_writev
+ 312	64	kcmp			sys_kcmp
 +#
 +# x32-specific system call numbers start at 512 to avoid cache impact
 +# for native 64-bit operation.
 +#
 +512	x32	rt_sigaction		sys32_rt_sigaction
 +513	x32	rt_sigreturn		stub_x32_rt_sigreturn
 +514	x32	ioctl			compat_sys_ioctl
 +515	x32	readv			compat_sys_readv
 +516	x32	writev			compat_sys_writev
 +517	x32	recvfrom		compat_sys_recvfrom
 +518	x32	sendmsg			compat_sys_sendmsg
 +519	x32	recvmsg			compat_sys_recvmsg
 +520	x32	execve			stub_x32_execve
 +521	x32	times			compat_sys_times
 +522	x32	rt_sigpending		sys32_rt_sigpending
 +523	x32	rt_sigtimedwait		compat_sys_rt_sigtimedwait
 +524	x32	rt_sigqueueinfo		sys32_rt_sigqueueinfo
 +525	x32	sigaltstack		stub_x32_sigaltstack
 +526	x32	timer_create		compat_sys_timer_create
 +527	x32	mq_notify		compat_sys_mq_notify
 +528	x32	kexec_load		compat_sys_kexec_load
 +529	x32	waitid			compat_sys_waitid
 +530	x32	set_robust_list		compat_sys_set_robust_list
 +531	x32	get_robust_list		compat_sys_get_robust_list
 +532	x32	vmsplice		compat_sys_vmsplice
 +533	x32	move_pages		compat_sys_move_pages
 +534	x32	preadv			compat_sys_preadv64
 +535	x32	pwritev			compat_sys_pwritev64
 +536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
 +537	x32	recvmmsg		compat_sys_recvmmsg
 +538	x32	sendmmsg		compat_sys_sendmmsg
 +539	x32	process_vm_readv	compat_sys_process_vm_readv
 +540	x32	process_vm_writev	compat_sys_process_vm_writev

--Signature=_Mon__27_Feb_2012_16_53_56_+1100_10ea4Q9XuVr_Yeb4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSxp0AAoJEECxmPOUX5FELggP/igHlJIzjJnxGbrW1sTtwFKX
e/bYDWCzie22tQKOvybB6G7p+Hw6otzBw3gizbgBW0WW4+T+eYnB1wALHqUe7dlu
4EcBaqtbJgwoYfD5T/JnKqPZnsYworSuXKYX5aXF8hqLy0G1S87UT93xv1cqO0Pr
n+XdH4H/4UlE7pM/adFscANPrcZdSsiIiHt7CjpEmK95WWFZ0pXRfNoaEqX1olU+
xIBQ7TTS0OPqqDq5drxlizIKtpDl9pWV3TPbs5SWaJz9iT2TgLBMlt4Rx3QahlXl
twAGliI2Lc85CPi+mhUw0wjq3WKiR1NjibKpYcCp/XvH/WDphksDFTCyQMVa6sl6
Vfp1jXQN5FVZB3/iTeNWP3iAnWEw674qdWIB95KDdIc0nP9WRUX3g4DApqW3YHKe
KyaTooSEmdckGhhwz9bcf3faer4cmX+UVLbYJKmcFlyTahBRymZ5wgNVuz4rXoGF
tMvSaupArHjaAiy6RRXP9qqZn2A+zhGsmBgViEOe4pGpPngjOohxk9Nz8TT2STmI
TvVS8gTIbVcreGzjDetW470HVy/2X5GSsqTmkRz9nI3lglJKNRN+Sb8VxCIPzkTZ
AaeMdtzdZwelb7eB+ri1ujujQgbxcgh1uRg/ONmCwYkKTvqgcH9kfjzCVGug3F7N
Hr9N7DuN36DiOdE2ufaB
=xvzh
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_16_53_56_+1100_10ea4Q9XuVr_Yeb4--
