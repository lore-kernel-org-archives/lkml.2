Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1KRDXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:23:06 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37734 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1KRDXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:23:02 -0500
Date: Fri, 18 Nov 2011 14:22:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rong Wang <Rong.Wang@csr.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the tty tree with the s5p tree
Message-Id: <20111118142259.f3e509297b2a0046bec6df88@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Nov_2011_14_22_59_+1100_jX1i1wJ4PoNBWUvV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Nov_2011_14_22_59_+1100_jX1i1wJ4PoNBWUvV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/Kconfig between commit 30fba06ac9eb ("serial: samsung:
merge probe() function from all SoC specific extensions") from the s5p tree
and commit 161e773cbd0c ("UART: add CSR SiRFprimaII SoC on-chip uart
drivers") from the tty tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/Kconfig
index d202c31,45c5758..0000000
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@@ -495,6 -495,68 +495,28 @@@ config SERIAL_SAMSUNG_CONSOL
  	  your boot loader about how to pass options to the kernel at
  	  boot time.)
 =20
 -config SERIAL_S3C2410
 -	tristate "Samsung S3C2410 Serial port support"
 -	depends on SERIAL_SAMSUNG && CPU_S3C2410
 -	default y if CPU_S3C2410
 -	help
 -	  Serial port support for the Samsung S3C2410 SoC
 -
 -config SERIAL_S3C2412
 -	tristate "Samsung S3C2412/S3C2413 Serial port support"
 -	depends on SERIAL_SAMSUNG && CPU_S3C2412
 -	default y if CPU_S3C2412
 -	help
 -	  Serial port support for the Samsung S3C2412 and S3C2413 SoC
 -
 -config SERIAL_S3C2440
 -	tristate "Samsung S3C2440/S3C2442/S3C2416 Serial port support"
 -	depends on SERIAL_SAMSUNG && (CPU_S3C2440 || CPU_S3C2442 || CPU_S3C2416)
 -	default y if CPU_S3C2440
 -	default y if CPU_S3C2442
 -	select SERIAL_SAMSUNG_UARTS_4 if CPU_S3C2416
 -	help
 -	  Serial port support for the Samsung S3C2440, S3C2416 and S3C2442 SoC
 -
 -config SERIAL_S3C6400
 -	tristate "Samsung S3C6400/S3C6410/S5P6440/S5P6450/S5PC100 Serial port su=
pport"
 -	depends on SERIAL_SAMSUNG && (CPU_S3C6400 || CPU_S3C6410 || CPU_S5P6440 =
|| CPU_S5P6450 || CPU_S5PC100)
 -	select SERIAL_SAMSUNG_UARTS_4
 -	default y
 -	help
 -	  Serial port support for the Samsung S3C6400, S3C6410, S5P6440, S5P6450
 -	  and S5PC100 SoCs
 -
 -config SERIAL_S5PV210
 -	tristate "Samsung S5PV210 Serial port support"
 -	depends on SERIAL_SAMSUNG && (CPU_S5PV210 || CPU_EXYNOS4210 || SOC_EXYNO=
S4212)
 -	select SERIAL_SAMSUNG_UARTS_4 if (CPU_S5PV210 || CPU_EXYNOS4210 || SOC_E=
XYNOS4212)
 -	default y
 -	help
 -	  Serial port support for Samsung's S5P Family of SoC's
 -
+ config SERIAL_SIRFSOC
+         tristate "SiRF SoC Platform Serial port support"
+         depends on ARM && ARCH_PRIMA2
+         select SERIAL_CORE
+         help
+           Support for the on-chip UART on the CSR SiRFprimaII series,
+           providing /dev/ttySiRF0, 1 and 2 (note, some machines may not
+           provide all of these ports, depending on how the serial port
+           pins are configured).
+=20
+ config SERIAL_SIRFSOC_CONSOLE
+         bool "Support for console on SiRF SoC serial port"
+         depends on SERIAL_SIRFSOC=3Dy
+         select SERIAL_CORE_CONSOLE
+         help
+           Even if you say Y here, the currently visible virtual console
+           (/dev/tty0) will still be used as the system console by default=
, but
+           you can alter that using a kernel command line option such as
+           "console=3DttySiRFx". (Try "man bootparam" or see the documenta=
tion of
+           your boot loader about how to pass options to the kernel at
+           boot time.)
+=20
  config SERIAL_MAX3100
  	tristate "MAX3100 support"
  	depends on SPI
@@@ -1527,13 -1589,22 +1549,22 @@@ config SERIAL_PCH_UAR
  	  which is an IOH(Input/Output Hub) for x86 embedded processor.
  	  Enabling PCH_DMA, this PCH UART works as DMA mode.
 =20
 -	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
 -	  Output Hub), ML7213 and ML7223.
 -	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
 -	  for MP(Media Phone) use.
 -	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
 -	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 +	  This driver also can be used for LAPIS Semiconductor IOH(Input/
 +	  Output Hub), ML7213, ML7223 and ML7831.
 +	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use, ML7223 IOH is
 +	  for MP(Media Phone) use and ML7831 IOH is for general purpose use.
 +	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
 +	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 =20
+ config SERIAL_PCH_UART_CONSOLE
+ 	bool "Support for console on Intel EG20T PCH UART/OKI SEMICONDUCTOR ML72=
13 IOH"
+ 	depends on SERIAL_PCH_UART=3Dy
+ 	select SERIAL_CORE_CONSOLE
+ 	help
+ 	  Say Y here if you wish to use the PCH UART as the system console
+ 	  (the system  console is the device which receives all kernel messages =
and
+ 	  warnings and which allows logins in single user mode).
+=20
  config SERIAL_MSM_SMD
  	bool "Enable tty device interface for some SMD ports"
  	default n

--Signature=_Fri__18_Nov_2011_14_22_59_+1100_jX1i1wJ4PoNBWUvV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOxc+TAAoJEECxmPOUX5FE2mEQAKDY/0t34GMm5icIb06dtDm8
6d1KvNBFuRXTCN/FAhAHDWaJeNyinweuFoK/p+icgukURwQYFWEyiOgE2JvWNrut
jd1+JX7U7bZsbxTTEAK0KQtnDw2ILOAgtTQHR1yXjTUZrhMar88RHaVRCRiwrKdQ
9VhXPEDjF+aUfEx+B4JMrK8XKmFx2556MhAMVFGsFPBaHhCjnuzLihNNeQBzmOvZ
v8Q5PsDaWyoJWsL6qpCoTrAgEXm3OSkm4KjTjbI6PXd0bvuhlUQ6uEQyTZz+3OBI
RcfIZfDe8Fnbu06I2CK0xgJrDQB81ADxJcdIj5oJ/eLXm6gpbsueAMaTPd9XiFix
QXjV/6vBRR4Bjo0xO48cXyQctUetyPtRqQaYvc0T6Z2mgWIbMtRt0ZKvd3a1rzxJ
zBfwpTSCfTrmNyyFmLZB7HzeWfzNyIPjKn8MVO+wrzFhHXDQnia0lYPe/sPBfv/2
aBcnh7t/6C9DDNPzt/WXHDxEBaak3k0sO0L9xqNcMmyttzwrFBf0Hc5xIEleOUvo
EN4VvKpzyS3C9S6dCRBuGDB7YLdR18nDHD0HkSzJAT8p4mVQdgFg4hKSPJ3SqI9V
qoMccKnGhY0vfvknW/BL+6cA5f4CS/RAaQa9CoNicePBA/pmu+0JCxuW9xRXB6TM
rVCcDutDtRBUFRdubbtp
=nzbT
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Nov_2011_14_22_59_+1100_jX1i1wJ4PoNBWUvV--
