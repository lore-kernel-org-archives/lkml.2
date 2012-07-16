Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2GPGwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:52:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39919 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2GPGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:52:37 -0400
Date: Mon, 16 Jul 2012 16:52:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20120716165227.a49e0366033e54ceb8936af5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Jul_2012_16_52_27_+1000_Ged1./rLsrPN0kXG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Jul_2012_16_52_27_+1000_Ged1./rLsrPN0kXG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/ext4/bitmap.c between commit f6fb99cadcd4 ("ext4: pass a char * to
ext4_count_free() instead of a buffer_head ptr") from the ext4 tree and
commit "ext4: use memweight()" from the akpm tree.

I fixed it up (I hope - see below) and can carry the fix as necessary.

N.B. this code is now used by more that just the EXT4FS_DEBUG code.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/bitmap.c
index a94b9c6,ff53d5d..0000000
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@@ -11,18 -11,15 +11,11 @@@
  #include <linux/jbd2.h>
  #include "ext4.h"
 =20
- static const int nibblemap[] =3D {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, =
1, 1, 0};
-=20
 -#ifdef EXT4FS_DEBUG
 -
 -unsigned int ext4_count_free(struct buffer_head *map, unsigned int numcha=
rs)
 +unsigned int ext4_count_free(char *bitmap, unsigned int numchars)
  {
- 	unsigned int i, sum =3D 0;
-=20
- 	for (i =3D 0; i < numchars; i++)
- 		sum +=3D nibblemap[bitmap[i] & 0xf] +
- 			nibblemap[(bitmap[i] >> 4) & 0xf];
- 	return sum;
 -	return numchars * BITS_PER_BYTE - memweight(map->b_data, numchars);
++	return numchars * BITS_PER_BYTE - memweight(bitmap, numchars);
  }
 =20
 -#endif  /*  EXT4FS_DEBUG  */
 -
  int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t gr=
oup,
  				  struct ext4_group_desc *gdp,
  				  struct buffer_head *bh, int sz)

--Signature=_Mon__16_Jul_2012_16_52_27_+1000_Ged1./rLsrPN0kXG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQA7orAAoJEECxmPOUX5FE2F0P/3pEKkQYhZygKmkEV4+xscSr
fiA3ja1TRUoNZm2yN/w5lrjsPjNspTicLQTLSu4/0qMynNik9HEMw+ppUtw2d1z+
xAjVi9iTCYDNWpy2B+wGwaVVfQP4Wt+grTiJzr5yVrmPfF5YRmiYTOz8wJ+ikWgc
rFObC/zwIq/1i5Kr3eExKnJRzAzN1ozprjACiVjuuFK8483ptKLQhpoIqXT5qD49
yLfYdugIHIOMKcWDB/e4jksh8ipvGhx5Oyh7V/nh7sYjF5FPShSgLaNDEnBy+Wln
gTPFq5cjRmv2wjZ+t2Cs1jqaVCKPjj2ONAwthNkt7YVE9bFeWW8SRmCj7n8o63TW
CUt2ZrRcdl6UMR13oGmWSpnynaivy0+AaPYU7I3yMUnWhJ8bota4rCXTPJckFgB2
TGtt1y4sJCFTmRy2T1aronb66qJvKlTcBIUmXVKbYuXhPYl6mn/vU37EBAWs7BWs
OEmB5Yvkz10c541YKz624WBPi1sfbsVRopvtfEPjtWWCZgNLuNrNuQzh9Cc6Ezni
iQtC1NWN/nU1pZ6D/57JAjwVE1PJzPh/SFF/ezpsrKAGrzH3eol76QUbO4i4pPkG
h/C5JeDTnOU8AyrnxrOEt2YHKBTOJ+ug+xq6yoNVBP/hTR8mO7ROX+imbKMu5lUg
M9wauYWb+yxWp8aEQcMK
=ykj/
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Jul_2012_16_52_27_+1000_Ged1./rLsrPN0kXG--
