Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2IXJLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:11:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56826 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2IXJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:11:06 -0400
Date: Mon, 24 Sep 2012 19:10:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20120924191053.e0fbf9e8d43a7a83115f2bcc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_10_53_+1000_DC/UYrzRo=dvmf+Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_10_53_+1000_DC/UYrzRo=dvmf+Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-rx51-peripherals.c between commit 322c183cdc5f
("[media] ARM: mach-omap2: board-rx51-peripherals: Add lirc-rx51 data")
from the v4l-dvb tree and commits 2203747c9771 ("ARM: omap: move
platform_data definitions") and 606281525fb7 ("ARM: OMAP2+: Make
gpmc-smc91x.h local") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-rx51-peripherals.c
index ca07264,3945c50..0000000
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@@ -30,13 -33,9 +33,10 @@@
  #include "common.h"
  #include <plat/dma.h>
  #include <plat/gpmc.h>
- #include <plat/onenand.h>
- #include <plat/gpmc-smc91x.h>
 +#include <plat/omap-pm.h>
+ #include "gpmc-smc91x.h"
 =20
- #include <mach/board-rx51.h>
+ #include "board-rx51.h"
 =20
  #include <sound/tlv320aic3x.h>
  #include <sound/tpa6130a2-plat.h>

--Signature=_Mon__24_Sep_2012_19_10_53_+1000_DC/UYrzRo=dvmf+Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCOdAAoJEECxmPOUX5FElZIP/32cnfYzaxKS/EPN/fpMgKxd
NCj3s5R8x8e5qZYEjxJKpWywAozKVjngdYIEDgeihcywhhnDB9S73RKCOfl+KydX
DBvwYtnDVdPcvRSOOJZ/UCSCDV+jrCBPrkOBwTQGnvFnazXmu9wUhTwTc815VVOa
p9FpEkbM47l9yiu7jd1+dtj8rb7mztkUMM2Mmfk8wOOoUWnh+g9OJ4ej5u7Ym8uh
4TM9rvREfanVWk8xjs6tPRjQm4NOA3Eaghp0lRceEKCfzn5uatCstsjXUc1EQVP1
rqM6lvOIh31c1Sg+rxi45tHTnZ5Trhj17joCebv0C3oWEo9gtz8kTvIZrcwF+Vbr
aFAKqhLvAj+rgbIdo1ekpKR0gcaq8xVM84Ppa0NUUZUsKRFhv80e96xo6PZzp4gu
R6U+FxxvRYfJBuH9ZOO+ej/E8p9hGp1kNBX8agfDFwsmP5p1MhpOinVyTyTHZX9X
hrUsSCI51WqguAO8vjoqYcuL/qcNU1tDPJh6n1H9qeX2SWYn2Blw3MAFAmplalsL
5oEkKc+OszIj36waAyBb+dkC1mjozDI8vXeadvblPXHfN20ky9C6LMRKSQWXleHv
3I1zRZUa33IzWgP5Nh04idQV4/BaCdROGswt/YzDBXI/VdQe8Bo8ykIW82jOp5Wq
wEUJEqKuq+FL3S2LHM81
=a7C1
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_10_53_+1000_DC/UYrzRo=dvmf+Z--
