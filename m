Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2IQICk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:02:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47045 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IQICf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:02:35 -0400
Date: Mon, 17 Sep 2012 18:02:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20120917180228.c64369b4586a2a31042d4175@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_18_02_28_+1000_jAcTs=fQM3FyPBQb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_18_02_28_+1000_jAcTs=fQM3FyPBQb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-imx/clk-imx51-imx53.c between commit 75453a08e365 ("ARM:
i.MX5: Add nand oftree support") from the mtd tree and commit
a745f039b901 ("ARM i.MX53: register CAN clocks") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/clk-imx51-imx53.c
index e81f17a,e5165a8..0000000
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@@ -456,7 -461,10 +462,11 @@@ int __init mx53_clocks_init(unsigned lo
  	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "63fcc000.ssi");
  	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "50014000.ssi");
  	clk_register_clkdev(clk[ssi3_ipg_gate], NULL, "63fd0000.ssi");
 +	clk_register_clkdev(clk[nfc_gate], NULL, "63fdb000.nand");
+ 	clk_register_clkdev(clk[can1_ipg_gate], "ipg", "53fc8000.can");
+ 	clk_register_clkdev(clk[can1_serial_gate], "per", "53fc8000.can");
+ 	clk_register_clkdev(clk[can2_ipg_gate], "ipg", "53fcc000.can");
+ 	clk_register_clkdev(clk[can2_serial_gate], "per", "53fcc000.can");
 =20
  	/* set SDHC root clock to 200MHZ*/
  	clk_set_rate(clk[esdhc_a_podf], 200000000);

--Signature=_Mon__17_Sep_2012_18_02_28_+1000_jAcTs=fQM3FyPBQb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtkUAAoJEECxmPOUX5FEu/EP/2UcwLbo3goJqH7xpKtVnHD/
VkD4xVxLfz8SVVbbxn9E3VJdoUpDLOLPXk29mdTZlEF8pup/RZKa/F3iLkCyfwC+
tcZ5CjJREaVQb3mwL+fsLsUAJBXGY2V7nPkUybK+bNzSmDxHTscsAkJWTiH0063e
U+X/7t1Zr5Y+pS+k8+CtgADIkNAh/MKDIiwfxHK07CfFiNkKkMNKpkLlfhDxP633
qd1gEZyEX7Nds+UKvT3ZMunDw4mSRuDj7eX11FeLArowN/SrP6pvZjJE555PwON6
FPkMFoJSGN6YBPewYmKK1kyAafC5foDzRoUHH3Dk1X7Lk9L1Di/MI83KuePb5eVX
FTKgTFOfe0PBn9GdyVRi4FxbwZTJ13f0Yda0MfuPvmkgP5Y+IGL+RgXDZ7IDUFHo
2m5eQnw9Npy1jJiAq8N3TR3bqYGibBcFOd3HkPcJ5NTJrfBAxK7AsDO+mMHSWlMp
fAwRXpefjFe/SCluNhM7RXeddcSZE0HFqV8T1jzl0lCgkcFx2OBI250Acg9+5m/c
7liVTzaAxtz67kLrcdsCTo+xpwSm4oGBG2J55xVMXtx+P/rX9tWJYTg2d/GT3NiY
SxUVot765HBm5p9Qm5yhMBn6V3Qys6wAIkp3TuoXPSEm9IVEvNiSd0uHvffn6FK4
bN8sFaTmkkTxFsFGinl+
=i4PH
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_18_02_28_+1000_jAcTs=fQM3FyPBQb--
