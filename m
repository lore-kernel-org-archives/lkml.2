Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2IUCuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:50:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37927 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab2IUCt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:49:57 -0400
Date: Fri, 21 Sep 2012 12:49:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the md tree with the  tree
Message-Id: <20120921124955.643dcd503be6cc67f5d1738c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_12_49_55_+1000_8fFBJvoYfvIhz9ue"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_12_49_55_+1000_8fFBJvoYfvIhz9ue
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got a conflict in fs/bio.c
between commit 4363ac7c13a9 ("block: Implement support for WRITE SAME")
from the block tree and commit 368e564836d3 ("block: makes bio_split
support bio without data") from the md tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/bio.c
index f855e0e,dbb7a6c..0000000
--- a/fs/bio.c
+++ b/fs/bio.c
@@@ -1485,20 -1511,19 +1485,21 @@@ struct bio_pair *bio_split(struct bio *
  	bp->bio2.bi_size -=3D first_sectors << 9;
  	bp->bio1.bi_size =3D first_sectors << 9;
 =20
- 	bp->bv1 =3D bi->bi_io_vec[0];
- 	bp->bv2 =3D bi->bi_io_vec[0];
-=20
- 	if (bio_is_rw(bi)) {
- 		bp->bv2.bv_offset +=3D first_sectors << 9;
- 		bp->bv2.bv_len -=3D first_sectors << 9;
- 		bp->bv1.bv_len =3D first_sectors << 9;
- 	}
+ 	if (bi->bi_vcnt !=3D 0) {
+ 		bp->bv1 =3D bi->bi_io_vec[0];
+ 		bp->bv2 =3D bi->bi_io_vec[0];
 -		bp->bv2.bv_offset +=3D first_sectors << 9;
 -		bp->bv2.bv_len -=3D first_sectors << 9;
 -		bp->bv1.bv_len =3D first_sectors << 9;
++		if (bio_is_rw(bi)) {
++			bp->bv2.bv_offset +=3D first_sectors << 9;
++			bp->bv2.bv_len -=3D first_sectors << 9;
++			bp->bv1.bv_len =3D first_sectors << 9;
++		}
 =20
- 	bp->bio1.bi_io_vec =3D &bp->bv1;
- 	bp->bio2.bi_io_vec =3D &bp->bv2;
+ 		bp->bio1.bi_io_vec =3D &bp->bv1;
+ 		bp->bio2.bi_io_vec =3D &bp->bv2;
 =20
- 	bp->bio1.bi_max_vecs =3D 1;
- 	bp->bio2.bi_max_vecs =3D 1;
+ 		bp->bio1.bi_max_vecs =3D 1;
+ 		bp->bio2.bi_max_vecs =3D 1;
+ 	}
 =20
  	bp->bio1.bi_end_io =3D bio_pair_end_1;
  	bp->bio2.bi_end_io =3D bio_pair_end_2;

--Signature=_Fri__21_Sep_2012_12_49_55_+1000_8fFBJvoYfvIhz9ue
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQW9XTAAoJEECxmPOUX5FEWp8P/RUmasv7Qs3n0UWlrzyPwRlo
BKXidlrRKiauR+i4McaZb/P5Fe9sOP8Lrv7igB172Z0rLHZ6hBLQUTN3Rfw/5aGW
SkzIGMfx2Ul+ia4FFOU9aFoN4NxDt4TUwz03diF7y0uDgetJ5o8mM1iHScRarS95
HE6Terb9renhlXUyAmmM9NDBWgwTxhE2MqQ+LiwsJznpdV3Hl3WhHye3sUgu4jj3
J8O2wfrcLNnP8p8V5aGLhjkM6vkTdAlx7HBnJMb4GBhVIu22SeGS/GNfRNzoOHfE
JfGEWhSFQ2/RXrcTiTLyyeXMEqunwu5CF5BtiLMDM501vYXjL+TJeBqYfdDWMNPl
lJ4EnSQycRIrTx/BKEqoZH/BXUwbOgIvtjS0vr9e6Db4fgC0z4bE0ISDOBtscNZa
3xlHeVuQYylAoTNcghJvBiE6OMmeyulfaq2kLmdHaJ5ToJ9/Uo32o9j5wSZ8KK1g
sroUyzgqmZEqAeBKviZhx6yZHNGqBthghK+M4X6/3xzaLsW521lNfrYc5XtYdXz7
fUkWNfAuhlRZZLs5PBrXfbdVPwzgk8uSEV13NYby68uYYDvr0tZ5MFseOdVbRSzS
cARPYfCNxVzzJldHvXPJY+RcbAohexZzfn5yshr3kuMkBWxdMgYcaQVgRMRF95Dh
GiCR03GJbVhvLij1UgAU
=C2D+
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_12_49_55_+1000_8fFBJvoYfvIhz9ue--
