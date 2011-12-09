Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1LIAsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:48:06 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52948 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LIAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:48:03 -0500
Date: Fri, 9 Dec 2011 11:47:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20111209114756.01851f07d9aac94a652320e5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_11_47_56_+1100_BoFh6fjbCBKtkf0t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_11_47_56_+1100_BoFh6fjbCBKtkf0t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/board-dt.c between commit afed2a261825 ("ARM: tegra2:
convert to CONFIG_MULTI_IRQ_HANDLER") from the arm tree and commit
0d4f74792e29 ("arm/tegra: convert tegra20 to GIC devicetree binding")
from the tegra tree.

I did the obvious fixup (see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-dt.c
index e417a83,2fa599d..0000000
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@@ -130,10 -150,8 +151,10 @@@ static const char * tegra_dt_board_comp
  DT_MACHINE_START(TEGRA_DT, "nVidia Tegra (Flattened Device Tree)")
  	.map_io		=3D tegra_map_common_io,
  	.init_early	=3D tegra_init_early,
- 	.init_irq	=3D tegra_init_irq,
+ 	.init_irq	=3D tegra_dt_init_irq,
 +	.handle_irq	=3D gic_handle_irq,
  	.timer		=3D &tegra_timer,
  	.init_machine	=3D tegra_dt_init,
 +	.restart	=3D tegra_assert_system_reset,
  	.dt_compat	=3D tegra_dt_board_compat,
  MACHINE_END

--Signature=_Fri__9_Dec_2011_11_47_56_+1100_BoFh6fjbCBKtkf0t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4Vq8AAoJEECxmPOUX5FEYf8P/RYJ4kVgch6/yp8G4/R1Enlr
F29wIaSq3la1mvs/1rrTCKl4zX0A1lbqhuYhkT3/s+cHZbH8kf0f06F07LEucuOx
aRAlpKDZ79fYG7iBLbKDyxU08sUSJdOYd7NmRDgfa3lhiB+WpN27JvFjoI9rKkjH
uiUAvr3Ie88mHKN7WAUCHqXhPWk5X/66qQpxjCOxmDzjjwo7yJor7zfReY9kKsPk
rzoSOY6qRAEuGlPq+9mW9wZER9OQc0ILnKCZgfN5OyErTrOhuq1lzb3a8DMnC9kL
a4bo1psP6mfvP4NQLdXScFNMGawiP6dc7+VyQKuzqt2V1RRvbgC1Oebuqy2p0yDf
uFogyy1H39P10g8vvwehQiU/wiRtLnCXY7d9xBP+AUlFBik4dOuIMW1P4cVgbG/7
aSmlMDtLtHwOz/hmWELuPfYGKonv3EfeGChQ5AdIhN8v5eqHBciDA8LX2GyWkGfl
WnayZa7hfLbD2Sq4wqU2CkpfZve75S6o8LdGZpdgUwsx9T1UMArWVrt7w/LdGF9A
ubQcKIUYfItdW4/02HpQ/bC4sJm6eaOm+L6WoeXmEpnS9rNyhBBKWXUeB5WjZTr+
Odhh7DyYicLsLydu2viRr0+wf911R7xAKhzbzO5c9QQqbDfGkLHw9GlQ62lBo/sX
EdP6ui7jkmx0YL2OKjbZ
=rKDt
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_11_47_56_+1100_BoFh6fjbCBKtkf0t--
