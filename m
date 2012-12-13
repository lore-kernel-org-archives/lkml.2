Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2LMCFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:05:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50623 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2LMCFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:05:21 -0500
Date: Thu, 13 Dec 2012 13:05:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: linux-next: manual merge of the virtio tree with Linus' tree
Message-Id: <20121213130503.3432e2e1715439a49962873b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_13_05_03_+1100_iWyRJ+pFYZ9=yoX2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_13_05_03_+1100_iWyRJ+pFYZ9=yoX2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the virtio tree got a conflict in
drivers/virtio/virtio_balloon.c between commit e22504296d4f
("virtio_balloon: introduce migration primitives to balloon pages") from
Linus' tree and commit 41395dfb3d35 ("virtio: Convert dev_printk
(KERN_<LEVEL> to dev_<level>(") from the virtio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/virtio/virtio_balloon.c
index 2a70558,586395c..0000000
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@@ -133,16 -125,14 +133,15 @@@ static void fill_balloon(struct virtio_
  	/* We can only do one array worth at a time. */
  	num =3D min(num, ARRAY_SIZE(vb->pfns));
 =20
 +	mutex_lock(&vb->balloon_lock);
  	for (vb->num_pfns =3D 0; vb->num_pfns < num;
  	     vb->num_pfns +=3D VIRTIO_BALLOON_PAGES_PER_PAGE) {
 -		struct page *page =3D alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 -					__GFP_NOMEMALLOC | __GFP_NOWARN);
 +		struct page *page =3D balloon_page_enqueue(vb_dev_info);
 +
  		if (!page) {
- 			if (printk_ratelimit())
- 				dev_printk(KERN_INFO, &vb->vdev->dev,
- 					   "Out of puff! Can't get %u pages\n",
- 					   VIRTIO_BALLOON_PAGES_PER_PAGE);
+ 			dev_info_ratelimited(&vb->vdev->dev,
 -					     "Out of puff! Can't get %zu pages\n",
 -					     num);
++					     "Out of puff! Can't get %u pages\n",
++					     VIRTIO_BALLOON_PAGES_PER_PAGE);
  			/* Sleep for at least 1/5 of a second before retry. */
  			msleep(200);
  			break;

--Signature=_Thu__13_Dec_2012_13_05_03_+1100_iWyRJ+pFYZ9=yoX2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyTfPAAoJEECxmPOUX5FEfg4P/R3sdKwXHaVoxIGQYLfukShp
9LKAeFlf7xPwIbg7IntJsAQqtajlEddSVgt0A86PgaQuYehkiXdS8qFWHqOUZ7e2
quCJ1f48F3YTP6ECBm/crIXM2uq8sCUbLSpfLRs9zIVTEChrrU9+mYQh4cXLnn1z
YUEOAOOyNoDzYsHjLOaMhJ/guY31eZakr3JiiDgUyBSXWhco8zMOsBGB4eydi8M0
C/v5JwHOM4g7ppexm2D+qC4QMEZSLJ3wU+eZ7UVF0KIJw23+oZUNpI4mhWZQ8tN0
Lr0eHhn+9d6PPSGe+ORKkzCXthr1DyMdOBJLmYMmtMkmjVppZY2Cv08nYBSRuLuI
bp2rXxAeTblhvKjTvxmxRfWwvknqFB2UETvlXa4uxCP1gznMMb+OWqdCOiUiZGOL
Ks5mZrx/yxwEdHgfx70uF3N93Rqp2TKHIy/nsEji746ZCCGa/3yra+9Q1erORQb+
qF/5+ND3RcTDfZ8MWKzJvYON+ufA+ysWtQFGoso+099cs6+7c5jmPBc0gT8nIHxl
Lcbs1wXCT48IATLgmvrgc+wg/HQoWH6DX3iv9MALkAJhmRwJXxRvD+2t1XNrrMiW
8eQUk60SEuUyhRY2Y07WQCMZjNHYffouI2o+fNWdsUHJ+MHGLHzBIo1uxObbCL7q
pApomrCSPGEnC9TuD5pY
=fVaz
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_13_05_03_+1100_iWyRJ+pFYZ9=yoX2--
