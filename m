Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2DQPMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:12:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64476 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2DQPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:12:46 -0400
From: Laura Vasilescu <laura@rosedu.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Laura Vasilescu <laura@rosedu.org>
Subject: [PATCH] fs/bio: fix checkpatch errors
Date: Tue, 17 Apr 2012 18:12:36 +0300
Message-Id: <1334675556-10758-1-git-send-email-laura@rosedu.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laura Vasilescu <laura@rosedu.org>
---
 fs/bio.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e453924..bafd81f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -434,13 +434,13 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
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
@@ -466,11 +466,12 @@ EXPORT_SYMBOL(__bio_clone);
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
+				fs_bio_set);
 
 	if (!b)
 		return NULL;
@@ -552,7 +553,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 					.bi_rw = bio->bi_rw,
 				};
 
-				if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
+				if (q->merge_bvec_fn(q, &bvm, prev) <
+								prev->bv_len) {
 					prev->bv_len -= len;
 					return 0;
 				}
@@ -678,7 +680,8 @@ static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
 			     struct sg_iovec *iov, int iov_count,
 			     int is_our_pages)
 {
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
+	memcpy(bmd->iovecs, bio->bi_io_vec,
+		sizeof(struct bio_vec) * bio->bi_vcnt);
 	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
 	bmd->nr_sgvecs = iov_count;
 	bmd->is_our_pages = is_our_pages;
@@ -902,7 +905,8 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count,
+				0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
@@ -1011,7 +1015,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
 			if (len <= 0)
 				break;
-			
+
 			if (bytes > len)
 				bytes = len;
 
@@ -1048,7 +1052,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
  out_unmap:
 	for (i = 0; i < nr_pages; i++) {
-		if(!pages[i])
+		if (!pages[i])
 			break;
 		page_cache_release(pages[i]);
 	}
@@ -1656,7 +1660,7 @@ static void __init biovec_init_slabs(void)
 
 		size = bvs->nr_vecs * sizeof(struct bio_vec);
 		bvs->slab = kmem_cache_create(bvs->name, size, 0,
-                                SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 	}
 }
 
-- 
1.7.1

