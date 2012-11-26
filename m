Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2KZMxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:53:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60834 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2KZMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:53:00 -0500
Date: Mon, 26 Nov 2012 23:52:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121126235257.41581077d0243bacc9ac1dc6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_23_52_57_+1100_=4cSgzO/JNDJzY8O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_23_52_57_+1100_=4cSgzO/JNDJzY8O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/highmem.c
between commit 498c22802123 ("mm: highmem: don't treat PKMAP_ADDR
(LAST_PKMAP) as a highmem address") from Linus' tree and commit "mm,
highmem: use PKMAP_NR() to calculate an index of pkmap" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/highmem.c
index 09fc744,017cccc..0000000
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@@ -98,8 -98,8 +98,8 @@@ struct page *kmap_to_page(void *vaddr
  {
  	unsigned long addr =3D (unsigned long)vaddr;
 =20
 -	if (addr >=3D PKMAP_ADDR(0) && addr <=3D PKMAP_ADDR(LAST_PKMAP)) {
 +	if (addr >=3D PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
- 		int i =3D (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+ 		int i =3D PKMAP_NR(addr);
  		return pte_page(pkmap_page_table[i]);
  	}
 =20

--Signature=_Mon__26_Nov_2012_23_52_57_+1100_=4cSgzO/JNDJzY8O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2YpAAoJEECxmPOUX5FE6SUP/27J5mw5kE6qStgfV17zZj1A
UhZY3sVO6UEgwbQdgMnnbru8UJ10akhWaUa1zq/wvGiFUDiRm56gXQjEnuHpuhg0
fcehQ9BAqxW6tBOmb8vzPQLw4S+HYEHmYQgtyGK9cmZ+4Lego/gnmWKh22k/K6Ms
N2cIif/2hWKkUFtvw+j4gq0zB0ERmJaFkzY1yUAGIX84emerrFQfAcEs+uwAiUog
z0VxBG4xj2pZTFmV++GiBmVPsuHm4EJyyBob9Lq8strGITUX+IYJGJJQDWuq06IU
mZa3fPqhfT6rm11EGri1xpzJ782guuOsfTsKOVQrYDAINS15DFi3LGLFLSYEKcZo
CK6xXM3KbR3XmGKYIeVvVo6K6HxnNPkYZ3qgkosJGwJWlvmd8h00zX0n89Ivdc7O
MXh0LxTHzjaB7i8G/23aP4mJA3dFsJ6Xxw21CLbyv+T9fqlR5grFW0e1VdBB0yzq
rEcJU3+LIdnZ3AIjm4sOiz5lQteCk4MtaTvTaNOBEjSgiN/HT5U4zx6F9BNSmiOv
mbghL2hK4/PFaoukBTNjcut3I+flcBkQmLFksSFY0SGYZXV/Dqk8+PVCZZbLGxzD
OI/0dJYSTPiMB90eLMS6VFl/yRpZtdniyOqNgTXTniPIuEA5Zxm56mksOIj9KjZX
GmpYvYgorSJ3mk4iLSHy
=gkGl
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_23_52_57_+1100_=4cSgzO/JNDJzY8O--
