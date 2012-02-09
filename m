Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2BIDsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:48:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43476 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab2BIDsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:48:17 -0500
Date: Thu, 9 Feb 2012 14:48:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the
 staging.current tree
Message-Id: <20120209144807.78f2807f594959f3836cf2eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Feb_2012_14_48_07_+1100_Os0RzSb+.lf2oYi1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Feb_2012_14_48_07_+1100_Os0RzSb+.lf2oYi1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/zcache/zcache-main.c between commit 2a4830110b90
("staging: zcache: fix serialization bug in zv stats") from the
staging.current tree and commit a3a2486aeadb ("zcache: remove the second
argument of k [un]map_atomic()") from the kmap_atomic tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zcache/zcache-main.c
index 875acd8,57550ae..0000000
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@@ -674,9 -675,9 +674,9 @@@ static struct zv_hdr *zv_create(struct=20
  			&page, &offset, ZCACHE_GFP_MASK);
  	if (unlikely(ret))
  		goto out;
 -	zv_curr_dist_counts[chunks]++;
 -	zv_cumul_dist_counts[chunks]++;
 +	atomic_inc(&zv_curr_dist_counts[chunks]);
 +	atomic_inc(&zv_cumul_dist_counts[chunks]);
- 	zv =3D kmap_atomic(page, KM_USER0) + offset;
+ 	zv =3D kmap_atomic(page) + offset;
  	zv->index =3D index;
  	zv->oid =3D *oid;
  	zv->pool_id =3D pool_id;

--Signature=_Thu__9_Feb_2012_14_48_07_+1100_Os0RzSb+.lf2oYi1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPM0H3AAoJEECxmPOUX5FE6JEP/j8UvJ0i2cILob20mdEVE4k4
grLz13sH9y8kx86vSga3zSfODW6srAV0bQ7vqfVhAxpxm2B6IgiR/KSKGMXORb4a
Bfo28tKM3wx6j8qsitnIufY/vA3NxkxfLb6vv9NC45Pw9AV5eH8DdZbJYtSLQUPF
mSDO8rH5/Ze9nSL+EIk8odI6d9+pTVLhoPcuvtfqHJmNl+LCrh9eh2+LrCtIwq1H
NZ1ObwFcpreTGQNd3OF+Ewq1Q+hUxyzzUnzEEr5GyPWWaHzPDHHVw0pBkGU9rtZC
4kKeYYuVUPn6Zw6nxKyUuqHigMx4fa/H/xIiy7J1ze50UZYfvqNxGLjHHc2+mQgN
lntoQurYPIJ0m1OBTSMPGKSXW9t6kK0re7mYyv2lhjTNteksM1SQdimZN1QOZZUQ
fqB7ffvnuv9bIysmWvfQ9tNLBojc5HM1JhT9MwAdXHbFcj6vik92f/EJWoIefPV5
7hnND9TUJQQnZQr3kwllCkhXEeuhSJ21Msmb57cMHBLAQaz9ADq/TkmzWHfu3Qnv
nKFn9sCst22wFsOh3Np6wpCqivKx8bN3WZPYQgiJMMQi3dB3ezuz0sIK25vuw3fq
oqlQcBUvuJ0zFl+mv5/up2ub17BvVOQopPIjyGNB/f75oXpiY8BPCenzbhT5401h
InSxpJb3PxUuCp8vvEJL
=mOw5
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Feb_2012_14_48_07_+1100_Os0RzSb+.lf2oYi1--
