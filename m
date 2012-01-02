Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2ABXe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:34:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52976 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2ABXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:34:25 -0500
Date: Tue, 3 Jan 2012 10:34:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Rajeshwari Shinde <rajeshwari.s@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120103103411.85d160181f361e73f11c401b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_10_34_11_+1100_xk==OsgiOJsUZcj1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_10_34_11_+1100_xk==OsgiOJsUZcj1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-s3c64xx/Makefile between commit b024043b6d0d ("ARM: 7245/1:
S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]") from the arm tree
and commits a60879e7ca17 ("ARM: SAMSUNG: Remove SDHCI bus clocks from
platform data"), 875a59374cd1 ("ARM: SAMSUNG: Consolidation of SPI
platform devices to plat-samsung") and 4566c7f7612f ("ARM: S3C64XX:
Modified files for SPI consolidation work") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/Makefile
index f37016c,d7d9bb5..0000000
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@@ -27,21 -26,21 +27,20 @@@ obj-$(CONFIG_PM)		+=3D pm.o irq-pm.o slee
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

--Signature=_Tue__3_Jan_2012_10_34_11_+1100_xk==OsgiOJsUZcj1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAj7zAAoJEECxmPOUX5FEOI0P/2DoL7HCYmDi+HDBR1rbIf9R
EqFu3O06HnVqVByrTDJoZEBE9NYBeys6nFQmDUcDndP+aH96rTQiUGRrisK/JYnP
htYO/9d2Z3Kv9X12x3eFnhBOESvGV0VXwuQuFCa4Ua0UuOq7e++5qKnnOqHrmVIH
vib3UEnCLevu0W2nAblB9nT1XdUpWd+tFF+o3ZVxZdeUZdnqPyKq1JLqTJH+SB+F
V8igKebDh4Pj3rmwooPZvi38cfp/OsqgMBiyBsc98Pc/7ddpYGoYsV91Vdms2MmA
etxs0yBBiKNZOPxnRqpAHbG4osXBstR+418kOEvIDxe4eCjmMnU08RjctGskB/YG
ZeBkLxUv9LvHv9gFAhY4yhoKt19kECCH33oPTwvXgC8pj+XyBr9wuzyCVkLUDvwl
1JZM+0zK8nwcnWQkdUlzyDBgCSytK5MFUJdFMLGhvA9Mq98ZzMNrvtQq1sUwfn9i
7pKhzsgkOnPH8bEU9R41oqx4xwAu/0GTZWijASovZ9ZyfF94oEQaDoo69xMeP4qJ
1+LBWPPXTJ5YRvVu7h4VMnjm7RakmpNPFCbB6Hlv5v5XirDzhgPLXaHf2SrdOG2S
Hd4kyUw6x5z8oNff7h2Q6ERbxZqLVr83jggOeMmBLA8JmAVtD8JaG5hb1Em5j2Cb
zmWDTNinr06jRTtNR4IZ
=iuPN
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_10_34_11_+1100_xk==OsgiOJsUZcj1--
