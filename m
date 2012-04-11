Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2DKG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:59:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52779 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2DKG67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:58:59 -0400
Date: Wed, 11 Apr 2012 16:58:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: boot failures with next-20120411
Message-Id: <20120411165835.415e546374a54ea94669b0c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Apr_2012_16_58_35_+1000_FMrZCuNAtGIJ1=BC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Apr_2012_16_58_35_+1000_FMrZCuNAtGIJ1=BC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Some (not all) of my PowerPC boot tests have failed like this after
getting into user mode (this one was just after udev started, but others
are after other processes getting going):

Unable to handle kernel paging request for data at address 0xc0000003f9d550
Faulting instruction address: 0xc0000000001b7f40
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D32 NUMA pSeries
Modules linked in: ehea
NIP: c0000000001b7f40 LR: c0000000001b7f14 CTR: c0000000000e04f0
REGS: c0000003f68bf6b0 TRAP: 0300   Not tainted  (3.4.0-rc2-autokern1)
MSR: 800000000280b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 24422424  XER: 20=
000001
SOFTE: 1
CFAR: 000000000000562c
DAR: 00c0000003f9d550, DSISR: 40000000
TASK =3D c0000003f8818000[3192] 'kdump' THREAD: c0000003f68bc000 CPU: 5
GPR00: 0000000000000000 c0000003f68bf930 c000000000ce1d40 c0000003fe00ec00=
=20
GPR04: 00000000000002d0 0000000000000038 c0000003f8f935e8 c000000000e55280=
=20
GPR08: 0000000000000011 c000000000bcb280 c000000000bcb1e8 000000000028a000=
=20
GPR12: 0000000024422424 c00000000f33bc80 00000fffdd90a770 0000000000081000=
=20
GPR16: c0000003f846c000 000000000de4f7a0 f00000000de4f7a0 0000000000000000=
=20
GPR20: c0000003f8365408 c0000003f8365480 c0000003f8e5d110 0000000000000000=
=20
GPR24: 0000000000000100 c0000003f8365400 c0000000001e5424 00000000000002d0=
=20
GPR28: 0000000000000800 00c0000003f9d550 c000000000c5b718 c0000003fe00ec00=
=20
NIP [c0000000001b7f40] .__kmalloc+0x70/0x230
LR [c0000000001b7f14] .__kmalloc+0x44/0x230
Call Trace:
[c0000003f68bf930] [c0000003f68bf9b0] 0xc0000003f68bf9b0 (unreliable)
[c0000003f68bf9e0] [c0000000001e5424] .alloc_fdmem+0x24/0x70
[c0000003f68bfa60] [c0000000001e54f8] .alloc_fdtable+0x88/0x130
[c0000003f68bfaf0] [c0000000001e5924] .dup_fd+0x384/0x450
[c0000003f68bfbd0] [c00000000009a310] .copy_process+0x880/0x11d0
[c0000003f68bfcd0] [c00000000009aee0] .do_fork+0x70/0x400
[c0000003f68bfdc0] [c0000000000141c4] .sys_clone+0x54/0x70
[c0000003f68bfe30] [c000000000009aa0] .ppc_clone+0x8/0xc
Instruction dump:
4bff9281 2ba30010 7c7f1b78 40dd00f4 e96d0040 e93f0000 7ce95a14 e9070008=20
7fa9582a 2fbd0000 41de0054 e81f0022 <7f3d002a> 38000000 886d01f2 980d01f2=20
---[ end trace 366fe6c7ced3bfb0 ]---

This did not happen yesterday.  Just wondering if anyone can think of
anything obvious.  Full console log at
http://ozlabs.org/~sfr/next-20120411.log.bz2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Apr_2012_16_58_35_+1000_FMrZCuNAtGIJ1=BC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhSubAAoJEECxmPOUX5FEotAQAJt32DqlOGbYmFdtdK5zg7zk
Vu/nFo1UtySV8VkspybiENkhh60m+PU/oxhBGztnDfs6K/k5kI6qIWg+8VmT946B
VExR7WPUFgKBaCURti92+r9YA9QsLwwhkC2xaL/AL75Q0dtRhTtKZmY+HzQwkoJN
85QCTX01MxQ4K7lAy25erHsd4b5IKacRB+SL1VuGdCvAT7pfKk/EAr2gtz07KWaF
gQw4aovBGTwnebhZ1fGTiil0DruR+XDnz/8wGiMIBahJLp3OKazhQmKL1tQNF+ON
MKSSZeiqLJwZX4Etqu9MvaPy4qzXDomlCKKH4E1a9bri7gNCRUUGWoPYi35TGHu/
+w7kDvT56F09rYP/9/GIC7n9CScxjsyb3AhBBRLOyeg/BINOYiSCmmmAE/OSyl0J
ZqF2OC2i5lwYQlX0I8L47Xk/OvEy6mO2CG6YM8Nhlft5TY4Ry7JyHHj3X1ch3Z4i
T7Y3QS/2DoGK5S11UQBOxx63gepjk+uvrLKnNWhkW7erPnB3OENKL9Lz93rYQZ7K
1skCe5iBMb6Y18tXvd9hnZRin1sckeiBi6rcS/3jXFwpk0OwxmaGu2Tw4EMwn/GZ
Zn9Zu2JM/xRsD+4oU+cEAwQEyzq74vhQBTu7qRaeCrm7p2KTni4n38Pc1dVDJumm
qR4oP9T33qyZ9ltaQ+RL
=w3a3
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Apr_2012_16_58_35_+1000_FMrZCuNAtGIJ1=BC--
