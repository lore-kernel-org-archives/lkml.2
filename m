Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1LIAry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:47:54 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45749 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LIArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:47:52 -0500
Date: Fri, 9 Dec 2011 11:47:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the  tree
Message-Id: <20111209114736.d418deb7228f2b544434b77b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_11_47_36_+1100_JwrdM/WY4Lt/x7uG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_11_47_36_+1100_JwrdM/WY4Lt/x7uG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/include/mach/entry-macro.S between commit
afed2a261825 ("ARM: tegra2: convert to CONFIG_MULTI_IRQ_HANDLER") from
the arm tree and commit f5ce5e7e9cc3 (arm/tegra: Remove code that's
ifndef CONFIG_ARM_GIC"") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/include/mach/entry-macro.S
index ac11262,485a11e..0000000
--- a/arch/arm/mach-tegra/include/mach/entry-macro.S
+++ b/arch/arm/mach-tegra/include/mach/entry-macro.S
@@@ -16,23 -24,10 +16,8 @@@
  	.macro	disable_fiq
  	.endm
 =20
 -	.macro	get_irqnr_preamble, base, tmp
 -	movw \base, #(ICTRL_BASE & 0x0000ffff)
 -	movt \base, #((ICTRL_BASE & 0xffff0000) >> 16)
 +	.macro	arch_ret_to_user, tmp1, tmp2
  	.endm
 =20
- #if !defined(CONFIG_ARM_GIC)
- 	/* legacy interrupt controller for AP16 */
-=20
- 	.macro	get_irqnr_preamble, base, tmp
- 	@ enable imprecise aborts
- 	cpsie	a
- 	@ EVP base at 0xf010f000
- 	mov \base, #0xf0000000
- 	orr \base, #0x00100000
- 	orr \base, #0x0000f000
- 	.endm
-=20
- 	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
- 	ldr \irqnr, [\base, #0x20]	@ EVT_IRQ_STS
- 	cmp \irqnr, #0x80
+ 	.macro  arch_ret_to_user, tmp1, tmp2
  	.endm
- #endif

--Signature=_Fri__9_Dec_2011_11_47_36_+1100_JwrdM/WY4Lt/x7uG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4VqoAAoJEECxmPOUX5FET8YQAJwweXMvnTJZmQU2GjtkWinD
I4e6UnFoVDWECFsTt2x7avcy459Fgis1DFQB5l0wSgIdPcTJbVvj5L/CRPyj+/Ti
HX9zmMdhzTF3kd2kcvsLLvU0q1S9kltgHYFnjku2QeGANjDj1XDeC0WDxiVHn1+F
9pRnlICrLOVLsw9S4f1AM8V9lw6hY2MPw/BOoPhWdWsDhIbiD/v/zymyR/cOR9FK
SKr9DGnwSGV6JG1cYl6/qr2I6RZC+qz4Rin9/Z53doqOMqeprc04qDGOmAcGUIEo
FDHhleBb2RJGYas/ZYPVgViwIdmxdBW/emW9hQj6y9v8s96pwr9/KHsUvhcLO5n+
7lrV3KDe9Xd/3IRTyoZUQoJryd1zsGCeyJugJPVckMpwumrFOYZHMvQvQ8m5sTiF
/8O0oUR5bhwIODFh8ku7JBbaXZaP1c0p3wC48BwmfMC4yWTGPecZejdxAOBBZ5Bp
jvaGVyvRrHlTQOhzIgWyRyxctg5We42+BSgIGV6FM90YkhTxMg3gnKdxFJP/MERY
8a7zdZBAafu7sfJfqAgvV58FHZUsYNLH+gN0p1ZJSQWRtY2e8O4f0Xu2ggSCYceQ
uTcT0TW8xIvOeyJTicvGFJ0KihQNhwhzZIib43g2HV51wPNpCsKfTw+k2MmUJ5lN
691FIJtr8+XEto4asZf6
=JrjN
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_11_47_36_+1100_JwrdM/WY4Lt/x7uG--
