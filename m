Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2IQICx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:02:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34678 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IQICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:02:47 -0400
Date: Mon, 17 Sep 2012 18:02:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the arm-soc tree with the mtd tree
Message-Id: <20120917180243.ba626fb72dced777cd4e057e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_18_02_43_+1000_TZtudnuFXDg9nuh8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_18_02_43_+1000_TZtudnuFXDg9nuh8
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

--Signature=_Mon__17_Sep_2012_18_02_43_+1000_TZtudnuFXDg9nuh8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtkjAAoJEECxmPOUX5FEcTcP/iGCtwVUZQdFgmm2+c/vw4sl
lu1hEz/gXdVvkVaYxTBJYOpKSAx2OXtcIiNXlvY0heQKOs46zOCKVoDx4MLVC5ea
wtU8cKIkWkR0HCDyTVHFlXiZi7yOkb+tgGShvDX18KNIaRyqx2ap4HBSGwPPWuIP
lOnOMao/kvD53AyOAuHArdiAsCAdff29+zeNDBrIG4A4AnjRlijJtL+R+amNJDvn
ww1PVZjIJ0895BkoQn+LmEN9Ok5nvYAx9Im0207UYKneYrHdcL/DoO1Eu1ZQJE4V
kFi+Y/YkGkumprPw7XAiN0EpXGL4+dlaHQ37OSDD3BhGnGQBXS5WappObzwwSkIO
LYwVWuqvqJTtgO/FTuLSXtgd4ANRzZCUUUuE0tBopRLCP6/6qdFuMRfB251NB9pL
XLGqdrLbFyj38wxiZC5+odrzmSed86D//YhL4DMC111yJHWcFMZISzoJDk51AfCe
CTCVITxgY242lzvs7KOsmVV6VCEmZ3dD/Zt7tV9OKBmWhl9vZzYVN9OkxB9OEUxs
rN0wmk2RI7+zgrbBx2Jd0E/jw5F4uvtskHQzgvYHuZiNL6+lJ2/zKIN530ugW8P3
iuieMutMLFImy5i/U+q419MeAdP5fPBjDYTYxaxPExediP+gr9av5cQjL9Yu3RRg
g6tcJgzWi2Mr5ad3v2Tg
=ZVCx
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_18_02_43_+1000_TZtudnuFXDg9nuh8--
