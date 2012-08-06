Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2HFDn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:43:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59308 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HFDn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:43:27 -0400
Date: Mon, 6 Aug 2012 13:43:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120806134318.8af35d047e255fd25398210b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Aug_2012_13_43_18_+1000_jvNAPey6_wx/d_38"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Aug_2012_13_43_18_+1000_jvNAPey6_wx/d_38
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/gfs2/rgrp.c: In function 'gfs2_rs_alloc':
fs/gfs2/rgrp.c:456:2: error: implicit declaration of function 'rb_init_node=
' [-Werror=3Dimplicit-function-declaration]

Caused by commit 5599fe1ab023 ("rbtree: empty nodes have no color") from
the akpm tree interacting with commit cde7c325077b ("GFS2: Add structure
to contain rgrp, bitmap, offset tuple") from the gfs2 tree.

I have applied the following merge fix patch (which is probably not
sufficient).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 6 Aug 2012 13:35:11 +1000
Subject: [PATCH] rbtree/gfs2: remove call to rb_init_node

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/gfs2/rgrp.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 06476b3..6fb3a57 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -453,8 +453,6 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	if (!res)
 		error =3D -ENOMEM;
=20
-	rb_init_node(&res->rs_node);
-
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res)
 		kmem_cache_free(gfs2_rsrv_cachep, res);
@@ -486,7 +484,6 @@ static void __rs_deltree(struct gfs2_inode *ip, struct =
gfs2_blkreserv *rs)
 	rgd =3D rs->rs_rbm.rgd;
 	trace_gfs2_rs(ip, rs, TRACE_RS_TREEDEL);
 	rb_erase(&rs->rs_node, &rgd->rd_rstree);
-	rb_init_node(&rs->rs_node);
 	BUG_ON(!rgd->rd_rs_cnt);
 	rgd->rd_rs_cnt--;
=20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Aug_2012_13_43_18_+1000_jvNAPey6_wx/d_38
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQHz1WAAoJEECxmPOUX5FEShEP/iWP3QDeMn4Kk7DbDIMA0Bve
AIEnLudK6Oo2znip+aHt2z9J/s4NazZb6XH76oIm/nnbm+W2U7s7lVBLadIQQofX
SeqdQtIofExDp68XJIcDfeZcLwgbf76FwDBxZFJJHiC3l6Yhpu7+PrSHmcdHhPhU
0KxsqUelCYphp6MSDBJCJfMQTVGP/f72+AnfTA7dSWqH0RtBUIaxMJx05anpqSux
bdddvIaolb4l+6WJI+HwyuguWcPicIfMLlEP5rXNqNkImzCbm/089BoCywodbDKp
UN18SvQ7M5g4ez+ni0XDNFsc2zqORiZBdQzvxVsiVtPck0IhyiBdxhwQbR/OR5gD
pKVZMPO92/WMv+iAK4i8urt/9xzB0hAFfa3RkKD5xaqAQNXwlWMNxwgPuKo09CG3
U2Pzn5cj1TE3vQJJHKA8dKF+VS3n+EnTzKm9a+8toe00WOxp424tc2BlH6UUuDKO
9fIOuk8yyf57CsI37VlW4aC1Jbo9PK5Gi98CTUhGkgkHBenIGZwrpOdzpOkcb4Cc
LK8vxAvC7CPs+jbfLo97ckWZHtlr8QVsAphekghyEODW676NB2Wg6+NpxyJVHKIG
HeYprQQA8c6s0GmqvWa6Hwr3gupEZU1lNfPJhknN2sWnUK0Ffo75HXt8KV15tbYK
yW2x3+pXn6ApbCKfgvGK
=7V+m
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2012_13_43_18_+1000_jvNAPey6_wx/d_38--
