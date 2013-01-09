Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3AIIPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:15:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57731 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3AIIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:14:59 -0500
X-AuditID: 9c930197-b7cefae0000002d7-71-50ed27016949
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Kent Overstreet <koverstreet@google.com>
Subject: [PATCH] Fix build error due to bio_endio_batch
Date: Wed,  9 Jan 2013 17:14:55 +0900
Message-Id: <1357719296-10562-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes build error of recent mmotm.

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
I don't know who already fix it.

 include/linux/bio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ad62bdb..5f5491767 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -69,6 +69,8 @@
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
@@ -542,8 +544,6 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
-void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
-
 static inline void batch_complete_init(struct batch_complete *batch)
 {
 	bio_list_init(&batch->bio);
-- 
1.7.9.5

