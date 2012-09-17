Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2IQLi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:38:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59430 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2IQLiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:38:55 -0400
Date: Mon, 17 Sep 2012 21:38:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20120917213833.2b3ac86e097d131065a0541d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_21_38_33_+1000_sfel/zOer5OHO1wO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_21_38_33_+1000_sfel/zOer5OHO1wO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/max8907.c: In function 'max8907_i2c_probe':
drivers/mfd/max8907.c:248:10: error: too few arguments to function 'mfd_add=
_devices'
include/linux/mfd/core.h:100:12: note: declared here

Caused by commit 6c2591532a6f ("mfd: Add MAX8907 core driver") from the
mfd tree interacting with commit 0848c94fb4a5 ("mfd: core: Push irqdomain
mapping out into devices") from Linus' tree.

I have added the following patch and will carry it as a merge fix:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Sep 2012 21:31:20 +1000
Subject: [PATCH] mfd: fix up for mfd_add_devices() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/max8907.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 5295276..6497c98 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -245,7 +245,7 @@ static __devinit int max8907_i2c_probe(struct i2c_clien=
t *i2c,
 	enable_irq(max8907->i2c_gen->irq);
=20
 	ret =3D mfd_add_devices(max8907->dev, -1, max8907_cells,
-			      ARRAY_SIZE(max8907_cells), NULL, 0);
+			      ARRAY_SIZE(max8907_cells), NULL, 0, NULL);
 	if (ret !=3D 0) {
 		dev_err(&i2c->dev, "failed to add MFD devices %d\n", ret);
 		goto err_add_devices;
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_21_38_33_+1000_sfel/zOer5OHO1wO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVwu5AAoJEECxmPOUX5FE7bEP/0zCbVtzGxQHwYOG7VVWgs1Y
H4BYzWNM2tzV0e4Vdi/KnULyOyQFcDc4iEGlDyHRqfupM+4ecRaCKwFUxgNcHqOj
53vk9kIYu8gQHyifnL0GcURLzC7aAW57jLnZCUr3dpb1WYaG6nmjIwRYIOPuXJGW
K4Dj/ZFl2IvTAQ+TxHIWe5a6hQmLYIiYjQi+DPK5idVg8NGFtx3mFJu83WcvLiRN
cIOMUabej8jjVOAwB0YvX5WTwC+tuekuiJoS4cwPkJvvUxqqRLobXhQ/an6ou4N2
0wYOqOUmCMllC/low+57EUqRTaeOBZDLsQIuPAoCQbrPpjLIKMzyVmEmSe43mPja
wh7kEN+yorePcKd3iPr4nkuY/L8ba4Hvz5gmmhePfvaeqN9fEkSkb54UdWe82QVh
WHH3+2lk3nWkZL9tsox5oYGuehKt0q9jy90qZ9Ge5kmocDivoFX/JIIvKpbm5nWB
KIOJ111UivewkSgT+tE2ZBM1cxkFutsvv+LgxDhrSKAwzTb9NubpFNH89Y1MP/Bg
M+JX1e+BtTGovR/bHlAfna51Jc3aCsjaOy9njUThdDz3Nw/R+hbdETmyQy2xoBJB
yZzB0CRu3yY/bSvzK8yp2hUlgK8gHdxt+oYUHb7vioy8DhlHY1Atk8R3OmSXPrp2
NDc+uofD7Gw7j25UQkZT
=E3T3
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_21_38_33_+1000_sfel/zOer5OHO1wO--
