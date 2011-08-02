Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1HBFNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:13:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50359 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1HBFNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:13:16 -0400
Date: Tue, 2 Aug 2011 15:13:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110802151306.4fb9904e55fe9b489a3cf29d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_15_13_06_+1000_+0lQUysRTQlX8bQT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_15_13_06_+1000_+0lQUysRTQlX8bQT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/md/persistent-data/dm-block-manager.c:961:16: error: expected decla=
ration specifiers or '...' before string constant
drivers/md/persistent-data/dm-block-manager.c:961:1: warning: data definiti=
on has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:961:1: warning: type defaults=
 to 'int' in declaration of 'MODULE_LICENSE'
drivers/md/persistent-data/dm-block-manager.c:961:16: warning: function dec=
laration isn't a prototype
drivers/md/persistent-data/dm-block-manager.c:962:15: error: expected decla=
ration specifiers or '...' before string constant
drivers/md/persistent-data/dm-block-manager.c:962:1: warning: data definiti=
on has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:962:1: warning: type defaults=
 to 'int' in declaration of 'MODULE_AUTHOR'
drivers/md/persistent-data/dm-block-manager.c:962:15: warning: function dec=
laration isn't a prototype
drivers/md/persistent-data/dm-block-manager.c:963:20: error: expected decla=
ration specifiers or '...' before string constant
drivers/md/persistent-data/dm-block-manager.c:963:1: warning: data definiti=
on has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:963:1: warning: type defaults=
 to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/md/persistent-data/dm-block-manager.c:963:20: warning: function dec=
laration isn't a prototype

Caused by an interaction between the module.h split up and commit
29a226094ff6 ("The persistent-data library offers a re-usable framework
for the storage") from the device-mapper tree.  Previous versions of this
file only needed export.h, but the current one needs module.h.  The
following is an incremental patch on top of the one that added export.h.
I will amend the other patch for tomorrow.

This really is a bug in the original patch as you should explicitly
include module.h if you are using the module facilities.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Aug 2011 15:06:14 +1000
Subject: [PATCH] dm: include module.h since its facilities are used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/persistent-data/dm-block-manager.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/per=
sistent-data/dm-block-manager.c
index 842bd66..b479953 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -9,7 +9,7 @@
 #include <linux/dm-io.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
-#include <linux/export.h>
+#include <linux/module.h>
=20
 #define DM_MSG_PREFIX "block manager"
=20
--=20
1.7.5.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Aug_2011_15_13_06_+1000_+0lQUysRTQlX8bQT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON4diAAoJEDMEi1NhKgbsTLcIAJDoOVTAtf/XTnU0vtihBUub
K6Ewz28gZqCOum/BNjpS353kNv8Bc6CJPQuplBEzWvjBEPzZ7g955os2zIB151zD
wnnNYdIpI315wmoQKhomxNtQObk/+Iuer/gsylFb+ra5KtbTVxAXPzCFQSD3OQDJ
MQ+jRMylyvLcOSUS5CPjEjvz06Uuv0oe5UqPrNWxop+4NLbVNaqh0c3wEWO+rN5g
Qhjc4N7ETRp7hEh03PNjljeTZDqHPUMpwkCOlLaQBf96PSf1ho8/CZaDfmz9/EpD
Nrmr4v8GUkFLlnHlULjL5oMhu2kQW9ioHSzbOpG46TnkHPJx5y+NUVi09hBYAI4=
=vnY7
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_15_13_06_+1000_+0lQUysRTQlX8bQT--
