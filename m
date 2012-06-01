Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2FADPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:15:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40746 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2FADPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:15:07 -0400
Date: Fri, 1 Jun 2012 13:14:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (vfs tree
 related)
Message-Id: <20120601131458.7521e802e5af64d2ec4d311d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Jun_2012_13_14_58_+1000_MQ0nTZ22IHQzY9sE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jun_2012_13_14_58_+1000_MQ0nTZ22IHQzY9sE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

security/security.c: In function 'mmap_prot':
security/security.c:670:31: error: 'READ_IMPLIES_EXEC' undeclared (first us=
e in this function)

Caused by commit 185b26574c03 ("take security_mmap_file() outside of
->mmap_sem") from the vfs tree.  Missing include of linux/personality.h.

I have added this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Jun 2012 13:10:47 +1000
Subject: [PATCH] security: using READ_IMPLIES_EXEC needs personality.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 security/security.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index 257fe77..3efc9b1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -22,6 +22,7 @@
 #include <linux/fsnotify.h>
 #include <linux/mman.h>
 #include <linux/mount.h>
+#include <linux/personality.h>
 #include <net/flow.h>
=20
 #define MAX_LSM_EVM_XATTR	2
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Jun_2012_13_14_58_+1000_MQ0nTZ22IHQzY9sE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPyDOyAAoJEECxmPOUX5FE0MMP/1DmBAWlZrIyLb5dODamhwJ8
V500oeq4Kl0/a4ArUEy/Eoo//iWBH/7wZppO9HZ6zRBjbP+jbMzPw3DrDjIMDxI3
NNVKO0KCBlkwuWxOw2qRBHhp0VSmFzwAYqhinG3XzO1SGU2VMF9B2pTXDqQ715Pk
nR2v0DZKJKggxxOcp5iDu1qgN0z7LMp7YW5kg2UslSat45Zsb9tRFfBGjQHGsr4E
wuksQ7mLFilXgkuIzFMJd/n7nyq88DbHBeBtYMNa3H4OVGBsc7aefHdnANkOuP8e
tsLrVEzmF61QWsobbMYOfFDZkkGwtUj55ldwh6YMBukBlrnHMZzRGvi+9NFx7FMo
glaq2MMtVwdMmppG7HtQoAUw0de+BNqTYqaRiiVnvk6FHlnFi2p+DsqCMUnM7i8V
hakufwBuQh2oTiwmO43qpQgVnSJJZmdTtXNZYPcLgpMB/za4ByyQYKQWpQkpc655
djgX3Z8n/U6vNkHgGlyc10gqLTfvFfe6YtYkVceNMIyl1P+PLebQ0UgJ1xRU0S74
1xcS2JRZEqOH1Xqfp2tfXtTGzHvJtlm/4vgm3S+No2K2coZQffqo2RB4era6FpK4
YJEQUER8Xd0KSO/wg57A7kWcAVtU4G5ONFspsYGJQzIpKz6H+Egzu9gIhZYXafhC
sT36GOeY2Pszz5n60Xmc
=+mVb
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jun_2012_13_14_58_+1000_MQ0nTZ22IHQzY9sE--
