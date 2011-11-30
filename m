Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1K3CT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:28 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59162 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:25 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/28] bio: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:24 -0800
Message-Id: <13e19717dc9fe50594b0b9c0a17b1181ae5f4c34.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One long line was ignored.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/bio.c | \
  cut -f3- -d":" | sort | uniq -c
      1  ERROR: code indent should use tabs where possible
      1  ERROR: space required before the open parenthesis '('
      1  ERROR: trailing whitespace
      4  WARNING: line over 80 characters
      5  WARNING: please, no space before tabs
      1  WARNING: please, no spaces at the start of a line

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/bio.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 98acfb1..6c62472 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -437,13 +437,13 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 EXPORT_SYMBOL(bio_phys_segments);
 
 /**
- * 	__bio_clone	-	clone a bio
- * 	@bio: destination bio
- * 	@bio_src: bio to clone
+ *	__bio_clone	-	clone a bio
+ *	@bio: destination bio
+ *	@bio_src: bio to clone
  *
  *	Clone a &bio. Caller will own the returned bio, but not
  *	the actual data it points to. Reference count of returned
- * 	bio will be one.
+ *	bio will be one.
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
@@ -469,11 +469,12 @@ EXPORT_SYMBOL(__bio_clone);
  *	@bio: bio to clone
  *	@gfp_mask: allocation priority
  *
- * 	Like __bio_clone, only also allocates the returned bio
+ *	Like __bio_clone, only also allocates the returned bio
  */
 struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs,
+					 fs_bio_set);
 
 	if (!b)
 		return NULL;
@@ -685,7 +686,8 @@ static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
 			     struct sg_iovec *iov, int iov_count,
 			     int is_our_pages)
 {
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
+	memcpy(bmd->iovecs, bio->bi_io_vec,
+	       sizeof(struct bio_vec) * bio->bi_vcnt);
 	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
 	bmd->nr_sgvecs = iov_count;
 	bmd->is_our_pages = is_our_pages;
@@ -909,7 +911,8 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov,
+				     iov_count, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
@@ -1018,7 +1021,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
 			if (len <= 0)
 				break;
-			
+
 			if (bytes > len)
 				bytes = len;
 
@@ -1055,7 +1058,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
  out_unmap:
 	for (i = 0; i < nr_pages; i++) {
-		if(!pages[i])
+		if (!pages[i])
 			break;
 		page_cache_release(pages[i]);
 	}
@@ -1663,7 +1666,8 @@ static void __init biovec_init_slabs(void)
 
 		size = bvs->nr_vecs * sizeof(struct bio_vec);
 		bvs->slab = kmem_cache_create(bvs->name, size, 0,
-                                SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+					      SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+					      NULL);
 	}
 }
 
-- 
1.7.6.405.gc1be0

