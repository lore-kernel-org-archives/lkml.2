Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2KZKQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:16:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47481 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2KZKQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:16:17 -0500
Date: Mon, 26 Nov 2012 21:16:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Bill Pemberton <wfp5p@virginia.edu>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20121126211608.136f1371f3b662907a89deee@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_16_08_+1100_6t+rqDKvYJ_lcrhQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_16_08_+1100_6t+rqDKvYJ_lcrhQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mtd/nand/mxc_nand.c between commit 06f255106923 ("mtd: remove use
of __devinit") from the l2-mtd tree and commit 4d62435f0601 ("mtd:
mxc_nand: remove cpu_is_xxx by using platform_device_id") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/mxc_nand.c
index 4aef6a3,022dcdc..0000000
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@@ -1337,33 -1378,7 +1378,7 @@@ static int __init mxcnd_probe_dt(struc
  }
  #endif
 =20
- static int __init mxcnd_probe_pdata(struct mxc_nand_host *host)
- {
- 	struct mxc_nand_platform_data *pdata =3D host->dev->platform_data;
-=20
- 	if (!pdata)
- 		return -ENODEV;
-=20
- 	host->pdata =3D *pdata;
-=20
- 	if (nfc_is_v1()) {
- 		if (cpu_is_mx21())
- 			host->devtype_data =3D &imx21_nand_devtype_data;
- 		else
- 			host->devtype_data =3D &imx27_nand_devtype_data;
- 	} else if (nfc_is_v21()) {
- 		host->devtype_data =3D &imx25_nand_devtype_data;
- 	} else if (nfc_is_v3_2a()) {
- 		host->devtype_data =3D &imx51_nand_devtype_data;
- 	} else if (nfc_is_v3_2b()) {
- 		host->devtype_data =3D &imx53_nand_devtype_data;
- 	} else
- 		BUG();
-=20
- 	return 0;
- }
-=20
 -static int __devinit mxcnd_probe(struct platform_device *pdev)
 +static int mxcnd_probe(struct platform_device *pdev)
  {
  	struct nand_chip *this;
  	struct mtd_info *mtd;
@@@ -1555,8 -1578,9 +1578,9 @@@ static struct platform_driver mxcnd_dri
  		   .owner =3D THIS_MODULE,
  		   .of_match_table =3D of_match_ptr(mxcnd_dt_ids),
  	},
+ 	.id_table =3D mxcnd_devtype,
  	.probe =3D mxcnd_probe,
 -	.remove =3D __devexit_p(mxcnd_remove),
 +	.remove =3D mxcnd_remove,
  };
  module_platform_driver(mxcnd_driver);
 =20

--Signature=_Mon__26_Nov_2012_21_16_08_+1100_6t+rqDKvYJ_lcrhQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs0FoAAoJEECxmPOUX5FET7sP/2pZBNLs9yvhptAPUzTbXnyB
Um+xmaH9fOlChBnXPHVUbakxJCe099ngHYbZuIjKOTy165kV8Hzp5w2rLUBHxKEA
u6nR3cfbyfkL0neUqsK8UMuC5vOINZWRFbmbVIUSvFMgXlnmtg6niHUC3hD8MMFe
YcbddZT9IIYlek2xogPitVYdr3lxBDM5FYqT5mSiYcU0nW9CdpH0Eh/0B0hduVjT
UJKASJ8T3csUZG9/5GPHHtu9mUc3gLE0TdfhFieVBZ9PeBW5zsGe/fY5AV33mBZN
F3qmsuLZMjMx45yaeqhGbHIhpwz/mUtlxo2IR5TYuWPIoGemxYrmDY1f4Cwi6lvd
VNtaXOxL08lNh8kcHKOL0L7XI+MeQdOh644tRrPTD7prMVjuY9DgG/YJJyGQCz09
NzcdRvaKYQNjZRPz46SF+umbJ8eGfT2+ytdFQweu8qYVS+Xetsli8nuJ80AR2fhr
6Rb4TpRER7KrYVaXl0zr550A4v6bqQCmiLK5QrWcGDAdmnQJzzB5yYdvI+XezGir
Rn8CJFT/EpRXdmc4iA4NM7aqesXavOuEghH6sil6qIjDrVTjBY2Bql6pIk5fOL0a
+L8MsQI6VV4y2aFMCw2tOxTiah4nngUxvMqG54GMOwOP+xZFYr1l5vLKoJPB4r6s
zePmsKUpzIUpK4nzKYbq
=rP6h
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_16_08_+1100_6t+rqDKvYJ_lcrhQ--
