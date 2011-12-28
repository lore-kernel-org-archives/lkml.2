Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1L1HHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:07:42 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35687 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1L1HHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:07:40 -0500
Date: Wed, 28 Dec 2011 18:07:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>
Subject: linux-next: manual merge of the tmem tree with the vfs tree
Message-Id: <20111228180724.2c837aff6e65359abecddf78@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_18_07_24_+1100_a8ZCt=otekVA2tne"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_18_07_24_+1100_a8ZCt=otekVA2tne
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the tmem tree got a conflict in fs/buffer.c
between commit b1cdabb05024 ("fs: move code out of buffer.c") from the
vfs tree and commit 294a90bcfd28 ("mm: cleancache: s/flush/invalidate/")
from the tmem tree.

The code that was modified by the latter was moved by the former.  I
applied the following merge fixup patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Dec 2011 18:05:28 +1100
Subject: [PATCH] tmem: fix up for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/block_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69a5b6f..d6d5f29 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -110,7 +110,7 @@ void invalidate_bdev(struct block_device *bdev)
 	/* 99% of the time, we don't need to flush the cleancache on the bdev.
 	 * But, for the strange corners, lets be cautious
 	 */
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 }
 EXPORT_SYMBOL(invalidate_bdev);
=20
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_18_07_24_+1100_a8ZCt=otekVA2tne
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+sAsAAoJEECxmPOUX5FENLAP/0lUPmrDuIHvTxai9slCUwUS
QGDzSqh1aIF0rujGxhvidMJ2NOD07zpzPj1BWbK5LU1J9/Ot7b+6WKxLMs+sarCy
9DnK1sl6sqsqoCKSVIEmdNuiSuIvYO36cMtdMAdwVseh4hIlAPKWuB+NTIklgkwa
WxQcmZQ1LBYREu16jJQZbJAPFvTk7kgd2WGJMZnRJKlZSSzy/vKDHlQzvU/o+h33
VxE+IEFGdKXG1jILyiZWg1g/73F4VfdTEvRIGLn8Huj0iK7S04Z4jQscxj49v/p5
rr3FuOjpk4x4zWTrJddWaMwt7lW+z9HxvRkLhpX4jkVCXV1h3wi8AGFgykeqiXhG
DEIsEE4Ob1+BsVns7c1A1TPyUU/rcVC2JuRLs1oxE9Yi2I4pbvLUCqEs9U+2UfQ4
N1m3GVKETs3Db/EjGT6jGBDef5IKQoIaQFwParxPo139m+6cLksqRx2bNYIEvoim
zokL/bFw12iIBATsA0/7xd3SRWzHUZKcW2dv6xdRF548STn/6GKnrDOxPCq8irWE
a9l1vHqqlrwPgY3ojONaKjwf+E7QWHOU6zjH7ss5BvjHTQU0tV+sZ38TBvK7+L72
HrWXDT+/0u7JnCXnX3MTb39squSFUwiNZ2GNsVgNrpgmnR7EkZLk1wF6xOT3t6Sv
qulX443ZkKJ1qKfEOutU
=zzeZ
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_18_07_24_+1100_a8ZCt=otekVA2tne--
