Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2BVBtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:49:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48044 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2BVBta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:49:30 -0500
Date: Wed, 22 Feb 2012 12:49:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: manual merge of the mmc tree with the s5p tree
Message-Id: <20120222124915.9414928ca50d8b181820c733@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Feb_2012_12_49_15_+1100_sGZ7OXPBLn7H74tx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Feb_2012_12_49_15_+1100_sGZ7OXPBLn7H74tx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/sdhci-s3c.c between commit bd0955ed6b1b ("mmc:
sdhci-s3c: add platform data for the second capability") from the s5p
tree and commit 7880741a0625 ("mmc: sdhci-s3c: derive transfer width host
capability from max_width in platform data") from the mmc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sdhci-s3c.c
index b19e7d4,3bf509b..0000000
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@@ -518,6 -683,17 +683,14 @@@ static int __devinit sdhci_s3c_probe(st
  	if (pdata->cd_type =3D=3D S3C_SDHCI_CD_PERMANENT)
  		host->mmc->caps =3D MMC_CAP_NONREMOVABLE;
 =20
+ 	switch (pdata->max_width) {
+ 	case 8:
+ 		host->mmc->caps |=3D MMC_CAP_8_BIT_DATA;
+ 	case 4:
+ 		host->mmc->caps |=3D MMC_CAP_4_BIT_DATA;
+ 		break;
+ 	}
+=20
 -	if (pdata->host_caps)
 -		host->mmc->caps |=3D pdata->host_caps;
 -
  	if (pdata->pm_caps)
  		host->mmc->pm_caps |=3D pdata->pm_caps;
 =20

--Signature=_Wed__22_Feb_2012_12_49_15_+1100_sGZ7OXPBLn7H74tx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPREmbAAoJEECxmPOUX5FE6GEP/2pufMqioKa9hOrPMCLg52Lb
bKvFL5HTOIa7XMVtqSgi7NKvB7d4QOLMLig7yYDp3YyHCaTBxMB03hoVUufG/wbg
J9v3mHpaH3VV2zW4k6ND2kNXt8IjTuwlxxDHbu9NipDKNadjB8kEu8xyNHFoF+1t
gyXwsuZvg24mGcLdB9/myHBGqrYRxFmXhLe6t2h24ABoOfrfH1YqicznDa5xw6xO
jgII+7QPDso+qSilTTl8w7BDVCVtOEkQ9+3cX/Y0CVTbPRJS75Vv81aU/fQlsORD
6mloiS6FdZouAR5q0x6Gzv8q4Azcqi9mNsevVIsoteZVl+BclS/birVVzg70an6u
6M+De+U2XqiHoFvwX5BLd7YLU5qucc4nbBY2oUbGOmV4dm0K5ahf4PTicqDvuJDM
638GIEpVP7xnxWm4cP3cd+ctQ+fV9u4SZJ1NdJqzRsssMYe5UiNFfePSK22NQU3v
Epf1pksx8WwWY1n1G3/YBDidTfbYrDUNCATYJZAepk4Rg64qfcpX7yyE3sovMwGf
sv0ru6z/glNVtw48TsDsnNZelQ1G5SOw3e98P7NWy28zxLffz0Gi+G29bRyROHWB
d1BM4gwYyvf4rnsuMuXrW2gg4Qk9AnRTC7kg+pU5nzT3hH+tqbY7L6VHzSLiYJ6O
kXOTYbGXKlQeVDqOObaa
=FWv2
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Feb_2012_12_49_15_+1100_sGZ7OXPBLn7H74tx--
