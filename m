Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161724Ab2CSGAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:00:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32884 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161506Ab2CSGAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:00:00 -0400
Date: Mon, 19 Mar 2012 16:59:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the moduleh tree with the vfs tree
Message-Id: <20120319165951.947778b342e1ff5c56bee151@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_16_59_51_+1100_KEvQYDolWSltT4gy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_16_59_51_+1100_KEvQYDolWSltT4gy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
include/linux/reiserfs_fs.h between commit e9876523cf40 ("move private
bits of reiserfs_fs.h to fs/reiserfs/reiserfs.h") from the vfs tree and
commit 187f1882b5b0 ("BUG: headers with BUG/BUG_ON etc. need
linux/bug.h") from the moduleh tree.

The former commit gutted this file so that the latter patch is no longer
needed.   I also added the following patch as a merge fix.

Al: this could be added to your tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 19 Mar 2012 16:43:56 +1100
Subject: [PATCH] reiserfs: reiserfs.h uses BUG so should include bug.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/reiserfs/reiserfs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 445d768..a59d271 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 #include <linux/workqueue.h>
 #include <asm/unaligned.h>
 #include <linux/bitops.h>
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_16_59_51_+1100_KEvQYDolWSltT4gy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZstXAAoJEECxmPOUX5FERzkP/jhMeDmDPMvE2F/Xl+DLeU1Q
7MWrW54S2RMYnt9InzwWDXYKRk+gtjaT4jhK06sW5KO6FUL74jKLT8/EAPd0ojuF
VJ5mTIPLqOhP8WX4temgUOJjDJrqNaMjrEDedwldpGxYpt9ArqLvqzq5f/gDoEd/
dhixDqM1OWVYM7K2O5bvYFWAZ4A0AOGmTEI/V2Ob3BBmZj9jNorUu5WaoE1wqsEU
R8XVMO/GsG34dSVHZIsnirHUw9/2dlEJ1OHO3qwNKKZvEeReDbwAS8qbOy5vY7oK
V2hbUTGapq1WGoeSaWVi97ueAjmgxmf0nqXcfNn7ACyjWVieH62kzxfQ+wnW96m5
TyqtYOA1a/ahgHlK469DP4YGxP1QqVkBJY66pD1vdbtV/o0U/pfOPRAd3Ok9PtCe
kaoCgtFuFMOtwce12x/mqEpRsFvG1iSAzvxzj7AwPzD3l8DBgAKnABeDqMdE2MtK
7Lwa5AKa/0qoYV3Kb17GBgDJcEoeLHZ2v/dVTIeM4PEpcc2H2cfIxrJH5TFBQhNA
yJR39My4jVolX1uXXOm6AhAUgZaiVaVkp/j/wQaqSLm8TpytkJhqFWhXcSoEMICu
v9k8tFO2kj6PpzFfbe1qiNpM7lSC1mrnjL6pLkEolJQtjb+l+B+4soQBU0HqsO71
6JDKGbNkDpIr6ehbvnht
=xhJc
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_16_59_51_+1100_KEvQYDolWSltT4gy--
