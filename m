Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1LSAPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:15:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40942 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LSAO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:14:58 -0500
Date: Mon, 19 Dec 2011 11:14:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20111219111451.057769e7a43a5ba499b092ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_11_14_51_+1100_bVV69X5c84Pyr5+R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_11_14_51_+1100_bVV69X5c84Pyr5+R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/board-dt-tegra20.c (called
arch/arm/mach-tegra/board-dt.c in the arm tree) between commit
b8a0b3079c03 ("ARM: restart: tegra: use new restart hook") from the arm
tree and commit c37c07ddf269 ("arm/tegra: prepare early init for multiple
tegra variants") from the tegra tree.

Just context change. I fixed it up (see below) and can carry the fix as nec=
essary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-dt-tegra20.c
index e417a83,ddaa037..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@@ -134,6 -144,5 +144,6 @@@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegr
  	.handle_irq	=3D gic_handle_irq,
  	.timer		=3D &tegra_timer,
  	.init_machine	=3D tegra_dt_init,
 +	.restart	=3D tegra_assert_system_reset,
- 	.dt_compat	=3D tegra_dt_board_compat,
+ 	.dt_compat	=3D tegra20_dt_board_compat,
  MACHINE_END

--Signature=_Mon__19_Dec_2011_11_14_51_+1100_bVV69X5c84Pyr5+R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7oH7AAoJEECxmPOUX5FEcKoP/28Nb/guCjHFPHQEjj6WQYW1
47PMGXpQAMxnrYit9JwGOWFBo8WXmSKSDL0SvfDaN3QtbQoNxE1vgBYT4N4NvAxZ
7iw0AADlArfShplDl2tyRUjSBmElFyoKSDeJZrhiv2mlbE74OFNzpmWfVGnav8K8
KIDY+1OTob/ysSJzt2Z8zeoIpl19nxqf4gjXM379vBABjVpiMWSV/w6V7gSEnlrY
tTxNxjXuegJ1147IzrucpPdl+wnKIO+dvmdhOUjK9VAZWtISlyITA/dYLZuRYr3g
5UpAXuAhOxlUNukpEMDg2aAFnFKiyPt3EYGbo/X7A1VGUY6djEDf1V2P2BwkQes3
WSmk8sES4vKar/bSp/JO1oWkAlyhpjzb63sdnYYD5WrG+EidvdWOHMJt05HlcKIt
0KpMJ2Wy+GrvF8L/S6CFUyp1p2L1UCQUXyue1KoGE8RmHqT0LcmzNGDJoFXB5gB2
+nPNrp4h5XoG6FYs4lcsPPjutgNUvwphWX8XbW4wf1H6+OUkIo3ZDF9nfqadR19r
Kfm0/uxxTKI2deeBzznUY0zKX8owcWK7LsFf0pN2POCP6j9T/uY2ggEwAEG/NbeE
5SapOj5+9/f6a6SjBVEn8ipaPjB6RSlO2X5+m1WKIxKKITVpkb2wvX0LVpmALj+M
R7k0JKBt9B3vA7RRnLHJ
=pP8H
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_11_14_51_+1100_bVV69X5c84Pyr5+R--
