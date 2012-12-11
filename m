Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2LKFZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:25:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57350 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2LKFZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:25:09 -0500
Date: Tue, 11 Dec 2012 16:25:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121211162507.41aae7985ee91d4e185556d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Dec_2012_16_25_07_+1100_vdG1seLKfsjiydmj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Dec_2012_16_25_07_+1100_vdG1seLKfsjiydmj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/gfp.h between commit caf491916b1c ("Revert "revert "Revert
"mm: remove __GFP_NO_KSWAPD""" and associated damage") from Linus' tree
and commit "mm: add a reminder comment for __GFP_BITS_SHIFT" from the
akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/gfp.h
index 976a8e3,c0fb4d8..0000000
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@@ -30,11 -30,11 +30,12 @@@ struct vm_area_struct
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
 +#define ___GFP_KMEMCG		0x2000000u
+ /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 =20
  /*
   * GFP bitmasks..

--Signature=_Tue__11_Dec_2012_16_25_07_+1100_vdG1seLKfsjiydmj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxsOzAAoJEECxmPOUX5FEpdAP/1MgqZLwMXJfJxHv6KETsnaZ
WJcI03xvl2W2LcMgX6y1DspVZJg6VEQ+0AfenkG7c4B0sEeLkeEe/lTm/xusxXa4
CVnqGPKu2mlsPm9g5J8tGW+oTGsOYGhl0jqd01FzpwrRduv0epmZJOD7Vn3JyPrb
nA05/8DEhHH/j8c1CFg/WAftMSy5a68egJyhzmv1S+EZs4ka7AAbXjDDPASo3NHV
UkG1qwt1v/9nwi5B2SkpubUNPMO8TeSnWb/Ma2PPlL5LjiielK3R/qgoiuD/Egng
dElmR1tXh44E6TDxkiexgN7r+/vsP36rVjFFQjn+ZaFAI8EhZOdYIWnWuQf2wzFd
7zLGCYnehLK1lKdtp0iFSxZYCbXjQB+e89fXbydasD3mZO0qBrp4ABNBSi5xl5S5
NTmHL2r2WcGOQV/rU2ThSBLzUjVnsh/iK4csZvZEYvQqU1Z8FRBkwIPg6ES72xjo
cdKytEChzLfbDCtHM6xc1AiUSWTbiPog+uwMrUm3G7wbqu5bLh14OJ8N2Gt/ajyV
i6syjEPMegCE5+hgru4MO4CciJ2TbKNFfIZyZa6pzB7FcrkEPzZjD97YRnk/o1bW
aRqgpHJF2x6omRyDyCvbnrzR5wSVbiOPdXBCdZS5Y+VOHYClj6kI3m5jq+Ee3wcI
xG2zKfmLrd52S78KmDkz
=iogl
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Dec_2012_16_25_07_+1100_vdG1seLKfsjiydmj--
