Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2EaDuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 23:50:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47107 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2EaDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 23:50:22 -0400
Date: Thu, 31 May 2012 13:50:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20120531135013.a7ac23ab7cbc5c3e71211be0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_13_50_13_+1000_QYr4VdZJkCB5J.C+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_13_50_13_+1000_QYr4VdZJkCB5J.C+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/memcontrol.c between commit a0db00fcf5da ("memcg: remove redundant
parentheses") from Linus' tree and commit "memcg: track resource index in
cftype private" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index ffa9490,4ebe680..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -404,9 -391,14 +404,14 @@@ enum charge_type=20
  #define _MEM			(0)
  #define _MEMSWAP		(1)
  #define _OOM_TYPE		(2)
- #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
- #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
- #define MEMFILE_ATTR(val)	((val) & 0xffff)
+ #define _MEMHUGETLB		(3)
+=20
+ /*  0 ... val ...16.... x...24...idx...32*/
 -#define __MEMFILE_PRIVATE(idx, x, val)	(((idx) << 24) | ((x) << 16) | (va=
l))
++#define __MEMFILE_PRIVATE(idx, x, val)	((idx) << 24 | (x) << 16 | (val))
+ #define MEMFILE_PRIVATE(x, val)		__MEMFILE_PRIVATE(0, x, val)
 -#define MEMFILE_TYPE(val)		(((val) >> 16) & 0xff)
 -#define MEMFILE_IDX(val)		(((val) >> 24) & 0xff)
++#define MEMFILE_TYPE(val)		((val) >> 16 & 0xff)
++#define MEMFILE_IDX(val)		((val) >> 24 & 0xff)
+ #define MEMFILE_ATTR(val)		((val) & 0xffff)
  /* Used for OOM nofiier */
  #define OOM_CONTROL		(0)
 =20

--Signature=_Thu__31_May_2012_13_50_13_+1000_QYr4VdZJkCB5J.C+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxup1AAoJEECxmPOUX5FE6R0P/3LacTWq81fUOpo3/fRh6kuU
XDsBFCIoWKJOxYdEcYYl5/rWTobsctCwAn1YggFyf+38sR+/RjUpUYtVVjujT+Ht
wp2C5rM231UAXAsyazyUMML1uN3/Gwqt7ic6k9r7EKRlMucK+h9Zky/12ytnOonp
bnTCj9HqJg+owem6pF8fnJQlxSlhHt6qZ5aw+3/GvBtJokpCzP93ih5ynxYtgInQ
gtYHWu73qixzPQSPMwRj9/yFTaqe7d9y+CpAI/bD2HQzg3lu/spClJ8CX/knC5Ct
HvhQjXJEl2A6E55nTNetfZ4VQa1mZEOtP3QmlPc/Ox7p1HKrL2Qv/q5z2KDBiAB2
x6PTZwvV+JxPp2bHzqLpwHyOxdAcgDKm8uUw4/CnmUMYVoVmivlkHXGT6yvO723t
qiUctW+qr0C6OrR29IySd9aAZXj6qJR5qLmatMDWhNAJosMKHhN/im6MjTKhDjBj
2EG4WNDn+V1/xIn4KVpRVbpjKryvjBsbBcL70ZocPMHqar95kY5j71RuyBXWk5/r
sMFK458dsIa4eW7CHo7aJlhkMqZTDXCvUSgt687lkBMRuWDw9HZSSv0xnRTQfOaf
dKXCJwC+VQhfZL0Ww7NMRZwSwCiEtZAtFtZX9l8/kIgrk+Ltv5e4zXizN6Af+xvG
X84xf21o95crTYjyUmm1
=z3XF
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_13_50_13_+1000_QYr4VdZJkCB5J.C+--
