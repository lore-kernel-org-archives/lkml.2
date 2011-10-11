Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1JKCIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 22:08:11 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38885 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1JKCIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 22:08:10 -0400
Date: Tue, 11 Oct 2011 13:07:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        Boojin Kim <boojin.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111011130751.c8d3890734c7dd2b4c014439@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_13_07_51_+1100_z4CLThnHz9E_Yv7G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_13_07_51_+1100_z4CLThnHz9E_Yv7G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-exynos4/Kconfig between commit 15e0d9e37c7f ("ARM: pm: let
platforms select cpu_suspend support") from the arm tree and commits
bf856fbb5e10 ("ARM: EXYNOS4: Use generic DMA PL330 driver"), 0da3beadcbed
("ARM: S5P: Make the common S5P PM code conditionally compile") and
e2e13621b267 ("ARM: S5P: Make the sleep code common for S5P series SoCs")
from the s5p tree.

I did the obvious fixup (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos4/Kconfig
index a652735,dd660eb..0000000
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@@ -11,8 -11,9 +11,10 @@@ if ARCH_EXYNOS
 =20
  config CPU_EXYNOS4210
  	bool
- 	select S3C_PL330_DMA
+ 	select SAMSUNG_DMADEV
+ 	select S5P_PM if PM
+ 	select S5P_SLEEP if PM
 +	select ARM_CPU_SUSPEND if PM
  	help
  	  Enable EXYNOS4210 CPU support
 =20

--Signature=_Tue__11_Oct_2011_13_07_51_+1100_z4CLThnHz9E_Yv7G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk6T3AAoJEECxmPOUX5FErD8P/2kaeOTig8itBsXSDf13o2GB
tWVsNEGOXDJxjv+ZuNDAmyvhoEyKevsvYm1zVOG8afDrmv62NVtUcahKMbxKdAXI
gxe6gstULigFgvhOjMyL0xw4q/gfKdLgEia/viszHHUpDjb0v+pQ/x/cevO7Ex2E
20LUBplHYmaAXXxVVSBgpUvUExbj78Ui9f+DyxQ80lR7EGXaOSRMQ823So+OCtVG
4QOQqMx3zPmXwhfUvnPXrSJWWHiMJW8n1fkpxuPrUqHVARqF08KFjDTtGOtcExsu
MCOurC4niXxok5dTgWJke1Bkypr4bX3TOiq0K+iqNa8pjAVOQuu2EPgrC+ZKVX46
mGn60vWSNdlh5/B8TgSIwLU+SxOxYLQ8a75axScKpbKG6xRAxQkNAWYabd5xmUXe
zaiU1apXcXwUV+93RLlJCyr91iUtzViXyy83BMLCqpCmclXqf+Yb/HqHHhWiDCzf
KMra9BbiWeXOIN961xlt0BBzjgnsZ31RHiGWUXLx805T9RxrLLuayg4B1lhSmxtv
cQZNr/ZwjXTDdSylau89Iw0WZtzeWrVocZ1OotJeCQZ/vmErYUZngpE0mYR8e4ww
6leOESNe28dKlIBDdDC1rQ9oZKwpyZkOJ51rBocgYy/ntmy5n9U3pIyJEI8ccRgo
cDM4h9NMB3zrc261zLR9
=C2je
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_13_07_51_+1100_z4CLThnHz9E_Yv7G--
