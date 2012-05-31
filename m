Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab2EaEZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:25:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52077 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2EaEY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:24:59 -0400
Date: Thu, 31 May 2012 14:24:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120531142451.6bdcda603c98d9ad8c4f3bbd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_14_24_51_+1000_j.YG4xizB5.yEfum"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_14_24_51_+1000_j.YG4xizB5.yEfum
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/swap.c
between commit fa9add641b1b ("mm/memcg: apply add/del_page to lruvec")
from Linus' tree and commit "mm/huge_memory.c: use lockdep_assert_held()"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/swap.c
index 4e7e2ec,8ff73d8..0000000
--- a/mm/swap.c
+++ b/mm/swap.c
@@@ -685,8 -653,7 +685,7 @@@ void lru_add_page_tail(struct page *pag
  	VM_BUG_ON(!PageHead(page));
  	VM_BUG_ON(PageCompound(page_tail));
  	VM_BUG_ON(PageLRU(page_tail));
- 	VM_BUG_ON(NR_CPUS !=3D 1 &&
- 		  !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
 -	lockdep_assert_held(&zone->lru_lock);
++	lockdep_assert_held(&lruvec_zone(lruvec)->lru_lock);
 =20
  	SetPageLRU(page_tail);
 =20

--Signature=_Thu__31_May_2012_14_24_51_+1000_j.YG4xizB5.yEfum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxvKTAAoJEECxmPOUX5FE6A4P/1X9IW0GRR9WHb/wiMv5rSpE
5IrubaXjNGc9p2v6+hMluYzcxCJC7NV0tlvCIEA7XmvihjjEgrgFUxwTwT6shm3H
uhbQT9TBP7hH4RJlP0llMjseI2kFpC1xx6D940CODImgq+PKurBVcbbCXXrlT9Xx
7AcCK7dTyaCqnpwBZWuOhZxQWpyweSYTCtAm7Jf4xmI3Yt/yrfgXAzKMQzFWSVQS
/0Lg05ts3bQsOawkVMz5E8gyrRZfbZpIhlBFHY9RvuYZ4LE31TVCCUp5lzWdFjyp
sFiB5HbetNq9ts8mMM96wIQHGnwdYPKjYES+sKvTcP8TUppBVRVI3NeFM3YfrSAo
AkdpFfzYSjZwhP7+IHVGVnKHACxkbG8LoVTRWwSLSZiz1lf4XUzJaZxAxylf7hzj
O6lFt9dNc0xKblgD/5WNP5ng30E/T7z8cbA+4aymQDAvuD4cJJjWPjjhPDQa4EyO
Y5fTKl78Bt1x+WBVJM6VSU9jbYZVs5DEE00Ty9MHl5EVJKtyFuTV8A2GqjxYHKBd
qUcs7Rk43qo8tOUNEx8GQZmDLqJPlVEyU6vRnEIqFsaFJkHkTYlUpuRrYKcTzKun
ZHPoOT6+Dh/fIJ5BPCh+lQzODwpyVX8AJrfY+RKIn2hEk3CAJp1YyksQ3R361gk0
5eKHXMPaLccfSxbLqlWc
=Ndsb
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_14_24_51_+1000_j.YG4xizB5.yEfum--
