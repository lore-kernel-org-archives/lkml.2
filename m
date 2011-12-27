Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1L0XV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:21:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43643 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1L0XVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:21:25 -0500
Date: Wed, 28 Dec 2011 10:21:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajeshwari Shinde <rajeshwari.s@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228102119.8dcfafb5723172992bdab98c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_21_19_+1100_nBh73=hdy7xUSj36"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_21_19_+1100_nBh73=hdy7xUSj36
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5pv210/Makefile between commit 3fa754c298b7 ("ARM: 7248/1:
S5PV210: introduce arch/arm/mach-s5pv210/common.[ch]") from the arm tree
and commit a60879e7ca17 ("ARM: SAMSUNG: Remove SDHCI bus clocks from
platform data") from the s5p tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pv210/Makefile
index 4c59186,471df5d..0000000
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@@ -29,14 -27,12 +29,13 @@@ obj-$(CONFIG_MACH_TORBRECK)	+=3D mach-tor
  # device support
 =20
  obj-y				+=3D dev-audio.o
- obj-$(CONFIG_S3C64XX_DEV_SPI)	+=3D dev-spi.o
 =20
 +obj-y					+=3D setup-i2c0.o
  obj-$(CONFIG_S5PV210_SETUP_FB_24BPP)	+=3D setup-fb-24bpp.o
  obj-$(CONFIG_S5PV210_SETUP_FIMC)	+=3D setup-fimc.o
 -obj-$(CONFIG_S5PV210_SETUP_I2C1) 	+=3D setup-i2c1.o
 -obj-$(CONFIG_S5PV210_SETUP_I2C2) 	+=3D setup-i2c2.o
 +obj-$(CONFIG_S5PV210_SETUP_I2C1)	+=3D setup-i2c1.o
 +obj-$(CONFIG_S5PV210_SETUP_I2C2)	+=3D setup-i2c2.o
  obj-$(CONFIG_S5PV210_SETUP_IDE)		+=3D setup-ide.o
  obj-$(CONFIG_S5PV210_SETUP_KEYPAD)	+=3D setup-keypad.o
- obj-$(CONFIG_S5PV210_SETUP_SDHCI)	+=3D setup-sdhci.o
  obj-$(CONFIG_S5PV210_SETUP_SDHCI_GPIO)	+=3D setup-sdhci-gpio.o
+ obj-$(CONFIG_S5PV210_SETUP_SPI)		+=3D setup-spi.o

--Signature=_Wed__28_Dec_2011_10_21_19_+1100_nBh73=hdy7xUSj36
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+lLvAAoJEECxmPOUX5FE/BYP/2Z6ITf1ELBJgqGWWwcnKlf3
muWH0EzZgcBUNLDmZ6+V1p0VmpLNI+Fuv+Yjd7nEm+2lu0vB1R/doUBX/G5KJwcG
7W7ihn9by8+ItqnABY4y/mEK9x4P9OBkyMHyPx8sr/hhUb8BPrLQ34gztSDOMSZJ
TvsgJK+fbNaGDcAwYLiz8KhrjA+aXOrsehcOL3EwhQLodmM3XrXydd4tYnhaFP5g
wgsbLMG6KYjPdGFFDgj6N5Dw2wbeTf6YUXUJrkq4zVkETSbKAg0XwmyY6CwzSmEh
ZoyYcs78GKxexXwtPKKH2fsuXEVCutJ9YLsjbIjR68cnEQ00lA/Mep2vSDmaJd6i
SO5JA3jj3RThwRb9N48LmiPyTKN2VovrQHADGF0rLZj1OIZTTJ7T5oJMf/WRiyY3
s7hJwiSJgPcReQCFEMLc4PjdWuJfkO0Vxg04YA/U2lHQ1ALeTYbPHYaf+FToMntb
/PtEn+xztqJ6rGBqPedxF2BeMfacO8csFTVSGsWkk2Ir6llVhFSXiqETfkRagu9x
ldG7rNinRtZ4vknNmxeKNQUMPKrPjp2ZZvxiIv9qipvC2yRyjGkvsuJvXiwcWb9d
WSce0YclBKUL5D26TsQ42EBTq8v+2vds1Bm7yreOb/kDFO+3GZpbWYCttWl/1txQ
Lh4/LbD2/dSamCdzS3sC
=Ugl6
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_21_19_+1100_nBh73=hdy7xUSj36--
