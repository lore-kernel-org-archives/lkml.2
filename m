Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1HZCJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 22:09:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58380 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab1HZCJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 22:09:09 -0400
Date: Fri, 26 Aug 2011 12:09:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH] bio: use a static inline function for bio_integrity_clone
Message-Id: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_BLK_DEV_INTEGRITY is not set, we get these warnings:

drivers/md/dm.c: In function 'split_bvec':
drivers/md/dm.c:1061:3: warning: statement with no effect
drivers/md/dm.c: In function 'clone_bio':
drivers/md/dm.c:1088:3: warning: statement with no effect

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/bio.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ce33e68..c98ecc8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -527,7 +527,11 @@ extern void bio_integrity_init(void);
 #define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c, d)	(0)
+static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
+				      gfp_t gfp_mask, struct bio_set *bs)
+{
+	return 0;
+}
 #define bioset_integrity_free(a)	do { } while (0)
 #define bio_integrity_free(a, b)	do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
