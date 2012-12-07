Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424128Ab2LGDYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:24:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58133 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423892Ab2LGDYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:24:24 -0500
Date: Fri, 7 Dec 2012 14:24:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei WANG <wei_wang@realsil.com.cn>, Tony Prisk <linux@prisktech.co.nz>,
        Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the mfd tree with the mmc tree
Message-Id: <20121207142414.1a32366ca5390ea9aa323bfa@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Dec_2012_14_24_14_+1100_RbCSfpErfrRpb.E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Dec_2012_14_24_14_+1100_RbCSfpErfrRpb.E8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mmc/host/Kconfig between commit 3a96dff0f828 ("mmc: SD/MMC Host
Controller for Wondermedia WM8505/WM8650") from the mmc tree and commit
ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver") from the mfd
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/Kconfig
index 83eb1e0,dfa6d56..0000000
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@@ -602,13 -622,9 +602,20 @@@ config MMC_USH
  	  Note: These controllers only support SDIO cards and do not
  	  support MMC or SD memory cards.
 =20
 +config MMC_WMT
 +	tristate "Wondermedia SD/MMC Host Controller support"
 +	depends on ARCH_VT8500
 +	default y
 +	help
 +	  This selects support for the SD/MMC Host Controller on
 +	  Wondermedia WM8505/WM8650 based SoCs.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called wmt-sdmmc.
++
+ config MMC_REALTEK_PCI
+ 	tristate "Realtek PCI-E SD/MMC Card Interface Driver"
+ 	depends on MFD_RTSX_PCI
+ 	help
+ 	  Say Y here to include driver code to support SD/MMC card interface
+ 	  of Realtek PCI-E card reader

--Signature=_Fri__7_Dec_2012_14_24_14_+1100_RbCSfpErfrRpb.E8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQwWFeAAoJEECxmPOUX5FEracP/20j2BgwFPaWVYJmA2zx5Zha
MMSqEAZ75MaQVce/6jB9ux6dB88p+L1v5ZQPgo6dQZV8m78DtjHk+sQMpZHzc67v
oeJU5/91OxTfqXdQuIHWZHchsmzaipmgOFabyeSKcqGIqko2tdS5JlIhwGPQqW7M
ZX6BVasW4bRr2OaC6bhhwkuo3P4R2nHIkHEfPropy5RG+WCIbecJhjXWFs9zgYl0
Rgu226zKQl9FQBgcT3fXWS9I2Zp8/dThfGIjxhxDbzzm0HEcxTLW2MNT0oIoEqJf
RsVufcIdGUsDvkTASELRfrpCSKmwCS8/gxMTBPCH74iJVpFC2+c411A/hvdv4E5G
evM6C9cyLKsdNuppbLwiUIF3mmGLd2x/QofSb6mTtxwJ0aNfXEPV2jTL17mSeKx5
YxJJo5h6M4ktYoy/qNWK+C3gffF2IXqMbkS2ObEDK7zQRp+YVcM79s1wovt8b+YM
uW0mXk3sNn1cvglgsRdIcWG34Jz5o4nWqh4uyCZF/ZufNhB0aYv5VoBdxNCzXbE1
znNK9anshrRtiButhPMfSv+Gw88O5VFC4y3HWKoLqMi6yoGBPyvtFRhggr6sBMGH
zZT8i+KTYddSQ4gEemQvjOZnnLtgj13CvEiSL0+MzrK0XPJjym0+mHYoyfmaV0dE
buH/nXg1/F8wT37ylmrS
=MeZk
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Dec_2012_14_24_14_+1100_RbCSfpErfrRpb.E8--
