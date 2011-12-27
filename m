Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1L0XH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:07:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60734 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1L0XH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:07:56 -0500
Date: Wed, 28 Dec 2011 10:07:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rajeshwari Shinde <rajeshwari.s@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228100741.5a6a6f36055d2ea06c1d4014@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_07_41_+1100_ZP22pmQAOFC9mt.R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_07_41_+1100_ZP22pmQAOFC9mt.R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s3c64xx/Makefile between commit b024043b6d0d ("ARM: 7245/1:
S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]") from the arm tree
and commits 8f8a8d269bb4 ("ARM: S3C64XX: Add basic cpuidle driver"),
a60879e7ca17 ("ARM: SAMSUNG: Remove SDHCI bus clocks from platform
data"), 875a59374cd1 ("ARM: SAMSUNG: Consolidation of SPI platform
devices to plat-samsung") and 4566c7f7612f ("ARM: S3C64XX: Modified files
for SPI consolidation work") from the s5p tree.

I fixed it up (I think - see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/Makefile
index f37016c,2244c42..0000000
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@@ -19,29 -19,29 +19,29 @@@ obj-y				+=3D common.o clock.
  obj-$(CONFIG_CPU_S3C6400)	+=3D s3c6400.o
  obj-$(CONFIG_CPU_S3C6410)	+=3D s3c6410.o
 =20
 -obj-y				+=3D irq.o
 -obj-y				+=3D irq-eint.o
 +# PM
 +
 +obj-$(CONFIG_PM)		+=3D pm.o irq-pm.o sleep.o
++obj-$(CONFIG_CPU_IDLE)		+=3D cpuidle.o
 =20
  # DMA support
 =20
  obj-$(CONFIG_S3C64XX_DMA)	+=3D dma.o
 =20
 -# Device setup
 +# Device support
 =20
 -obj-$(CONFIG_S3C64XX_SETUP_I2C0) +=3D setup-i2c0.o
 -obj-$(CONFIG_S3C64XX_SETUP_I2C1) +=3D setup-i2c1.o
 -obj-$(CONFIG_S3C64XX_SETUP_IDE) +=3D setup-ide.o
 -obj-$(CONFIG_S3C64XX_SETUP_KEYPAD) +=3D setup-keypad.o
 -obj-$(CONFIG_S3C64XX_SETUP_FB_24BPP) +=3D setup-fb-24bpp.o
 -obj-$(CONFIG_S3C64XX_SETUP_SDHCI_GPIO) +=3D setup-sdhci-gpio.o
 -obj-$(CONFIG_S3C64XX_SETUP_SPI) +=3D setup-spi.o
 +obj-y				+=3D dev-uart.o
 +obj-y				+=3D dev-audio.o
- obj-$(CONFIG_S3C64XX_DEV_SPI)	+=3D dev-spi.o
 =20
 -# PM
 +# Device setup
 =20
 -obj-$(CONFIG_PM)		+=3D pm.o
 -obj-$(CONFIG_PM)		+=3D sleep.o
 -obj-$(CONFIG_PM)		+=3D irq-pm.o
 -obj-$(CONFIG_CPU_IDLE)		+=3D cpuidle.o
 +obj-$(CONFIG_S3C64XX_SETUP_FB_24BPP)	+=3D setup-fb-24bpp.o
 +obj-$(CONFIG_S3C64XX_SETUP_I2C0)	+=3D setup-i2c0.o
 +obj-$(CONFIG_S3C64XX_SETUP_I2C1)	+=3D setup-i2c1.o
 +obj-$(CONFIG_S3C64XX_SETUP_IDE)		+=3D setup-ide.o
 +obj-$(CONFIG_S3C64XX_SETUP_KEYPAD)	+=3D setup-keypad.o
- obj-$(CONFIG_S3C64XX_SETUP_SDHCI)	+=3D setup-sdhci.o
 +obj-$(CONFIG_S3C64XX_SETUP_SDHCI_GPIO)	+=3D setup-sdhci-gpio.o
++obj-$(CONFIG_S3C64XX_SETUP_SPI)		+=3D setup-spi.o
 =20
  # Machine support
 =20

--Signature=_Wed__28_Dec_2011_10_07_41_+1100_ZP22pmQAOFC9mt.R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+k+9AAoJEECxmPOUX5FEj9AP/Rp9jOtc5+x22/pHjLkAgbmv
PuaOorcF3usdin+iouJCXZHXD8bXa8770m+eu1Ccgol8qY+bOkLFmelm8Wf+wzyO
465nNcUsoiWRkB07O2NYE1eNSgkF4V3t8q8dcEFXQ72ynCx4ktxSkJ0H4m0/20Ia
UxKjRy3Bn5MJnOB4kEutAgDMttvRhVrJ1GVis3zVNFVSyjBp7QGHwcLA7TuERJo5
nL6BnDuoB62xJm0fApt5D6DvlMLEBdA3trizTW9rOhI85msY22UHzI0xBV0dIJIy
1Y/jorpE6eCNex2s9Hl0w/tAWeeMrZFquG1VWRbkxONtZRSrWsKO1l/gKS/3UIhN
7qCUrniJGJ1DFTJYRDOJQoi85vLiOeg0az5QJKJtsTS0d2EvxC2cf7kUmquVqYAd
5Bg1vGlSALnqUbqz4xzsjfY+uR81YLqbkSN4lELOGH5tsXFk1jlIODdVuj3rotbt
3fyMsajCsKHI77YR+ZlcGjAofZ9N624Xnf/1fiY774mxRHNUHwsUaaFxZWydQNzj
PVGrNaGajnKCNfeF+U8pqYuHPIGuoOyifUVzEPYuHaoyz6mtawgVNTe28I2G4wdj
E17bcsNOTnmZOENnOo58plhxQ/A/neFFDUUXDlKsljbDX9vYDU5++9koRTFquVOl
8N6RAld6Q+ztgxo9RG4c
=UxSD
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_07_41_+1100_ZP22pmQAOFC9mt.R--
