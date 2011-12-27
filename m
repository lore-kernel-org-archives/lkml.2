Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1L0XSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:18:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50564 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1L0XSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:18:04 -0500
Date: Wed, 28 Dec 2011 10:17:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajeshwari Shinde <rajeshwari.s@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228101756.c75f4233ac986203d4bf9a02@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_17_56_+1100_tiQCxgFulFWadjhh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_17_56_+1100_tiQCxgFulFWadjhh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5pc100/Makefile between commit dd4153d9af67 ("ARM: 7247/1:
S5PC100: introduce arch/arm/mach-s5pc100/common.[ch]") from the arm tree
and commit a60879e7ca17 ("ARM: SAMSUNG: Remove SDHCI bus clocks from
platform data"), 875a59374cd1 ("ARM: SAMSUNG: Consolidation of SPI
platform devices to plat-samsung") and 323d7717455e ("ARM: S5PC100:
Modified files for SPI consolidation work") from the s5p tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pc100/Makefile
index c3166c4,291e246..0000000
--- a/arch/arm/mach-s5pc100/Makefile
+++ b/arch/arm/mach-s5pc100/Makefile
@@@ -20,14 -32,4 +20,13 @@@ obj-y				+=3D dma.
  obj-$(CONFIG_MACH_SMDKC100)	+=3D mach-smdkc100.o
 =20
  # device support
 +
  obj-y				+=3D dev-audio.o
- obj-$(CONFIG_S3C64XX_DEV_SPI)	+=3D dev-spi.o
 +
 +obj-y					+=3D setup-i2c0.o
 +obj-$(CONFIG_S5PC100_SETUP_FB_24BPP)	+=3D setup-fb-24bpp.o
 +obj-$(CONFIG_S5PC100_SETUP_I2C1)	+=3D setup-i2c1.o
 +obj-$(CONFIG_S5PC100_SETUP_IDE)		+=3D setup-ide.o
 +obj-$(CONFIG_S5PC100_SETUP_KEYPAD)	+=3D setup-keypad.o
- obj-$(CONFIG_S5PC100_SETUP_SDHCI)	+=3D setup-sdhci.o
 +obj-$(CONFIG_S5PC100_SETUP_SDHCI_GPIO)	+=3D setup-sdhci-gpio.o
++obj-$(CONFIG_S5PC100_SETUP_SPI)		+=3D setup-spi.o

--Signature=_Wed__28_Dec_2011_10_17_56_+1100_tiQCxgFulFWadjhh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+lIlAAoJEECxmPOUX5FEmn8P+gJlr+1VCV2siCtGa8hAPix+
KuDB4GPpOXllmA+Extr65PwdNQjsxmRYapvBZHhi0rn+nlhZfZZ0DwUlOodJPBVf
oP48vmnBY3NiWuNJV4NmP7CaQ9hEOOCrX0VOYqfeV4YSTjBClCpHgFog+x/jxVZa
gyPH+kHVw0L3a94sbpYfzpFRpiSLCAZFOHKbhGWMdLLyByHyykUz/RSkPHxY3csf
+iN5wytu/wM+mx5HwepfNnFNboxRXD/0STXg0kOln8rM7CaHm4tss9JRiHJCzY3n
pUnIsQKrCVeW40fo9g5pyoIN1qaQKcrwXJHwv6YxMhZNX5Ip+Zc5p2dzbLQ24yBa
r5LG52k7P8ByS51gdDdL0/tQqNLo0t0fYyo+z09EnARQsTmpbdz1OZTVzysNenQa
MSnSX1XXSPsm9m/9iqECUTIkQ6FKHpvRNxZaABs/bwf3BzzIaqoFzP46G5I+W2SJ
PSemgVSXc2QszjX+kcR1HML3S4AfvkxJ01njFUG47ViSXztr6RaIdH3AbNz2HCiF
9DdFmg7F9Q0nexc8Hiyt7/BNIastK2cQWeB//QPBgZ0qN9pmwKfQECxX5Tdg+hyf
CHQ1Okx3cfMcJ5HnDNGH2Yl71dIU5ZFHOExyOIzLcwJrNo5LuCX3Qr+ooOtafo8E
QQgFxio/9/R0Tui5vvlB
=LEJ8
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_17_56_+1100_tiQCxgFulFWadjhh--
