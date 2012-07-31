Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2GaElF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:41:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50837 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2GaElD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:41:03 -0400
Date: Tue, 31 Jul 2012 14:40:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Michel Lespinasse <walken@google.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120731144054.59b0a6da6d071ea1bc061db0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_14_40_54_+1000_gNgMG/1b=a7IM6rX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_14_40_54_+1000_gNgMG/1b=a7IM6rX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/ceph/osd_client.c: In function 'ceph_osdc_alloc_request':
net/ceph/osd_client.c:216:2: error: implicit declaration of function 'rb_in=
it_node' [-Werror=3Dimplicit-function-declaration]

Caused by commit 753b960e52b7 ("rbtree: empty nodes have no color") from
the akpm tree interacting with commit cd43045c2de6 ("libceph: initialize
rb, list nodes in ceph_osd_request") from the ceph tree.

I added the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 31 Jul 2012 14:37:35 +1000
Subject: [PATCH] libceph: remove rb_node initialisation

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/ceph/osd_client.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ad427e6..06fb7a9 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -213,7 +213,6 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct=
 ceph_osd_client *osdc,
 	kref_init(&req->r_kref);
 	init_completion(&req->r_completion);
 	init_completion(&req->r_safe_completion);
-	rb_init_node(&req->r_node);
 	INIT_LIST_HEAD(&req->r_unsafe_item);
 	INIT_LIST_HEAD(&req->r_linger_item);
 	INIT_LIST_HEAD(&req->r_linger_osd);
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_14_40_54_+1000_gNgMG/1b=a7IM6rX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF2HWAAoJEECxmPOUX5FE1V4P/3Xf1GU5E55ET0ijKSRoEobx
2v4HrvYfGFBgRdXiNp41tgiLRLcscfFrsSM7bfsSYp7CT3Yoe3WvAnk8SZwKmZck
/szbY5eLJARTBS84LnzATVz+BJvGbxBgS5U74+knm+HXdMZd2Baf48SVwR97mF3F
W6y/IkzNdV/fqvUU8S/HiJf+6YX+CttACF/u5xIFcmt7LYD5g+eFE0oyqL11IWX0
/JWZCitAULXmyvpXSu4UfYwhGC3I9kvjYM4KyTirA4rYfO81ZSM8FmL8S0EHa5qR
oLF2trEmHiDK5DTWoMfN6txelQ28s0tFMFIWM4ou0yKCarh6oK8+R+PPg/xmsAev
XyHaCkVHF2x1iGqAQiI9gpvXbPS30Ju3CvdaARyRYauAmcx5gP2eSkxtCcFOHmql
KmkehyDcruaSx5upI7zN0EItiTTiTT+2nVjg21lCUs7miuvlF629ns+9EwQynKpO
fQ3IPliBzOHeCm5c3at3KDGzD3RDrskCjlqJN54yeTtIiOYfc6mJEG57eioFa2Pa
p0PzaVaZL9pUQxL670PV7ffy1fx1BjsmxzUjWS5LzJWEyVoGFEn1pwdrqbDga09Y
TSS63b4+v0bCwq9d7DgLO0THJ6RPhjWbLzkc80IV8ZlmVgrD6REewAIktTCRK9Pz
B6Ur7aaxPzJ1BcKYmGM1
=XruD
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_14_40_54_+1000_gNgMG/1b=a7IM6rX--
