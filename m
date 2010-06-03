Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0FCHnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:43:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60744 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0FCHm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:42:59 -0400
Date: Thu, 3 Jun 2010 17:42:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: boot failure with next-20100603
Message-Id: <20100603174251.226da45d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jun_2010_17_42_51_+1000_7HjbrSiUjkpw2oNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jun_2010_17_42_51_+1000_7HjbrSiUjkpw2oNA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next produced these messages during the boot of a Power7
box:

Starting udev: udevd[2739]: udev: missing sysfs features; please update the=
 kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option; udev may fa=
il to work correctly

%GUnable to handle kernel paging request for data at address 0x00330000
Faulting instruction address: 0xc0000000000a2f50
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
last sysfs file: /sys/block/sda/uevent
Modules linked in:
NIP: c0000000000a2f50 LR: c0000000000a2f18 CTR: 0000000000000000
REGS: c00000000228f9a0 TRAP: 0300   Not tainted  (2.6.35-rc1-autokern1-next=
-20100603)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44422448  XER: 20000001
DAR: 0000000000330000, DSISR: 0000000042000000
TASK =3D c0000000fbe1ae40[2855] 'modprobe' THREAD: c00000000228c000 CPU: 12
GPR00: 0000000000000001 c00000000228fc20 c00000000099f620 d0000000010b7040=
=20
GPR04: d0000000010a4dac 0000000000000005 0000000000000000 0000000000000223=
=20
GPR08: 6c6f635f72656769 0000000000000000 0000000000000020 0000000000330000=
=20
GPR12: d9fb876c951b89f3 c00000000f331800 0000000000012510 0000000000010320=
=20
GPR16: 000000000000002a 0000000000000012 0000000000000000 c0000000fb90cc00=
=20
GPR20: 0000000000000010 0000000000000021 0000000000000029 d000000001098b68=
=20
GPR24: d000000001098ba8 c000000002174800 d0000000010b7040 d000000001097fb9=
=20
GPR28: d000000001088000 d000000001098128 c00000000092d120 d0000000010b7040=
=20
NIP [c0000000000a2f50] .load_module+0x990/0x1458
LR [c0000000000a2f18] .load_module+0x958/0x1458
Call Trace:
[c00000000228fc20] [c0000000000a2f18] .load_module+0x958/0x1458 (unreliable)
[c00000000228fd90] [c0000000000a3a78] .SyS_init_module+0x60/0x244
[c00000000228fe30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
7c7a1b78 7fa30040 41dd09cc 39230210 38030220 f9230218 f8030228 f9230210=20
f8030220 e9230240 38000001 e96d0040 <7c09592e> e80d01b0 f8030230 38800004=20
---[ end trace 85cf1caaf6abfc45 ]---
udevd-work[2749]: '/sbin/modprobe -b of:NlheaT<NULL>CIBM,lhea' unexpected e=
xit with status 0x000b

This was followed by several other similaar OOPSes also in load_module.

I assume that this may have something to do with the module loading
fix/cleanup that is in progress ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Jun_2010_17_42_51_+1000_7HjbrSiUjkpw2oNA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwHXPsACgkQjjKRsyhoI8w4igCcC/sQcH9ykEU3fWCOnwtoQlKc
mgsAn1ujSWyeW7DCx18pVdeAQpfKcF0U
=wYph
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jun_2010_17_42_51_+1000_7HjbrSiUjkpw2oNA--
