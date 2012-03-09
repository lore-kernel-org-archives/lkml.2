Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2CIGT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:19:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37685 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2CIGTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:19:55 -0500
Date: Fri, 9 Mar 2012 17:19:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the moduleh tree with the mfd tree
Message-Id: <20120309171945.925bdfceddfdcf2f810f37e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_17_19_45_+1100_n9soxVnGZfr.65Gh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_17_19_45_+1100_n9soxVnGZfr.65Gh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
include/linux/mfd/abx500/ab8500.h between commit 0f6208375951 ("mfd: Add
ab8500 version detection and enforcing") from the mfd tree and commit
3a55cc4f6e53 ("device.h: audit and cleanup users in main include dir")
from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/abx500/ab8500.h
index 4b2df29,dca9439..0000000
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@@ -7,31 -7,11 +7,34 @@@
  #ifndef MFD_AB8500_H
  #define MFD_AB8500_H
 =20
- #include <linux/device.h>
+ #include <linux/mutex.h>
+=20
+ struct device;
+=20
  /*
 + * AB IC versions
 + *
 + * AB8500_VERSION_AB8500 should be 0xFF but will never be read as need a
 + * non-supported multi-byte I2C access via PRCMU. Set to 0x00 to ease the
 + * print of version string.
 + */
 +enum ab8500_version {
 +	AB8500_VERSION_AB8500 =3D 0x0,
 +	AB8500_VERSION_AB8505 =3D 0x1,
 +	AB8500_VERSION_AB9540 =3D 0x2,
 +	AB8500_VERSION_AB8540 =3D 0x3,
 +	AB8500_VERSION_UNDEFINED,
 +};
 +
 +/* AB8500 CIDs*/
 +#define AB8500_CUTEARLY	0x00
 +#define AB8500_CUT1P0	0x10
 +#define AB8500_CUT1P1	0x11
 +#define AB8500_CUT2P0	0x20
 +#define AB8500_CUT3P0	0x30
 +#define AB8500_CUT3P3	0x33
 +
 +/*
   * AB8500 bank addresses
   */
  #define AB8500_SYS_CTRL1_BLOCK	0x1

--Signature=_Fri__9_Mar_2012_17_19_45_+1100_n9soxVnGZfr.65Gh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWaEBAAoJEECxmPOUX5FEFBsP/jlrfczi/QNykmmcZODE6Kvg
KfFMOT0bc7JJGFVior+eWaV1Ma/d8e6EXJPhEmIO5TqnfhmO0wWr0hPGfaQzZK68
hQLlyhItcxKFEMu75DUlbiOpDxmZp3xmcvq0mgE2bax5leIIPV6CUj+FwwUvqts8
MLL0rJ7jIlMg2rLo2g+SIQVScKD3ATX+O1iHUa4Vk77bZFSDIsitu/HXST8Rb/ut
XX59qpabzI5BiMTjvyyLsXFt3Fmug93oYfhx/yLZCIUUPpnL90jxkdFCUf5rADLv
V++y78Z7Z8tBBUxv1g2cdJwQ/EjIs8vgyDTdOs+IMkvDYQ7g2OT9pxBWDwXgYXbU
O0n5hWF+YKqINB8sF5iUd3B1FJfHlj0hx/Kshy4lLJONGcKUBajaacJ6PSzVeKkS
oT2t/oNB4+WEjJ58oUDV2isjLRi19McdDpfuYrGc6gjhm12buas1cLa8SZ15PecD
meZ3ZSvJ0y/Ut7M4Gsj8B65hYzqkzLpQLsKT3q+isTXdOreSvZspZhsBteURrDrS
f7+0Bwgca5IHrFTqDwovl98wPCfobjtdRZY2rUmYj3lGO+sjJOQ7RYh9JieHW6gl
pYXxLEpRtpNx7QHSxEfyCheDKos5QcU/fjywJdGEpJI/2sum+IYLRvIvxw6L5wR1
gTRNuN+OZvPDZk5HI3VK
=SvPW
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_17_19_45_+1100_n9soxVnGZfr.65Gh--
