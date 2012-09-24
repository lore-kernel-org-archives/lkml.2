Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2IXIax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:30:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51519 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab2IXIav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:30:51 -0400
Date: Mon, 24 Sep 2012 18:30:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120924183049.44bc374d9dc8b8504e504d99@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_18_30_49_+1000_JvnT5wJkvFnfMlw2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_18_30_49_+1000_JvnT5wJkvFnfMlw2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-davinci/include/mach/da8xx.h between commit 896f66b7de29
(ASoC/ARM: Davinci: McASP: split asp header into platform and audio
specific"") from the sound tree and commit ec2a0833e515 ("ARM: davinci:
move platform_data definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/include/mach/da8xx.h
index c74a6ab,33e78ae..0000000
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@@ -20,11 -19,12 +20,11 @@@
 =20
  #include <mach/serial.h>
  #include <mach/edma.h>
- #include <mach/i2c.h>
- #include <mach/mmc.h>
- #include <mach/usb.h>
 -#include <mach/asp.h>
  #include <mach/pm.h>
- #include <mach/spi.h>
+ #include <linux/platform_data/i2c-davinci.h>
+ #include <linux/platform_data/mmc-davinci.h>
+ #include <linux/platform_data/usb-davinci.h>
+ #include <linux/platform_data/spi-davinci.h>
 =20
  extern void __iomem *da8xx_syscfg0_base;
  extern void __iomem *da8xx_syscfg1_base;

--Signature=_Mon__24_Sep_2012_18_30_49_+1000_JvnT5wJkvFnfMlw2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYBo5AAoJEECxmPOUX5FEzIYP/3OVLTwrgQjeJZqDUXo1uoAH
/4AYQH8b/aex/VavyeFZU+piyVCg/w8hp/7aAw5EuqL3SLGV/up+XHKJR4+w96+I
J2H6FWart7/kptXP2lmZcxJpYk3DiadA8T32Vpktz5LWNAwjoV7VMWbyALRh3qhR
oHVRqERu6VGy99Y+RaLJnRsuZQ9I9EhaDXNEfAeHEPT8hweGY1Qk3l7AwAiBf7ES
/Y2KU8/qNJn9AyuKZeSXL3SjbgSmCeYCP+6/J88bgkM50+AcR2xTnD0JH4Em5L17
RgQfh8U8eKh7HTNe8cFk19THNenVUdE0bnzWZRQf7xLOdblN835KlxuOhRsZ/L63
6oCcJd1oJngE74IrK1YOvCsarZAuKSratQoLC8vE1XYf4y7qPUPYAR/IDOTnfAni
nXLigBlaEHuQocDqenuI+LfMIizaupvnDiq2EFNxti8AKuGNMq5QROO6lEXLxFJt
5xM1r6GOU4OYRIiNa4giCzkkuZpq10eHPrhZ1lVKEBx/Q00gSyc2JpIALZJVvAGA
Y+Vlp3oKUOOHpCEoZYyPBUW0JP+3EOljhpQmMZaV8OCZ1bAbn3NixNZ42Wd84eCu
Y0Jsd4sOo97CNB7Lv7Dx9mx7bgH96b1wkcU0pcoTu59nrc2GN3QBSxdtEgZDBMbk
QmXG9gcX8Xnd1sGwyCE7
=1jMQ
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_18_30_49_+1000_JvnT5wJkvFnfMlw2--
