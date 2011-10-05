Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab1JEIHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:07:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54129 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1JEIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:07:35 -0400
Date: Wed, 5 Oct 2011 19:07:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Ledford <dledford@redhat.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20111005190726.1c09bf91a67b7a264ca61b61@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_19_07_26_+1100_MtgDfSmWyeJ2qpwc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_19_07_26_+1100_MtgDfSmWyeJ2qpwc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ipc/mqueue.c: In function 'mqueue_get_inode':
ipc/mqueue.c:154:4: error: implicit declaration of function 'vmalloc'
ipc/mqueue.c:154:19: warning: assignment makes pointer from integer without=
 a cast
ipc/mqueue.c: In function 'mqueue_evict_inode':
ipc/mqueue.c:278:3: error: implicit declaration of function 'vfree'

Caused by commit 8a53f9442429 ("ipc/mqueue: update maximums for the
mqueue subsystem").  See Rule 1 in Documentation/SubmitChecklist.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 5 Oct 2011 19:05:10 +1100
Subject: [PATCH] ipc/mqueue: vlammoc requires vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 ipc/mqueue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 0474ddb..229a5fb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -33,6 +33,7 @@
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
=20
 #include <net/sock.h>
 #include "util.h"
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_19_07_26_+1100_MtgDfSmWyeJ2qpwc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjBA+AAoJEECxmPOUX5FE0i8P/3h+qk4pO9tzHY44dX/hIdv4
ZXuBH0Si77UsV3f0FpCUcrSaAJdj3B6DdlFUu9OAnoUH9TNiTqA4PVLwoAt2/P2D
sNb7KfLr8qcOw0zHCZ3ptw617C9Jr8BT3z39o310nNXyIX9+bfafUyvimzbXLC9o
OBlB5hLpGaeOUzHr7qwQW2fLkqh/lIiJARlLbG+03hKgyzcdK+ayZg2F2QoDt6Fh
QP0s5+pUO5W5VUL9lsWFANwBpMULYOFUW1uKwoD5UrCzpkvSDcLQ7YUV53+GIkuP
5PpTonQfduj0kzcFYG+PzRHsE41niOZ6Nrmrv5w5UcCYoO1+ARWvl9GLSoSxKFwU
WICfoUIIAaWPr0Cqb3QyH7E1Sm2Xzolix0UiYGvYZ85G900iA+ebzksI4b3spjuG
GOtmyB/qXoK7meFzA3DhgKAS5f1Wtic1WlSzQslnrPc4vjXNUon4gaaQB40Tj9eA
BtJYyfqeaNwMjvDJUwDR//MpvldKmbL0D2RIw9wte4MepxRX8Y2Nq1DWZXPbvCzb
f2T41NZE3ATRBaTbmQYpwLyNGr2JDQYDAHNGiznln4GJ4lP2+mXODkjYvD+fzzdl
sQiM4h8IaDzwG7snwEtn3EA3CxSBUnunn86PZ6tOZLBBIUYLGSzGB3qJHBgFsAEk
brm41gCMN0W5fd9i5Vwu
=s8Yu
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_19_07_26_+1100_MtgDfSmWyeJ2qpwc--
