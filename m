Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab2DLEC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:02:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56937 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2DLECZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:02:25 -0400
Date: Thu, 12 Apr 2012 14:02:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the arm-soc tree with the mmc tree
Message-Id: <20120412140206.704731281bf2ee7d93d582bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_14_02_06_+1000_IEfsyftxLM7A2z8R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_14_02_06_+1000_IEfsyftxLM7A2z8R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mmc/host/Kconfig between commit a334b9550294 ("mmc: remove imxmmc
driver") from the mmc tree and commits a21a92c0c787 ("mmc: Kconfig: remove
choice between at91_mci and atmel-mci") and 62080f06de6b ("mmc:
atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/Kconfig
index 9f1f5e2,4d15dff..0000000
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@@ -295,18 -288,16 +288,6 @@@ config MMC_ATMELMC
 =20
  	  If unsure, say N.
 =20
- endchoice
-=20
- config MMC_ATMELMCI_DMA
- 	bool "Atmel MCI DMA support"
- 	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
- 	help
- 	  Say Y here to have the Atmel MCI driver use a DMA engine to
- 	  do data transfers and thus increase the throughput and
- 	  reduce the CPU utilization.
-=20
- 	  If unsure, say N.
-=20
 -config MMC_IMX
 -	tristate "Motorola i.MX Multimedia Card Interface support"
 -	depends on ARCH_MX1
 -	help
 -	  This selects the Motorola i.MX Multimedia card Interface.
 -	  If you have a i.MX platform with a Multimedia Card slot,
 -	  say Y or M here.
 -
 -	  If unsure, say N.
 -
  config MMC_MSM
  	tristate "Qualcomm SDCC Controller Support"
  	depends on MMC && ARCH_MSM

--Signature=_Thu__12_Apr_2012_14_02_06_+1000_IEfsyftxLM7A2z8R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhlO+AAoJEECxmPOUX5FEkogQAIwzdu2ZnmLycpnFwyXTy09q
bEwrFwdTKnvlN9Oq6/PaWgau640/IWtosG0Hx1g5J+tFpRLAOB1YLXxRTkpkaZOm
DHF1Vrp9DQXw4wEY8w+LDa0S1Wq1a0cal+w6Zd6BOti629GVSSPQvMffFIHogFhd
Er94AuCSaDLU9bSjmdH3/jt3wV9p62nPGn2BNKdPntn8K972Lyw1/srHV7vF3GJP
7+8urryjDyQ23Uj4eYcIfDORQLT9RwL1igb+Q5EMzy99boRsLQC+Q0IIIBbhAoT/
IWyjz3+JoNC38OkaEg/2ej/De6hFXBHWNKQ9s6L+I3BgJ5Vi6mzHqjgpGWKBrggJ
v1i13rEYZ9QQJfAFc9mBXajwwUz8NbDM2rBM0ua9hZqYpuqu125RaRnmvmpd7kMv
6nN0sYPQT0g6LMWSSegMWo5wgCv3ZuT1d0cMYXkz2s1hTBmeREAPJXap16tMI+do
PYwVFtR8SQOxNLqiO30xckJLEpQdigvViJhgjcT1fpA1d7FfdcWKq+Py7C02AwqO
hBSds8bCfXphYQtruNhkttLeZ45k1DaPuVyOOnygy/864AYURaitbOnDkXzftWfw
vL+pLtELojMFC0v0vhGfe3ENFPs/ViKWOi1fHep99Jn86CPu+YndmvVqRRHqPPUb
eehmg9ilmPHeJ/x2q3Gg
=jSNa
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_14_02_06_+1000_IEfsyftxLM7A2z8R--
