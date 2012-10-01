Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2JAOQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:16:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58956 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2JAOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:16:07 -0400
Date: Tue, 2 Oct 2012 00:15:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121002001557.0feca38df8a367ced5b3e322@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_00_15_57_+1000_o7XKOd2zpAd.ChO."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_00_15_57_+1000_o7XKOd2zpAd.ChO.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/mtd/mtdchar.c between commit 9c603e53d380 ("mtdchar: fix offset
overflow detection") from Linus' tree and commit "mm: kill vma flag
VM_RESERVED and mm->reserved_vm counter" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/mtdchar.c
index a6e7451,c4e01c5..0000000
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@@ -1177,12 -1145,8 +1177,12 @@@ static int mtdchar_mmap(struct file *fi
  			return -EINVAL;
 =20
  		off +=3D start;
 -		vma->vm_pgoff =3D off >> PAGE_SHIFT;
 +		/* Did that overflow? */
 +		if (off < start)
 +			return -EINVAL;
 +		if (set_vm_offset(vma, off) < 0)
 +			return -EINVAL;
- 		vma->vm_flags |=3D VM_IO | VM_RESERVED;
+ 		vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 =20
  #ifdef pgprot_noncached
  		if (file->f_flags & O_DSYNC || off >=3D __pa(high_memory))

--Signature=_Tue__2_Oct_2012_00_15_57_+1000_o7XKOd2zpAd.ChO.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaaWdAAoJEECxmPOUX5FERNYP/2KEd8XWRJGQxnAOUZNcNo4T
If9GCaYCHcaAD2uzwxPvntdsu041ojOvaM8EelrH6wpAhBNEPUUfpS2X2XNrxYMV
245eXS3TEnwiADlOQDF53+eRm8NNgnoMXh2LK/av4tQzvvaKIhr5RdYpHIpyyx67
ma3z+PKhHQ6XnKcB8+C4aL5RrA+lbFjpgKjbmJExqtoTdcxUOXqi4qDz4JAVsHM5
gdxo9YK+6aNZBwCwkRK8HzXz4sHLSFXYQpwOaEWP248Qst11p0rGnyb5a8hMqGr7
kXWJxpX+HsRsU8X5FxX73jYdz4KDyT+HkzldW53PpK5ijj2sSCSiJRGwyyafjG3l
peMRw2qg1xrjLYS3rdmRwCujIlbgVrtt+um9KVDGcXPoNk0LRp1FGiQdpJoemEU7
Y1S1fangdXd5gvqcENTMT3AoVvH8lUZ/KMnqxWjt93avtz9LV+GRLWHR87fdi78m
wgqyh0elYnS/JWmfZdRm+hVbvHcBX4o7QVIpl5wDDje3IKhaahh7zX6rwJ5SPjQp
4mZFAldoy3cdysobI4TGNdx+W9qew+oydl3HVv1tcKDdAx2FBM7EALl8LikturIE
mXr0/lxMOXmJhSKLUA/SIOxe6jd2O0F/5xop1mErhKxmcMwsCRagE27uKEVwyoyA
w6Y+D89dLHXM30aeuw9y
=Rqkm
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_00_15_57_+1000_o7XKOd2zpAd.ChO.--
