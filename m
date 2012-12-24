Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2LXBrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 20:47:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58434 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2LXBrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 20:47:21 -0500
Date: Mon, 24 Dec 2012 12:47:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <Baohua.Song@csr.com>
Subject: linux-next: manual merge of the pinctrl tree with the
 driver-core.current tree
Message-Id: <20121224124708.b0fb53a402f2a4bfdfece9c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_12_47_08_+1100_AbTvj0S=KGKX_X0y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_12_47_08_+1100_AbTvj0S=KGKX_X0y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/pinctrl-sirf.c between commit c2c57b329c7b ("Drivers:
pinctrl: remove __dev* attributes") from the driver-core.current tree and
commit 19d601d8e0a7 ("pinctrl: sirf: enable GPIO pullup/down
configuration from dts") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

diff --cc drivers/pinctrl/pinctrl-sirf.c
index c776046,30e1a38..0000000
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@@ -1663,7 -1663,45 +1663,45 @@@ const struct irq_domain_ops sirfsoc_gpi
  	.xlate =3D irq_domain_xlate_twocell,
  };
 =20
+ static void sirfsoc_gpio_set_pullup(const u32 *pullups)
+ {
+ 	int i, n;
+ 	const unsigned long *p =3D (const unsigned long *)pullups;
+=20
+ 	for (i =3D 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
+ 		n =3D find_first_bit(p + i, BITS_PER_LONG);
+ 		while (n < BITS_PER_LONG) {
+ 			u32 offset =3D SIRFSOC_GPIO_CTRL(i, n);
+ 			u32 val =3D readl(sgpio_bank[i].chip.regs + offset);
+ 			val |=3D SIRFSOC_GPIO_CTL_PULL_MASK;
+ 			val |=3D SIRFSOC_GPIO_CTL_PULL_HIGH;
+ 			writel(val, sgpio_bank[i].chip.regs + offset);
+=20
+ 			n =3D find_next_bit(p + i, BITS_PER_LONG, n + 1);
+ 		}
+ 	}
+ }
+=20
+ static void sirfsoc_gpio_set_pulldown(const u32 *pulldowns)
+ {
+ 	int i, n;
+ 	const unsigned long *p =3D (const unsigned long *)pulldowns;
+=20
+ 	for (i =3D 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
+ 		n =3D find_first_bit(p + i, BITS_PER_LONG);
+ 		while (n < BITS_PER_LONG) {
+ 			u32 offset =3D SIRFSOC_GPIO_CTRL(i, n);
+ 			u32 val =3D readl(sgpio_bank[i].chip.regs + offset);
+ 			val |=3D SIRFSOC_GPIO_CTL_PULL_MASK;
+ 			val &=3D ~SIRFSOC_GPIO_CTL_PULL_HIGH;
+ 			writel(val, sgpio_bank[i].chip.regs + offset);
+=20
+ 			n =3D find_next_bit(p + i, BITS_PER_LONG, n + 1);
+ 		}
+ 	}
+ }
+=20
 -static int __devinit sirfsoc_gpio_probe(struct device_node *np)
 +static int sirfsoc_gpio_probe(struct device_node *np)
  {
  	int i, err =3D 0;
  	struct sirfsoc_gpio_bank *bank;

--Signature=_Mon__24_Dec_2012_12_47_08_+1100_AbTvj0S=KGKX_X0y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ17QcAAoJEECxmPOUX5FE6ugP/ifbTqpuBETuNFjPfLUveB46
QiqiUbeakek6tzJWSYCBURt6V9pS2VKNV1xWjdQXN4ZCfpq7gZGJEe2nlWaVoqkP
rs4rvsTnerLq+qvfq/0OfRUV8eUTNataIMmV9q/MQOIREaAdYJ0UrAs8DRR6X1bD
SyUVOUb2zu2QF8gGGbU/k2ollv1tMyoaTS2oUBTDl7umUSi3bLT3GZA5eqM1DEia
JVd1J5KJJQuLc3hOnh9TXLonDCHt1zh7fom9M85x4Pfp2Nl/KTtpnLFqaxYhiBi8
hviyIOVS9xP/vx03Ha/WXJ71ZLHO8zTI1zHh8kjlPW5zpWwEcIeTE+WZTKLXtt4F
Lg82am8YQG6eWlfrYpusz64odYwQE9QEAe/OGyGHoeISWNFpJWNwPpXtfHYxAIpu
V+QSDm2AZSi2FK1NDn8vf/M9XYSHR6eatrA0Ew14yifTq5niWt244Z0NBWOiPsr3
MdYdiBhnbk6fC32a5GDYeyoSt74LyiV4Aiu1cdiEirjChsRo4SdmfnKDvC6cQVRk
Iq/EmRE6HZyQgT1tBDZ60lEu1bmBakfCOYcLUQoEVNiO7HtSbfjvV3r5wCM3zB5w
gjHzl+cAznocCk+kEwrdk+mTVeW1aZZkjn4Uu3OPDaqB4tkzSkzulF+owvLPuq+f
vOnXMh6qLmtKrp+9kziN
=rgJi
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_12_47_08_+1100_AbTvj0S=KGKX_X0y--
