Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2IUGs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:48:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35305 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2IUGs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:48:27 -0400
Date: Fri, 21 Sep 2012 16:48:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the final tree (mfd and
 battery trees related)
Message-Id: <20120921164819.37906a76dc948e86f79cd875@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_16_48_19_+1000_bEdFHynE3+fZj0F6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_16_48_19_+1000_bEdFHynE3+fZj0F6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/88pm860x-core.c: In function 'device_power_init':
drivers/mfd/88pm860x-core.c:982:11: error: too few arguments to function 'm=
fd_add_devices'
include/linux/mfd/core.h:100:12: note: declared here

Caused by commit a830d28b48bf ("power_supply: Enable battery-charger for
88pm860x") from the battery tree interacting with commit 55692af5eb58
("mfd: core: Push irqdomain mapping out into devices") from the mfd tree.

I added the following merge-fix patch and can carry it as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 21 Sep 2012 16:41:09 +1000
Subject: [PATCH] power_supply: 88pm860x: fix up for mfd_add_devices() API
 change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/88pm860x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 62311ad..a4dba31 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -979,7 +979,7 @@ static void __devinit device_power_init(struct pm860x_c=
hip *chip,
 		power_devs[3].platform_data =3D pdata->chg_desc;
 		power_devs[3].pdata_size =3D sizeof(*pdata->chg_desc);
 		ret =3D mfd_add_devices(chip->dev, 0, &power_devs[3], 1,
-				      NULL, chip->irq_base);
+				      NULL, chip->irq_base, NULL);
 		if (ret < 0)
 			dev_err(chip->dev, "Failed to add chg-manager subdev\n");
 	}
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Sep_2012_16_48_19_+1000_bEdFHynE3+fZj0F6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXA2zAAoJEECxmPOUX5FEoDQP/2G/3b2KjC9VCPugLrHftCRY
oqj1hUGS3ISAyW/sOjgOJAd2sfjgkn+Aj764AnQjGznC2MQWvDECDXpgSAe5poRs
FxB5gJHtLg8PITbzczcrq4HcWQJyfZgAEiUrZPtkMr6PvbAbhJU1m9DA6TSJMv9k
reDHb0l8I+E7hXSC3+MX+AbT5753XUYtZJhIgVorJQyv4I7NZ16Y27ocLXPxsk9C
y6nqfTq+qKJ9R9PbBY0nhzlyczDvmcEPvaH3J80eSwn/dPdbugilNWebWob/fih1
tpj7m5jqXqT4MXxGajH+VNpsNDnQXvveySYQ3RY/kuO5UiKmxyd8UiSQgTxdN3xq
1OuHWci0hWg0YlT/9XSCzfIwhr5vLrXJfdEr0R0oG5OAigkfh7dyhYOUYmCyeIyo
1p0nbPRVIgOFS4e/nN4F2DAEu1pBIGjhjYSVW+AtIzWxRHcvDEolSnedVEmpVrZm
/TupComw3K+hQK9pw+sVYVUz7E/3nGfoZq3AoGQRej6ya5O64+AKmzAcoye058+n
A0i1icbCbMl2yPVICQgVY/En23afobsyEsMzF9In9eWqnQJouLic7TcjB+Y7bZo/
RMPtZmsU6As9NDGnIxMcS+0Sbtu2nOs7CSCIPJf2mIIbK1wGU2MQrS5l09O5xuvY
nY/l/YNQ3B3ki7gja/kx
=VI2+
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_16_48_19_+1000_bEdFHynE3+fZj0F6--
