Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1K0Fgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1K0Fgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:36:48 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH 44/62] ocfs2: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:24 +0800
Message-Id: <1322371662-26166-45-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/ocfs2/aops.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c1efe93..61f93a5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -102,7 +102,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 		 * copy, the data is still good. */
 		if (buffer_jbd(buffer_cache_bh)
 		    && ocfs2_inode_is_new(inode)) {
-			kaddr = kmap_atomic(bh_result->b_page, KM_USER0);
+			kaddr = kmap_atomic(bh_result->b_page);
 			if (!kaddr) {
 				mlog(ML_ERROR, "couldn't kmap!\n");
 				goto bail;
@@ -110,7 +110,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 			memcpy(kaddr + (bh_result->b_size * iblock),
 			       buffer_cache_bh->b_data,
 			       bh_result->b_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			set_buffer_uptodate(bh_result);
 		}
 		brelse(buffer_cache_bh);
@@ -236,13 +236,13 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 		return -EROFS;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	if (size)
 		memcpy(kaddr, di->id2.i_data.id_data, size);
 	/* Clear the remaining part of the page */
 	memset(kaddr + size, 0, PAGE_CACHE_SIZE - size);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	SetPageUptodate(page);
 
@@ -671,7 +671,7 @@ static void ocfs2_clear_page_regions(struct page *page,
 
 	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 
 	if (from || to) {
 		if (from > cluster_start)
@@ -682,7 +682,7 @@ static void ocfs2_clear_page_regions(struct page *page,
 		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
 	}
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 /*
@@ -1928,9 +1928,9 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 		}
 	}
 
-	kaddr = kmap_atomic(wc->w_target_page, KM_USER0);
+	kaddr = kmap_atomic(wc->w_target_page);
 	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	trace_ocfs2_write_end_inline(
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-- 
1.7.4.4

