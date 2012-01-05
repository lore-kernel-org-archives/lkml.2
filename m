Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2AEA2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:28:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59130 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2AEA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:28:01 -0500
Date: Thu, 5 Jan 2012 11:27:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120105112752.5bc8a1fe745dfe3adbc45fe9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_11_27_52_+1100_pDWd=Kq1k3TxS9Up"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_11_27_52_+1100_pDWd=Kq1k3TxS9Up
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/Makefile between commit cc511b8d84d8 ("ARM: 7257/1:
EXYNOS: introduce arch/arm/mach-exynos/common.[ch]") from the arm tree
and commit fca3de6ab9bf ("ARM: EXYNOS: Limit usage of pl330 device
instance to non-dt build") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/Makefile
index bcb9efc,db527ab..0000000
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@@ -19,8 -19,6 +19,8 @@@ obj-$(CONFIG_SOC_EXYNOS4212)	+=3D clock-e
  obj-$(CONFIG_PM)		+=3D pm.o
  obj-$(CONFIG_CPU_IDLE)		+=3D cpuidle.o
 =20
- obj-$(CONFIG_ARCH_EXYNOS4)	+=3D dma.o pmu.o
++obj-$(CONFIG_ARCH_EXYNOS4)	+=3D pmu.o
 +
  obj-$(CONFIG_SMP)		+=3D platsmp.o headsmp.o
 =20
  obj-$(CONFIG_EXYNOS4_MCT)	+=3D mct.o
@@@ -46,8 -46,9 +48,10 @@@ obj-$(CONFIG_EXYNOS4_DEV_AHCI)		+=3D dev-
  obj-$(CONFIG_EXYNOS4_DEV_PD)		+=3D dev-pd.o
  obj-$(CONFIG_EXYNOS4_DEV_SYSMMU)	+=3D dev-sysmmu.o
  obj-$(CONFIG_EXYNOS4_DEV_DWMCI)		+=3D dev-dwmci.o
+ obj-$(CONFIG_EXYNOS4_DEV_DMA)		+=3D dma.o
+ obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+=3D dev-ohci.o
 =20
 +obj-$(CONFIG_ARCH_EXYNOS4)		+=3D setup-i2c0.o
  obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+=3D setup-fimc.o
  obj-$(CONFIG_EXYNOS4_SETUP_FIMD0)	+=3D setup-fimd0.o
  obj-$(CONFIG_EXYNOS4_SETUP_I2C1)	+=3D setup-i2c1.o

--Signature=_Thu__5_Jan_2012_11_27_52_+1100_pDWd=Kq1k3TxS9Up
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBO6IAAoJEECxmPOUX5FE4bQP/jT5K1dB/P9ykC6LQrYyR4yv
f8UazgVVwUOKzoPN34PWf+ubtG2XEX66C7mM0rYm7nkIHbT44BqoejXhauzpc4t2
uqut8KNU+NC8CkzxMn1oAPO8pG/aRfGQhMvGdSc9HP/ia5XQUnGORYJVQV4LXzgq
KN2nZIsa+Yuc4EmuyXpIW7fQ/ZJHG9EHSNLonSVgLiWF6G1EVMw0c3lz3Vo2eHn/
YQfz1hhkjizGF3vc42S7yDk41C9FCZ5IML4Pkf+UTphVYutzx6mg6dkYC0bt+av6
BAxuwcayGVqfQ3ORoKiZh1Z9irEbFX78DitRlfE3EZ+sh/+zOhoU12INhSAc0Gm6
vFvzoIMOpxdoRZaGOPcO1rUDhdgXzAzTYD36USrsdN5OhTk4KlD3qpY0emZ3ujOX
0ZZPA6Iw8mlykRpELiPQoz1IYF47pysetA1/EqbMIy836ICNPBrnj5Zgc99WvKYW
57iWEA+t6khkGk1XrXVv7w1izYABGQ2tsVhPFipB/5u9qDwfIzSMFE3piv4TSv2R
CEYQKbRKnFw5n6KP8zPlrw+mY+Iy6WCS1BJSu4SLT9B4T1/9jcQCNIfYOG2814HL
mE8m/zSZSVxpU2s/w3hGQmsQCH0BXyCmnELHBn13j6wwX0gLFFrVGe+2e9RXiyVB
FshxkLXqV1J9/ym/UqGB
=qTkJ
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_11_27_52_+1100_pDWd=Kq1k3TxS9Up--
