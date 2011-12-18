Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1LRXzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:55:52 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58329 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1LRXzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:55:49 -0500
Date: Mon, 19 Dec 2011 10:55:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111219105537.6c3346b5ed94fccd486ba136@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_10_55_37_+1100_b34nRw1.ea/V2h5I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_10_55_37_+1100_b34nRw1.ea/V2h5I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-ti8168evm.c between commit fae51fbd5b0b ("ARM:
restart: omap: use new restart hook") from the arm tree and commit
a890b6760d97 ("ARM: OMAP: TI814X: Create board support and enable build
for TI8148 EVM") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-ti8168evm.c
index 74713e3,5b6ad6e..0000000
--- a/arch/arm/mach-omap2/board-ti8168evm.c
+++ b/arch/arm/mach-omap2/board-ti8168evm.c
@@@ -43,10 -47,19 +47,21 @@@ static void __init ti81xx_evm_init(void
  MACHINE_START(TI8168EVM, "ti8168evm")
  	/* Maintainer: Texas Instruments */
  	.atag_offset	=3D 0x100,
- 	.map_io		=3D ti8168_evm_map_io,
- 	.init_early	=3D ti816x_init_early,
- 	.init_irq	=3D ti816x_init_irq,
+ 	.map_io		=3D ti81xx_map_io,
+ 	.init_early	=3D ti81xx_init_early,
+ 	.init_irq	=3D ti81xx_init_irq,
+ 	.timer		=3D &omap3_timer,
+ 	.init_machine	=3D ti81xx_evm_init,
++	.restart	=3D omap_prcm_restart,
+ MACHINE_END
+=20
+ MACHINE_START(TI8148EVM, "ti8148evm")
+ 	/* Maintainer: Texas Instruments */
+ 	.atag_offset	=3D 0x100,
+ 	.map_io		=3D ti81xx_map_io,
+ 	.init_early	=3D ti81xx_init_early,
+ 	.init_irq	=3D ti81xx_init_irq,
  	.timer		=3D &omap3_timer,
- 	.init_machine	=3D ti8168_evm_init,
+ 	.init_machine	=3D ti81xx_evm_init,
 +	.restart	=3D omap_prcm_restart,
  MACHINE_END

--Signature=_Mon__19_Dec_2011_10_55_37_+1100_b34nRw1.ea/V2h5I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7n15AAoJEECxmPOUX5FEyYUP+gNO8pdiOPI9T+AblVP3npIF
YxTkX3N0BDmHIbKt7YyzAFltsmOcoxjH/VEyjAVqGcxOWxtPyub+XB9uRsRBkQRQ
ObH6qc28AUA9qApqywk3DVSPNJT3HoyhPAToZF0VwjmjSfbNnE9J4OabsQDXLdVn
IXvocYHAREow9u2RS9fSulTfnxjOEnZuiR125eLgdTlIoCJ4Eug6nfbmf8g2BV8A
vO+nMTKBWCgjQJ11b9xfr7GE6/CcYcAVO8IjF2z8/SR/gPaZ1d7AGOSElvcIL++K
Qk79SOjaOGbk5k506yIp0jbO4FaNWb/hCzdsOB3SNVPTm/ScjZy+I1Ybdqh1LKeU
WC8KFrWRkElgnsWEtOLZG8yFuhHquZ9GEXdlYvspX0FdoHlmnuP9e5drvBGQzuLr
EPmvN/kVCkGu64VCEZAoYKdGGQmRobuHn0nOpv0O9etukE4+Ltb49cF5rPSyTfpo
jSQlLemqrg6NRqGqM+Sf/dNrH6WTGLFoUFdoP7f4KcnimYPTbPM34ECJSRMwrqvP
inthq1oUzwzg5FhQeYBKqM/aYmFiOcgi58uyNa9qLuhTM5Gwt21EglIjmG6DEnOh
kVN3c+FwEzlPAvYYZXMAFfikQx1TAx4h2V55fU1RcroX6n+B/GUJzAe5oK+RDkD2
B0J1Uvyr5n5AKaY04oUJ
=YM/8
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_10_55_37_+1100_b34nRw1.ea/V2h5I--
