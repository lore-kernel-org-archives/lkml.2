Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2IQL0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:26:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41008 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2IQL0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:26:23 -0400
Date: Mon, 17 Sep 2012 21:26:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: build failure after merge of the final tree (arm-soc
 tree related)
Message-Id: <20120917212615.91bc134d237dcd5968f9f549@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_21_26_15_+1000_ui3+Hm6YKPaf46XY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_21_26_15_+1000_ui3+Hm6YKPaf46XY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or dire=
ctory

Caused by commit 7d7e1eba7e92 ("ARM: OMAP2+: Prepare for irqs.h removal").

I have added the following patch to restrict this driver to ARM until it
is fixed:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Sep 2012 21:18:21 +1000
Subject: [PATCH] ARM: retrict TWL4030_CORE to ARM while it is broken

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index df850c4..af5e5b7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -257,6 +257,7 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=3Dy && GENERIC_HARDIRQS
+	depends on ARM
 	select IRQ_DOMAIN
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_21_26_15_+1000_ui3+Hm6YKPaf46XY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVwjXAAoJEECxmPOUX5FEhz4P/jOmMTIrv8ZHn15/K1Iq9PRA
WyGm5SDu8HNB1ih6D4I0UEi2FeD7oZ4ktO4dSk7yj8rb/fkCbvy8Hu4y7Yn4q/yc
t68j7dkBc+7IFXe6WFdhjBzjDmftJGYatN2dCxuSHLkTFbi4FU/7doJPvUX8Onf0
9Bp+Cvkis5urHu/ZlJhpsPrhh7khtu/WE3HsRrH46p8dvwY6Sx0Kj60ZR4mDQROD
AJBpr0pQWcbmMfjUaQC47PVItE38ipjgPQo/Bjj+K8K4B6YXnnUKFFaxe32eyH4G
RNIlcZ6vMa3ByiQFfeNzHRAxrGYnpI1S74/ULtkWmfNQLV38yIszdpTclQ2j5CfW
JAjRsiUIpJocCqFjh3zEnDkUAHMgoEo04VAcHaJhV1E5fNk0SxhSnzQPYpsLvOal
fH1tBbEaEUOLI5UqVUf8djqh3OdsY35Wp3WkiboP8eaKWUW+pZOjrWlE28TzyV2M
+361e9ZZbu2xCy0Iimbk9HATU+vdgmxVF6rgvDUSUinPDnKNnklNRdmBLy07D4z5
J/sVQyY1YqZKk9sihXOgJ+iWuV29Mw0iWcZlXk6bFFSb2vrUrKFuggy8dKT8EZMo
FDfh848EKU6X4mU839g9dom+g1mxpo1a40qF+rpwNJV+O1RQ26XcHYDmiWtY3eJR
pZEbsbnWGabClHZ5YBmR
=vikz
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_21_26_15_+1000_ui3+Hm6YKPaf46XY--
