Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab2CMAmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:42:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55904 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2CMAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:42:03 -0400
Date: Tue, 13 Mar 2012 11:41:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Alan Ott <alan@signal11.us>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20120313114154.53b78acbd2383c1a31d46395@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_11_41_54_+1100_FNq.YThISvMOcjp1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_11_41_54_+1100_FNq.YThISvMOcjp1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/Makefile between commit 598695a02180 ("ARM: tegra:
convert to twd_local_timer_register() interface")from the arm tree and
commits 249c5172e80a ("ARM: tegra: build localtimer support only when
needed") and 7ff43eeabd19 ("ARM: tegra: enable tegra30 clock framework")
from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/Makefile
index f7d0443,7bea5d1..0000000
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@@ -13,9 -17,12 +17,11 @@@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+=3D teg
  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+=3D pinmux-tegra20-tables.o
  obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+=3D pinmux-tegra30-tables.o
  obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+=3D board-dt-tegra30.o
 -obj-$(CONFIG_SMP)			+=3D platsmp.o headsmp.o
 +obj-$(CONFIG_SMP)                       +=3D platsmp.o headsmp.o
+ obj-$(CONFIG_SMP)                       +=3D reset.o
 -obj-$(CONFIG_LOCAL_TIMERS)		+=3D localtimer.o
+ obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+=3D tegra30_clocks.o
  obj-$(CONFIG_HOTPLUG_CPU)               +=3D hotplug.o
- obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+=3D dma.o
+ obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+=3D dma.o apbio.o
  obj-$(CONFIG_CPU_FREQ)                  +=3D cpu-tegra.o
  obj-$(CONFIG_TEGRA_PCI)			+=3D pcie.o
  obj-$(CONFIG_USB_SUPPORT)		+=3D usb_phy.o

--Signature=_Tue__13_Mar_2012_11_41_54_+1100_FNq.YThISvMOcjp1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXpfSAAoJEECxmPOUX5FEKngP/3fmxvc4Rs0cCLYYIztpsMj5
kLQNnYZSFWoP85TRObjomK66STmn4/fb5DXRQfp59silaQbPNbBLzTw/EHToKX8C
PTeeI5vPeOkcKWT7L7lcxKq2iEdAMlUMsv2fAhMDk00CN9kyn2u6HnIZN9JEVpDO
m8Yx734t1b51VqYmS//MFXdxEe0adrwSsesd+hX6vMWAIQqwyC/I+5j2pPdWNvzr
l27Fcotw7vqSUT0LU82fWYyBACSbCfOya61q9v19T/iUzXi6B9DJTG1mOdulx7Dg
UZk76nuS+9PVsODD4WzIvtOBUU4khB00FrqBTt8a4SRPE1/JyA6vdNkGaocOAQwA
l+Fm5X0B8ZPMTVfQQMzZPMhjvi/glBp6TxHs5BIWTdtjIs/DLkovK94HUcyi2a+5
zMozg5mfWtrInLA1KIh+KRNl2omBKGy/XbDAim84jexWCYeesnOZvA92EnP/1ZwO
7Gjn4GPFHE+YWw3SDRn3LSHPqhCGhQ5eiVCz0GuhCoVgEocPitf7VVem6eTigMFy
s9LfUNlwHzEHDTaYnsXp+Cd/rUHm1xoWM7KkpxZByFbKrxmcdigHA14B1Cpwl++U
aPLv7vN3ki4wPOQ6DFXHqFxHePf/iNsFT5EJqC5XU0WDVve0bQqsZKyrLcsxNIeg
oUsb+zDXXZq9YAtCDQjI
=4xMf
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_11_41_54_+1100_FNq.YThISvMOcjp1--
