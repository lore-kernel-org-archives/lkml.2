Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2ALDm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 22:42:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57671 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2ALDm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 22:42:26 -0500
Date: Thu, 12 Jan 2012 14:42:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] blockdev: convert some macros to static inlines
Message-Id: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jan_2012_14_42_15_+1100_OtKYSxRv7J+ZvNol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jan_2012_14_42_15_+1100_OtKYSxRv7J+ZvNol
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We prefer to program in C rather than preprocessor and it fixes this
warning when CONFIG_BLK_DEV_INTEGRITY is not set:

drivers/md/dm-table.c: In function 'dm_table_set_integrity':
drivers/md/dm-table.c:1285:3: warning: statement with no effect [-Wunused-v=
alue]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/blkdev.h |   77 +++++++++++++++++++++++++++++++++++++++-----=
---
 1 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 94acd81..f0812bd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1279,19 +1279,70 @@ queue_max_integrity_segments(struct request_queue *=
q)
=20
 #else /* CONFIG_BLK_DEV_INTEGRITY */
=20
-#define blk_integrity_rq(rq)			(0)
-#define blk_rq_count_integrity_sg(a, b)		(0)
-#define blk_rq_map_integrity_sg(a, b, c)	(0)
-#define bdev_get_integrity(a)			(0)
-#define blk_get_integrity(a)			(0)
-#define blk_integrity_compare(a, b)		(0)
-#define blk_integrity_register(a, b)		(0)
-#define blk_integrity_unregister(a)		do { } while (0)
-#define blk_queue_max_integrity_segments(a, b)	do { } while (0)
-#define queue_max_integrity_segments(a)		(0)
-#define blk_integrity_merge_rq(a, b, c)		(0)
-#define blk_integrity_merge_bio(a, b, c)	(0)
-#define blk_integrity_is_initialized(a)		(0)
+struct bio;
+struct block_device;
+struct gendisk;
+struct blk_integrity;
+
+static inline int blk_integrity_rq(struct request *rq)
+{
+	return 0;
+}
+static inline int blk_rq_count_integrity_sg(struct request_queue *q,
+					    struct bio *b)
+{
+	return 0;
+}
+static inline int blk_rq_map_integrity_sg(struct request_queue *q,
+					  struct bio *b,
+					  struct scatterlist *s)
+{
+	return 0;
+}
+static inline struct blk_integrity *bdev_get_integrity(struct block_device=
 *b)
+{
+	return 0;
+}
+static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+{
+	return NULL;
+}
+static inline int blk_integrity_compare(struct gendisk *a, struct gendisk =
*b)
+{
+	return 0;
+}
+static inline int blk_integrity_register(struct gendisk *d,
+					 struct blk_integrity *b)
+{
+	return 0;
+}
+static inline void blk_integrity_unregister(struct gendisk *d)
+{
+}
+static inline void blk_queue_max_integrity_segments(struct request_queue *=
q,
+						    unsigned int segs)
+{
+}
+static inline unsigned short queue_max_integrity_segments(struct request_q=
ueue *q)
+{
+	return 0;
+}
+static inline int blk_integrity_merge_rq(struct request_queue *rq,
+					 struct request *r1,
+					 struct request *r2)
+{
+	return 0;
+}
+static inline int blk_integrity_merge_bio(struct request_queue *rq,
+					  struct request *r,
+					  struct bio *b)
+{
+	return 0;
+}
+static inline bool blk_integrity_is_initialized(struct gendisk *g)
+{
+	return 0;
+}
=20
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
=20
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Jan_2012_14_42_15_+1100_OtKYSxRv7J+ZvNol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDlaXAAoJEECxmPOUX5FEgqMP/3jLnVVK/+9y53uiWUpVPrtA
d1Yb1oMC8UPFXZ01xSLiweILPd99LWTfaimUsZQ9ckPw7RrgE9zIhezslfpb4K8V
LtM/++Sz5EISDSXveRnO2cdekxc8S9RkdHuIF1d0A4kFn/5A7nn0kAEBbcodEehK
E3ojoxtCV5drn/UmUcl0W81pM2/Iinq57DOcYP9seKInsXK9JsZgnkRxsa8gC8RT
scp+5gMBw74ZMtEwDc0cfxhysEuRSeECDN7jv10b2insES1Q9wKO+4F+7bXdJzor
TpBYzomT1OzpSsV5Wwx1fKvE0a3LAeaVsoWqAB7B8rhIDd9q5czoxMFSsCNkJzDp
krZWoBlnG8aIABqvjLsbXMwFmEXBFaWA14A43JGFDFbIWNuM3V62W1j/p4ug+ZwL
oIfIRHPUrZigIBXPvX4kB3VSWG05tDEOBUx2OKh+4Hlm+26tDj2Ps3JS0IYPiOvy
GZ174TCXpU/7S7m9hvEWRS3jsRz+gBrnnNJnEBBZbD3hWvTsoh3SADZH6SWq0Lxw
bJMJt0ysg0oPfK/5foWbbsK1l1hxr8qwDBYh8oWBZmQfN1DK78rB8dQPoyncH7F8
qc74LnKcprYgBwt6C8kbcwBc0eOxaB0YUlz6lKa1jjy3VVjIug7t5RmwqcVC0sRG
s6ADu9oDaZLEtKA7Kw0z
=7X+i
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jan_2012_14_42_15_+1100_OtKYSxRv7J+ZvNol--
