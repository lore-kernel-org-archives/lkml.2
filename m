Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab1IIBk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:40:27 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38537 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab1IIBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:40:25 -0400
Date: Fri, 9 Sep 2011 11:40:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the i.MX tree with the arm-soc tree
Message-Id: <20110909114016.4a2a35295d3c84e37663289e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Sep_2011_11_40_16_+1000_3/Y31xayE2YNSKlq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Sep_2011_11_40_16_+1000_3/Y31xayE2YNSKlq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

Today's linux-next merge of the i.MX tree got a conflict in
arch/arm/mach-imx/Makefile between commit 91dc67d94810 ("Merge branch
'next/devel' of
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc
into for-next") from the arm-soc tree and commit ea754946551b ("Merge
branch 'imx-features' and 'imx-cleanup' into master") from the i.MX tree.

The conflict looks like this:

diff --cc arch/arm/mach-imx/Makefile
index f87cc55,d22096a..0000000
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@@ -3,7 -3,7 +3,11 @@@ obj-$(CONFIG_IMX_HAVE_DMA_V1) +=3D dma-v1
  obj-$(CONFIG_SOC_IMX1) +=3D clock-imx1.o mm-imx1.o
  obj-$(CONFIG_SOC_IMX21) +=3D clock-imx21.o mm-imx21.o
 =20
++<<<<<<< HEAD
 +obj-$(CONFIG_SOC_MX25) +=3D clock-imx25.o mm-imx25.o ehci-imx25.o cpu-imx=
25.o
++=3D=3D=3D=3D=3D=3D=3D
+ obj-$(CONFIG_SOC_IMX25) +=3D clock-imx25.o mm-imx25.o ehci-imx25.o cpu-im=
x25.o
++>>>>>>> i.MX/for-next
 =20
  obj-$(CONFIG_SOC_IMX27) +=3D cpu-imx27.o pm-imx27.o
  obj-$(CONFIG_SOC_IMX27) +=3D clock-imx27.o mm-imx27.o ehci-imx27.o

Given that there are no other references to SOC_MX25 in the resulting
tree, I used the latter version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Sep_2011_11_40_16_+1000_3/Y31xayE2YNSKlq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOaW6AAAoJEDMEi1NhKgbsVu0H/itXpNP15faXPnTOeRMgAjRH
KHrS0uX5AtXwp9nuw2GuHkuf8By4He4we8x+kLrVMgsqR8iOOh77lVLfild0ITsN
WyzzWgQcd+Q6dZjDP0NRnxg3mzi7xrk7ML5v8Z4t1wWPPUgKLbUozdWieHVruMh2
3142Z/d1W6pe3PXtAP2wdUDAZ15YIAyE5+zsY93XilwKoJ9sBnw2ZG6HGn0M8zBk
yq1kT96GmtcDpVoznsxY5tF3jwM4c5s2PSkdlYK6GcbCcDb8miZKENyvS7yb8l9P
OTGcBmGHdVMBYFIXFrhmjKx0boCzW+o6ClynVW4kBULOUexSCbXt3jNZ3APIgv8=
=2rCf
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Sep_2011_11_40_16_+1000_3/Y31xayE2YNSKlq--
