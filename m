Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2IGD3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:29:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43593 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab2IGD3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:29:21 -0400
Date: Fri, 7 Sep 2012 13:29:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: linux-next: manual merge of the omap_dss2 tree with Linus' tree
Message-Id: <20120907132912.dc29219f9ae62b7befbd7401@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Sep_2012_13_29_12_+1000_oa6UKWTBBrdevla5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Sep_2012_13_29_12_+1000_oa6UKWTBBrdevla5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in drivers/vi=
deo/omap2/dss/sdi.c between commit 35d678664873 ("OMAPDSS: Fix SDI PLL lock=
ing") from Linus' tree and commit 889b4fd7eed2 ("OMAPDSS: SDI: Maintain cop=
y of data pairs in driver data") from the omap_dss2 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary (no action is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/dss/sdi.c
index f43bfe1,3bf1bfe..0000000
--- a/drivers/video/omap2/dss/sdi.c
+++ b/drivers/video/omap2/dss/sdi.c
@@@ -105,21 -107,8 +107,22 @@@ int omapdss_sdi_display_enable(struct o
 =20
  	sdi_config_lcd_manager(dssdev);
 =20
 +	/*
 +	 * LCLK and PCLK divisors are located in shadow registers, and we
 +	 * normally write them to DISPC registers when enabling the output.
 +	 * However, SDI uses pck-free as source clock for its PLL, and pck-free
 +	 * is affected by the divisors. And as we need the PLL before enabling
 +	 * the output, we need to write the divisors early.
 +	 *
 +	 * It seems just writing to the DISPC register is enough, and we don't
 +	 * need to care about the shadow register mechanism for pck-free. The
 +	 * exact reason for this is unknown.
 +	 */
 +	dispc_mgr_set_clock_div(dssdev->manager->id,
 +			&sdi.mgr_config.clock_info);
 +
- 	dss_sdi_init(dssdev->phy.sdi.datapairs);
+ 	dss_sdi_init(sdi.datapairs);
+=20
  	r =3D dss_sdi_enable();
  	if (r)
  		goto err_sdi_enable;

--Signature=_Fri__7_Sep_2012_13_29_12_+1000_oa6UKWTBBrdevla5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSWoIAAoJEECxmPOUX5FEENkP/33U0Ru1p2obYwdDmFvadOIU
7A78NDAtug0HdoK7cMb1kKeO3DBeAHvP81/kKhPRvv41C3GQXxrB+mER6c4sUWSI
e/rTgtsaGzoaLyIVxVAq3m48M7F8wmTKQibNxXG+S98PMYH8Tac76gga4IpNaGDV
LYnRZiT75Unt2kv+wIZRcM+0nN7ZmAgn+hx4M8RS6OdVL5Edy8Cnl00nxfGCoPkq
pDceyNYIbYFpgrTFhw1ibtqBVxtAVcrKTZfRfoDgRy7MalYTpwUwWO208d6H5aNH
D4SPUI/qmefcP24lgakF6CJBgKvW/iOezGaugrlPzpKlrAzJnjPuvgw+X8djCM7e
7Oiqa7VwaR2SD/iB6t9ihxNTNVqWyUwou5BjyFAhxr19/UjNblo4xoI0OkocdL3q
oAO1otuYqcKjAMk7969Xqbq7jCsQ34a9TxeO7xJ33vZR5w6lx7IS/SikS4GL+v+i
OW5kT41CAG/faSgU0WxcIA+tJVL5K8ThtMpS9S2ST2rZNY2Yw2+Z1ntNFTA8CJzG
DbC7gVvpCExfY/CN8IAXjGrmE4DqHQi1TJu/YpcjhrufS/Tpvpc0YqAFWE28bMiU
KWJ4zYsoA7E0qz0V+V0Zk21QhrateKVkIzrttzrJlv6AffOjVOeib9hCdAZamDE7
3FiwBVFV5VvHAqOweISk
=HqHe
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Sep_2012_13_29_12_+1000_oa6UKWTBBrdevla5--
