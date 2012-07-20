Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2GTD2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:28:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60542 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GTD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:28:49 -0400
Date: Fri, 20 Jul 2012 13:28:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120720132840.f8269e2c3658daa010904dca@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_13_28_40_+1000_ZFQaNyPUeWwyG6mT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_13_28_40_+1000_ZFQaNyPUeWwyG6mT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/ipack/devices/ipoctal.c: In function 'ipoctal_set_termios':
drivers/staging/ipack/devices/ipoctal.c:614:22: error: invalid type argumen=
t of '->' (have 'struct ktermios')
drivers/staging/ipack/devices/ipoctal.c:640:15: error: invalid type argumen=
t of '->' (have 'struct ktermios')
drivers/staging/ipack/devices/ipoctal.c:654:14: error: invalid type argumen=
t of '->' (have 'struct ktermios')
drivers/staging/ipack/devices/ipoctal.c:691:2: error: incompatible type for=
 argument 1 of 'tty_termios_encode_baud_rate'
include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument=
 is of type 'struct ktermios'
drivers/staging/ipack/devices/ipoctal.c:694:22: error: invalid type argumen=
t of '->' (have 'struct ktermios')
drivers/staging/ipack/devices/ipoctal.c:735:3: error: incompatible type for=
 argument 1 of 'tty_termios_encode_baud_rate'
include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument=
 is of type 'struct ktermios'

Presumably caused by commit adc8d746caa6 ("tty: move the termios object
into the tty").

Under previous instructions about staging drivers, I have added the
following patch for today:

=46rom c4bc70a8fc9cc687690aaf51865561ffcd6190f9 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Jul 2012 13:25:12 +1000
Subject: [PATCH] disable SERIAL_IPOCTAL broken by tty updates

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/ipack/devices/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/devices/Kconfig b/drivers/staging/ipack/=
devices/Kconfig
index 39f7188..8d69ce3 100644
--- a/drivers/staging/ipack/devices/Kconfig
+++ b/drivers/staging/ipack/devices/Kconfig
@@ -1,6 +1,7 @@
 config SERIAL_IPOCTAL
 	tristate "IndustryPack IP-OCTAL uart support"
 	depends on IPACK_BUS
+	depends on BROKEN
 	help
 	  This driver supports the IPOCTAL serial port device for the IndustryPac=
k bus.
 	default n
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_13_28_40_+1000_ZFQaNyPUeWwyG6mT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCNBoAAoJEECxmPOUX5FET2gP/R2RiO6lO5un70X4pkiGJgzO
xR9mLIsicmoXdWNP9h4QtFQ9P1jc/crZg9AY0kSnfGSunT/iQ1QkrlP6nIuVtLj/
8nxNKN3k1ExzCU3yc9QSUJ2y40027WyVGqD8SnF+2+A7S1d5CfD64J3BgphzFecC
hibUYpHHgZBSKZMVE3SA+gQuQL4kmFAQQsb6NSH8eIeKs/aFn1MBIo/qxKvrYptJ
g7TiGVD59NWb8PJBkj8ZSC9aa5qgNr7SYZiTeSZM11+VDQY4f8k37P3l9+fVLOVi
Mhkbt5g3f93vKcSCHl1eqvfuCQ6nX/WbGyNlCVojpUVDkwaL4blQf7WVROZaUMeV
4GbgPY87Oxuzq2PXPU7P9eM43zavXuHmTEEARtqfnaiWptF03pep8yWO9GjBdpsE
cSz6G5v4zKYbKDEqOrjPULv6OVPi7ABjEe1ilvfRF8nG3Cs9LcLSvXiAuuqTFG06
cxVvJq5GuMqgHpOG9OFrdUxxdmggj7u52rB1bvEi+IOgH9GxpcbcxUXXfmZzvIvA
0fBoHlnhHiOVpk/qdKws6N4N+U3jzkJXdYsE3eIiIRnWv0UmclE+mRBAcsd+AqYQ
ATQXJvj1dLXh8tT6YccH3NlGnkdfkz4SneOY1ej1MGE8v4DgWBy/uDTaqrCJxrZG
LyuZMxAF+g1dj77S7feq
=1/UZ
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_13_28_40_+1000_ZFQaNyPUeWwyG6mT--
