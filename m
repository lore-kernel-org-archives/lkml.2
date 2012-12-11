Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab2LKFWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:22:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46023 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2LKFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:22:20 -0500
Date: Tue, 11 Dec 2012 16:22:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121211162210.14ddcdc4d37c40520b0fa88a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Dec_2012_16_22_10_+1100_47Dq_BgxXCrUHXUp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Dec_2012_16_22_10_+1100_47Dq_BgxXCrUHXUp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/gfp.h between commit caf491916b1c ("Revert "revert "Revert
"mm: remove __GFP_NO_KSWAPD""" and associated damage") from Linus' tree
and commit "mm: add a __GFP_KMEMCG flag" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/gfp.h
index 31e8041,5520344..0000000
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@@ -30,10 -30,10 +30,11 @@@ struct vm_area_struct
  #define ___GFP_HARDWALL		0x20000u
  #define ___GFP_THISNODE		0x40000u
  #define ___GFP_RECLAIMABLE	0x80000u
 -#define ___GFP_NOTRACK		0x100000u
 -#define ___GFP_OTHER_NODE	0x200000u
 -#define ___GFP_WRITE		0x400000u
 -#define ___GFP_KMEMCG		0x800000u
 +#define ___GFP_NOTRACK		0x200000u
 +#define ___GFP_NO_KSWAPD	0x400000u
 +#define ___GFP_OTHER_NODE	0x800000u
 +#define ___GFP_WRITE		0x1000000u
++#define ___GFP_KMEMCG		0x2000000u
 =20
  /*
   * GFP bitmasks..
@@@ -86,17 -86,16 +87,17 @@@
  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is =
reclaimable */
  #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track wit=
h kmemcheck */
 =20
 +#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
  #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf =
of other node */
  #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to=
 dirty page */
-=20
+ #define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes f=
rom a memcg-accounted resource */
  /*
   * This may seem redundant, but it's a way of annotating false positives =
vs.
   * allocations that simply cannot be supported (e.g. page tables).
   */
  #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 =20
- #define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
 -#define __GFP_BITS_SHIFT 24	/* Room for N __GFP_FOO bits */
++#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 =20
  /* This equals 0, but use constants in case they ever change */

--Signature=_Tue__11_Dec_2012_16_22_10_+1100_47Dq_BgxXCrUHXUp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxsMCAAoJEECxmPOUX5FEi+sQAI7sC523B9oJ1PWmplTfaQj4
wF9GoGOOgBUoxKYr0iuz71aEd79FVuj+PF7YSbMXYXn3Gfo3SwlE0H0EGzTidG2u
pawsMk604P1crk61G8rvriuV1Q4kCk6itrQ/16S3ocR5+cBNUHKvsl/FMGMvxYzu
z9Z08EYlzm6ltdAu4NDcNXsJRCDL2m2Pd6E1np0HT5UK2u4sbLli42zdlHgYiwYy
uu9+/rBXFVvVdYoa0Zu5oPZxhwxsg3E+m4J/1LUt0AVqCXwCqj17AApIbIr1euQZ
jt87mA5sQBM0JLPqJp88iUOPbzck+YtdXvYLK6Wemr0ix6hsbyTbnpfalsniv3/B
E5MJPkEyIwKnURX8w1/tRBX/tRDJNOFBn0jDm4CCmXpw4tWa2P8ZInI8r119eK/M
AcylKewU5BnDIc2uG6MmghNu/hfG06KsAUHnPHQOk322IHvlkWlUiFWIpvONSOhl
SAo6oJeM2nM0kQcU3SJKM/4uNF348fIlfyytkHKn6HoM3QYk+w0lWbqW5+rlIOTY
hJZIVRt3ogNJ+AXiDjts5RKhpMBsswdZdyDbAMJ9jlBOhjxm1c+tnkjYzHPxND0U
mQARM65wjXijBif0senzZh6WMD5D/5ecXo7M9urzfLq9Hy5qAMvVQFbPG9wgtr+P
ZciFsjeL1K/OqSe0CdHd
=YI+g
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Dec_2012_16_22_10_+1100_47Dq_BgxXCrUHXUp--
