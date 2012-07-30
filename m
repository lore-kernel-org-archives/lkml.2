Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2G3CyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 22:54:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35787 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2G3Cx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 22:53:26 -0400
Date: Mon, 30 Jul 2012 12:53:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Axel Lin <axel.lin@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20120730125314.8bad3b71a8e727b892a47590@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Jul_2012_12_53_14_+1000_2yKL_jiORpLOAt32"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Jul_2012_12_53_14_+1000_2yKL_jiORpLOAt32
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/watchdog/orion_wdt.c between commit 0dd6e4847ed8 ("watchdog:
orion_wdt: Convert driver to watchdog core") from Linus' tree and commit
1e7bad0f5b91 ("ARM: Orion: DTify the watchdog timer") from the arm-soc
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/orion_wdt.c
index a73bea4,1531e02..0000000
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@@ -23,7 -24,8 +23,8 @@@
  #include <linux/io.h>
  #include <linux/spinlock.h>
  #include <linux/clk.h>
 +#include <linux/err.h>
+ #include <linux/of.h>
  #include <mach/bridge-regs.h>
 =20
  /*
@@@ -189,9 -292,16 +190,15 @@@ static int __devexit orion_wdt_remove(s
 =20
  static void orion_wdt_shutdown(struct platform_device *pdev)
  {
 -	if (test_bit(WDT_IN_USE, &wdt_status))
 -		orion_wdt_disable();
 +	orion_wdt_stop(&orion_wdt);
  }
 =20
+ static const struct of_device_id orion_wdt_of_match_table[] __devinitdata=
 =3D {
+ 	{ .compatible =3D "marvell,orion-wdt", },
+ 	{},
+ };
+ MODULE_DEVICE_TABLE(of, orion_wdt_of_match_table);
+=20
  static struct platform_driver orion_wdt_driver =3D {
  	.probe		=3D orion_wdt_probe,
  	.remove		=3D __devexit_p(orion_wdt_remove),

--Signature=_Mon__30_Jul_2012_12_53_14_+1000_2yKL_jiORpLOAt32
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQFfcaAAoJEECxmPOUX5FEBbAP/iU+Vc94cybknwRUIoIBcLLP
NQvqVRyKBAick0W88qmC3D34Sc9Qqz2oj12aVZtiJ4lEdS6ydZiWYqzmWQ25SDOr
12LJnnX43O5ZjGncRCLIQ061/rAomDfHKzPnbmmTe47HeHZVCqlDhAl7xK3gi0te
EjknNtsBeJIYK2gGA0Eb0NXbZYEfLZnCmzytapZ1QVTDBZXCJrif048Tvjppzu+y
vg7N4SloAtwZlFOGeY9hTph52i331IU1HgSobrk9TR5F7fZVqE85nVX8jft8uqaM
7KBT5tSORX5ycpKqdJ9329y2hGa/1bxnUqLWIvrGijn6Kf19d+xwmy88DvO4ujZc
mpDs/Kf6UM97c+R0wlfCGLL756WuNAelo+6Sa0ul1QnwFARKDnLKzRXnDUwGXhUP
i1vD8nxfJ1NZctz3n2bLbjQUZuQnGdlcyzvNnGvQiib8UXmYGfL0R/FC/po5Zd/N
Znp9OXpdP6i7YMgiwMflqDDWlD1l7PVV5a2OINBzuRaJj4aQ6JEzF6SSyX5AC2c1
VT84BzFprsgAMsHANSMM+EWoRtaphXUagVMJ+35tDPsAylslhxMJPg0l2QZRGy84
eti1C96saN/VkXlc8HBqitKWq867nhNU3m/PKe8aO1DScYtgeQpGGLJmg7RqoY67
24qKvzzlaRbJW+uy7/WC
=rNrj
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Jul_2012_12_53_14_+1000_2yKL_jiORpLOAt32--
