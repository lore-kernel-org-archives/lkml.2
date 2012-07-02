Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2GBDQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:16:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55836 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2GBDQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:16:49 -0400
Date: Mon, 2 Jul 2012 13:16:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@marvell.com>, Leo Yan <leoy@marvell.com>,
        Qiao Zhou <zhouqiao@marvell.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the slave-dma tree with the arm tree
Message-Id: <20120702131645.a318e0db6ee778718b6de271@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_13_16_45_+1000_AfxG5StF7do+/8C1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_13_16_45_+1000_AfxG5StF7do+/8C1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got conflicts in
drivers/dma/Kconfig and drivers/dma/Makefile between commit 06dba53e6fcf
("dmaengine: add OMAP DMA engine driver") from the arm tree and commit
c6da0ba8dfc8 ("dmaengine: mmp_tdma: add mmp tdma support") from the
slave-dma tree.

Just context changes.  I fixed it up (see below) and can carry the fixes
as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/Kconfig
index 6f93365,d45cf1b..0000000
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@@ -262,12 -274,16 +276,22 @@@ config DMA_SA11X
  	  SA-1110 SoCs.  This DMA engine can only be used with on-chip
  	  devices.
 =20
 +config DMA_OMAP
 +	tristate "OMAP DMA support"
 +	depends on ARCH_OMAP
 +	select DMA_ENGINE
 +	select DMA_VIRTUAL_CHANNELS
 +
+ config MMP_TDMA
+ 	bool "MMP Two-Channel DMA support"
+ 	depends on ARCH_MMP
+ 	select DMA_ENGINE
+ 	help
+ 	  Support the MMP Two-Channel DMA engine.
+ 	  This engine used for MMP Audio DMA and pxa910 SQU.
+=20
+ 	  Say Y here if you enabled MMP ADMA, otherwise say N.
+=20
  config DMA_ENGINE
  	bool
 =20
diff --cc drivers/dma/Makefile
index ddc291a,370a655..0000000
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@@ -29,4 -29,4 +30,5 @@@ obj-$(CONFIG_PCH_DMA) +=3D pch_dma.
  obj-$(CONFIG_AMBA_PL08X) +=3D amba-pl08x.o
  obj-$(CONFIG_EP93XX_DMA) +=3D ep93xx_dma.o
  obj-$(CONFIG_DMA_SA11X0) +=3D sa11x0-dma.o
 +obj-$(CONFIG_DMA_OMAP) +=3D omap-dma.o
+ obj-$(CONFIG_MMP_TDMA) +=3D mmp_tdma.o

--Signature=_Mon__2_Jul_2012_13_16_45_+1000_AfxG5StF7do+/8C1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8RKdAAoJEECxmPOUX5FESKoP/023oLCsmvGN1sQLXNPWNNgP
tTj4eK4Taseu38pbG1ab/2NXc+391xii6FYeYh78qvMdUqryMEZilriiY/ffcDU/
8JxUscB0jIO8ik5tfksw0UZzX7JtRKHMW4RELrVoR2pMzuquwpitou7Aie0e4WBk
eaOFyP97WK2CzR4oMI8FumsSg0eluuKsN9H16uN6AqZhoCKA1hD4aL9Z+UGcdilu
m0RTcdpuG7ULZ20bOjU1u4FEqNAmE0iPmW7U2Sg9BpHvGSIBwUbMZhlopdISF2qy
l35v6zQ8kOvpDvPRYGnEEQlAWg20q2G6ktxeurjcFZiEfn4BUTe8jZX/57qA36UT
NOO8w46XWh80mjiwvVe2orwWW8o43sLI2yeDoJkdFEs/EgBd5wpZqDzU3Bi4AIpX
ERTsPPr9IUvCu2vC7e9b5i73ZidfoACsmsgEkTUtObjRYsu8cAxSVG85ulINR3um
y2qazKobZjOk8UDmaEmbTmKEsgIvoBQ1osVjsULJc4U4PuHmfwKdw1lv1zmDA0nO
g2t3Tc6NOo33jaY6SS67tjOzZ8hga00+kViaHZcL47Lg4/gBn+IQaXyqKatyyzco
+v12YtaB33jN/BroBiZxyvDBjiIZst/1F01a4PxvQtpOyKegWT2s8AKzpwhiZ45W
tz/j7+7KCNLetjdVFLVq
=Gjdz
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_13_16_45_+1000_AfxG5StF7do+/8C1--
