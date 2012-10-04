Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab2JDE37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:29:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34897 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2JDE34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:29:56 -0400
Date: Thu, 4 Oct 2012 14:29:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the arm-soc tree with the modules tree
Message-Id: <20121004142944.70f5ebb6dbc197322b04bfea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_14_29_44_+1000_=_+pwI4Pln5K4uCd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_14_29_44_+1000_=_+pwI4Pln5K4uCd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/cris/include/asm/Kbuild, arch/h8300/include/asm/Kbuild and
arch/m32r/include/asm/Kbuild between commit 786d35d45cc4 ("Make most arch
asm/module.h files use asm-generic/module.h") from the modules tree and
commit e7a570ff7dff ("asm-generic: Add default clkdev.h") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/cris/include/asm/Kbuild
index 28b690d,a8eab26..0000000
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@@ -8,4 -8,4 +8,5 @@@ header-y +=3D etraxgpio.
  header-y +=3D rs485.h
  header-y +=3D sync_serial.h
 =20
 +generic-y +=3D module.h
+ generic-y +=3D clkdev.h
diff --cc arch/h8300/include/asm/Kbuild
index 871382d,0e152a9..0000000
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@@ -1,3 -1,3 +1,4 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y	+=3D module.h
+ generic-y	+=3D clkdev.h
diff --cc arch/m32r/include/asm/Kbuild
index 871382d,0e152a9..0000000
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@@ -1,3 -1,3 +1,4 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y	+=3D module.h
+ generic-y	+=3D clkdev.h

--Signature=_Thu__4_Oct_2012_14_29_44_+1000_=_+pwI4Pln5K4uCd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbRC4AAoJEECxmPOUX5FEn2kP/RZxWPtZo1+pP4Dd2zaHELle
5IVzMdKUG8AvN4qj8enEi21g4qwoTN8WOjhMwexzGh0WcpwW8Q50ppCGeELeQq7i
sbP45sjRJqzYnw8Hahih6FpEJTXJk0CZ/9PJGPCteG9cBIv3Rs39ry7QtDMTodv3
vB6+6VMD7WCPJZ6V+g7yb2YYQCPCk80nFM2CB7fT+9TMMyowOBm+rSePDbbRst8W
Wl3txNSx8A6dFfY5EH9kdR/UhMAS1/oTJJsXqs/qhhd7t9YmwurGuUyxbD+l+jxr
iTxYk+Ikv4tFkfFzQIMQKVcm8j2SMqCsds20vNnn48AajoqxMOn60UZ0W70K5RIa
4hUwfVhEoWb9cdBnwjIppZXpiH9sZgdWNNqt/N9rYGjeD7osYeGpM85+RsTIIkRk
0GJlPpi1Mr6y/fyN9C0tPswHllXFa/18mZdjSgN+tw0uJ1vPZRXD30viVjSyEZgR
/IpU6cA+gAoPEuHAcyJZfl3Wcfln50lyOKS9uB1/+ZC9jkxmW/kWgS5Jbi3KLdod
b8sEhYhGjImuTUkSDhHqY/ojfeTmv1jTizlaA9O1eB1JUB/jB3Q2G4Y8XK5QaNEN
jX2z7q8FtxZrb3BH1199a3bw1BSOuvw5P2YmJi4WM/9MsFDdIfPr76NjeCXfBLRV
t8/2JHkCACYpCT7A9xbh
=dycg
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_14_29_44_+1000_=_+pwI4Pln5K4uCd--
