Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2GMFPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:15:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53924 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2GMFPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:15:01 -0400
Date: Fri, 13 Jul 2012 15:14:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20120713151451.b2ef97045ef2273ea15973c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jul_2012_15_14_51_+1000_c5=O_eZmZyWVOaSD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Jul_2012_15_14_51_+1000_c5=O_eZmZyWVOaSD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/Makefile between commit 4a31bd28e86a ("ARM: nomadik: convert
to generic clock") from the arm-soc tree and commit 8d4d9f52081c ("clk:
add highbank clock support") from the clk tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Makefile
index 26b6b92,02ffdf6..0000000
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -3,6 -3,11 +3,12 @@@ obj-$(CONFIG_CLKDEV_LOOKUP)	+=3D clkdev.
  obj-$(CONFIG_COMMON_CLK)	+=3D clk.o clk-fixed-rate.o clk-gate.o \
  				   clk-mux.o clk-divider.o clk-fixed-factor.o
  # SoCs specific
 +obj-$(CONFIG_ARCH_NOMADIK)	+=3D clk-nomadik.o
+ obj-$(CONFIG_ARCH_HIGHBANK)	+=3D clk-highbank.o
  obj-$(CONFIG_ARCH_MXS)		+=3D mxs/
  obj-$(CONFIG_PLAT_SPEAR)	+=3D spear/
+ obj-$(CONFIG_ARCH_U300)		+=3D clk-u300.o
+ obj-$(CONFIG_ARCH_INTEGRATOR)	+=3D versatile/
+=20
+ # Chip specific
+ obj-$(CONFIG_COMMON_CLK_WM831X) +=3D clk-wm831x.o

--Signature=_Fri__13_Jul_2012_15_14_51_+1000_c5=O_eZmZyWVOaSD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/67LAAoJEECxmPOUX5FER+8QAIFSSxzaagrRVuw19n7TS8mJ
C86ToupvnaDqtqTKV8PucdiaLlwsVaI6KqhGxMkO5e80Ee3uWb/ZpHdvM9CnD0I3
HvrhQW7wv2qMrzczpWgNaLZdtEyh6duAd2ofaoVelSpPe3R2iEcytP7U7HPqo9ga
g3c+FFklYB1A0BVMtRabCF44t3MZFYKvZSsrsO0F/9cGu1RZCa1WxL1jmXX6QWOd
RqzlOFzDY3Ox66y3lM0tfHkYvriknpGfEO6e1xz5aJTuPQZstRToJoD6NR0WIy7c
22n2hui4PfxMkeBjjmCph1MFeILLJeUYt+uRBaR4YxJZoz9MIFgyEXn0ZCb6Vyay
0QvG3rpCbiIAS0eTihABu1Er63QD/i9+znVenTEjQ1o6K1A2tnk0BSa2z8VsoMgK
xVzSkF79kATuvyrP5ac2AwUD6mu29GVJ/OxPxUnCUOnS13oqCEbc/AzKtE5YGjEf
w6M9OfT5e09Qx4y03XpSvhUPDMD6hcObVGdlwOXQUfqV6iXnZROaIstgNtxUyGGc
REWZUs7wptIZPT+UCAherBl6FSMyPhRoZ5s/lMMSDB2GZgxEM3hcLQmU0AEUalfO
RTNANbivw0DC1EzMbFL8hg4QqdOIOPQZtxJ+gO4+ktzhaBqIINv9W6QYn5hO2KAs
XtgakdtR+jgVf4BtLjf0
=iiRO
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jul_2012_15_14_51_+1000_c5=O_eZmZyWVOaSD--
