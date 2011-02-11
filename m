Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1BKGXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:23:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49505 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1BKGXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:23:07 -0500
Date: Fri, 11 Feb 2011 17:22:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: linux-next: boot problen with next-20110211
Message-Id: <20110211172254.8aa4d816.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Feb_2011_17_22_54_+1100_/zRyOC.1X9BU8RL0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Feb_2011_17_22_54_+1100_/zRyOC.1X9BU8RL0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next boot test on a Power7 blade produced this message
several times:

sysfs: cannot create duplicate filename '/module/ehea/parameters/=C3=90'
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455
Modules linked in: ehea(+)
NIP: c0000000001ec990 LR: c0000000001ec98c CTR: c00000000056aa40
REGS: c00000002b7ab710 TRAP: 0700   Not tainted  (2.6.38-rc4-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28422484  XER: 00000005
TASK =3D c000000029379a20[2036] 'modprobe' THREAD: c00000002b7a8000 CPU: 13
GPR00: c0000000001ec98c c00000002b7ab990 c000000000b8a3d0 000000000000004a=
=20
GPR04: 0000000000000000 ffffffffffffffff 0000000000010000 0000000000000000=
=20
GPR08: 000000000a000000 0000000000000000 0000000000020000 0000000000000000=
=20
GPR12: 0000000028422482 c00000000f33d080 00000fff9765d0a0 0000000000000000=
=20
GPR16: 0000010012c800f0 0000010012c817d8 0000000000000000 0000000000000000=
=20
GPR20: 0000010012c813e0 0000010012c801f0 0000000000000205 0000000000002190=
=20
GPR24: fffffffffffffff4 0000000000000000 0000000000000001 c0000003fb85e000=
=20
GPR28: c00000002b7abaa0 c0000003fb760280 c000000000b0abf8 ffffffffffffffef=
=20
NIP [c0000000001ec990] .sysfs_add_one+0xa8/0xe0
LR [c0000000001ec98c] .sysfs_add_one+0xa4/0xe0
Call Trace:
[c00000002b7ab990] [c0000000001ec98c] .sysfs_add_one+0xa4/0xe0 (unreliable)
[c00000002b7aba30] [c0000000001ebf5c] .sysfs_add_file_mode+0x68/0xd4
[c00000002b7abae0] [c0000000001ef734] .internal_create_group+0x15c/0x23c
[c00000002b7abba0] [c0000000000c0528] .module_param_sysfs_setup+0x98/0xd8
[c00000002b7abc50] [c0000000000e1570] .load_module+0xa00/0x1104
[c00000002b7abd90] [c0000000000e1cd4] .SyS_init_module+0x60/0x244
[c00000002b7abe30] [c000000000008628] syscall_exit+0x0/0x40
Instruction dump:
7f64db78 4bffff11 e89e8010 4be527f1 60000000 e89d0018 4be527e5 60000000=20
7c641b78 e87e8020 48513c8d 60000000 <0fe00000> 7f63db78 4bf8a079 60000000=20
---[ end trace b4c38cc9ca87fe74 ]---

There are no changes to the ehea driver relative to Linus' tree.  ehea
was built as a module and it looks like this is the first module being
loaded.

Maybe the module parameter alignment patches?  That is a very strange
parameter name (it is the same in the other messages).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Feb_2011_17_22_54_+1100_/zRyOC.1X9BU8RL0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNVNW+AAoJEDMEi1NhKgbsZIwH/3MIUyzSAT5LCk5MUaRuaJfY
VtpDqPI3rynYMlC3FKw5ySPaOym9FK4kSpqhwZLrpkzORJpDHltukpJGLVaH28bj
+4MnF+Qbgg24vOZ6MfC6t4/V5ALjslQVsWQgE/0KMc8E0I2/PpKpI+cbeJv9OOfS
V6zoamhuPP9tbighiUKIkTSnmfG81QqVJfg6UNhVf+7VuXHUb1HPWLWSRIw1Or6D
L7J7Se21t3731Hs8652q2hbgAzV8+jk9WVxHuByf5TwkexLSZP5p2alLFrdBEHqV
yBix87xaxtnBhGOVodoU31iFWiL17E3n+/K4pZYAy7rIuN02ZDwpuumLvOM/wCY=
=edyk
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Feb_2011_17_22_54_+1100_/zRyOC.1X9BU8RL0--
