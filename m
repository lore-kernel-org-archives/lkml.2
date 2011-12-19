Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LSAPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:15:05 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59407 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LSAPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:15:01 -0500
Date: Mon, 19 Dec 2011 11:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20111219111459.67d611cbd0844bc434597883@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_11_14_59_+1100_Ok9v0t8m6oiiUGU3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_11_14_59_+1100_Ok9v0t8m6oiiUGU3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/common.c between commit b8a0b3079c03 ("ARM: restart:
tegra: use new restart hook") from the arm tree and commit c37c07ddf269
("arm/tegra: prepare early init for multiple tegra variants") from the
tegra tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/common.c
index 20f396d,8911e62..0000000
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@@ -31,14 -33,26 +33,24 @@@
  #include "clock.h"
  #include "fuse.h"
 =20
 -void (*arch_reset)(char mode, const char *cmd) =3D tegra_assert_system_re=
set;
 -
+ static const struct of_device_id tegra_dt_irq_match[] __initconst =3D {
+ 	{ .compatible =3D "arm,cortex-a9-gic", .data =3D gic_of_init },
+ 	{ }
+ };
+=20
+ void __init tegra_dt_init_irq(void)
+ {
+ 	tegra_init_irq();
+ 	of_irq_init(tegra_dt_irq_match);
+ }
+=20
  void tegra_assert_system_reset(char mode, const char *cmd)
  {
- 	void __iomem *reset =3D IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
+ 	void __iomem *reset =3D IO_ADDRESS(TEGRA_PMC_BASE + 0);
  	u32 reg;
 =20
- 	/* use *_related to avoid spinlock since caches are off */
  	reg =3D readl_relaxed(reset);
- 	reg |=3D 0x04;
+ 	reg |=3D 0x10;
  	writel_relaxed(reg, reset);
  }
 =20

--Signature=_Mon__19_Dec_2011_11_14_59_+1100_Ok9v0t8m6oiiUGU3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7oIDAAoJEECxmPOUX5FENdAP/1askjkNGYwiIdp/DVBBi1nG
VDzvfYuKnIIrSXVbw+p0azRQQAa1WR9ZTpRDa1Get8+BymCWJoGkS+6+zxrYHH0w
IbQ9G22KvIQNK0wiMbi3P20oZYLncLxSHnKFFbRC8Umd86VYNaXNpD6pbit2WvyO
y0wAvB4BZlQduR2VDzBhKppehDAZM0pmuNB82B77MgPkCo0NB/4jXtzvHWmjQSxI
YoB81TgoAqlFzszThuPr2j4DtRxmvYHfccM66kA3n0Bt5oY8pfSXUQRWlBJJPvQ/
G1J90iyqc5b97hG0868zjzlwP7szFSgWvBOiaL+49EYXLjdPt+TQFK/Tt3ssU1jq
1gcXxglh90wBrhHpd5PrwanV578T3mIHbQkVtevvbKcExf7bGYH23zjK6hHK7pBW
rgDnHmV2jsAsol59eGHGm2VGolpSagRKEH2Lcuxj91LkIw+I4vJaGFZjSJVVWPjz
i1PoUEIlEIEjNhU/YP0nVcI6DDiyoGtl1uijrVtrtR4jFSTyn8LqcdPhaKEF+WbZ
RZsITQSeXKeffVyW5wrcBhGoHKXE/cLrWLhwdPBBUp1+HySEfP5+uix5fyw8lC2C
dQNRfKV8EwG10C57bmszNqXYrBKfcyhhk9zqyIBDZAG8OeFOzeSL6U4TdwzIoH8n
HMYigFRwbdTkDxyTBrnX
=Du3Q
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_11_14_59_+1100_Ok9v0t8m6oiiUGU3--
