Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2CFGVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:21:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33404 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2CFGVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:21:45 -0500
Date: Tue, 6 Mar 2012 17:21:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Fabio Estevam <festevam@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20120306172130.f5b7aae24600cbbbaf7e84e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_17_21_30_+1100_lNZaOT1JT9_gRtme"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_17_21_30_+1100_lNZaOT1JT9_gRtme
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-imx/mm-imx3.c between commit 3bc34a614335 ("ARM: imx:
convert audmux to a platform driver") from the sound-asoc tree and commit
bb07d7511e08 ("ARM: mx3: Setup AIPS registers") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mm-imx3.c
index 9c9b7f9,17963e0..0000000
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@@ -177,8 -175,9 +179,12 @@@ void __init imx31_soc_init(void
  	}
 =20
  	imx_add_imx_sdma("imx31-sdma", MX31_SDMA_BASE_ADDR, MX31_INT_SDMA, &imx3=
1_sdma_pdata);
+=20
+ 	imx_set_aips(MX31_IO_ADDRESS(MX31_AIPS1_BASE_ADDR));
+ 	imx_set_aips(MX31_IO_ADDRESS(MX31_AIPS2_BASE_ADDR));
++
 +	platform_device_register_simple("imx31-audmux", 0, imx31_audmux_res,
 +					ARRAY_SIZE(imx31_audmux_res));
  }
  #endif /* ifdef CONFIG_SOC_IMX31 */
 =20

--Signature=_Tue__6_Mar_2012_17_21_30_+1100_lNZaOT1JT9_gRtme
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVazqAAoJEECxmPOUX5FEVggP/RknKrC99ouqe/XJMD4vCR20
GORc2vQXnpxZTHAAvASV3qIezECMwlkpBQNQro2IPtxBl2LyA5DeeKOzNaI8AlJ2
c4+lTHekMeMOOJItyjQpnb2kyc/psI5E62fIybfqVDiRt+RVViRF9aVlqNrUxFRr
igg9Or1gLX5OyI/xPFAcTNx+KSiU7d0412ruIn418ui5rrcIOsc5CGMYi3qlVSaT
TKQ3aJFv8x89U8OyIcQrhLNQPd6y56T2D5HHz8bhhB6InKZ48bSnNw/silXiNXsg
zhXoxiLDnSgv3O21sM7Pq1uK798pofdPEbPre56vpcO7zFzKeqq9dFd2tqtqyhaB
6xEQGBquPcEl6RxHf5xC3rwWj5gRpiK+ixZqT9Tl3QMvneMTgVTexzfHGbAcrqzo
Xi7X15CIOBQCz07VxwPv5NbMfLiOtmqnOrsJ/Nbz4cFBEHzAJNSbAWCKpw01ykeE
/x6MKEeO5drfmlaTDOCD0whikkdEOy37+Dy7bhg/k7CQ9AGpnJt0H2+olcvIpg+6
l0Iog8ojfZx/pPnuNCUik0oRwG0JgZ7hYvx7wcrrIAHZ1Qyy3JHaZdRrUPPpsf9P
I0r04PBPjCrAQf19TEtJvPf51IZMNsutCtonlnvZx6WVG45IG/ZM+4+pOKQf83M7
dFDK+PRc4p/ede5RvYYi
=RhP/
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_17_21_30_+1100_lNZaOT1JT9_gRtme--
