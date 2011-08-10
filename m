Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1HJGeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:34:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57879 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HJGeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:34:15 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/2] Move some REQ flags to the common bio/request area
Date: Wed, 10 Aug 2011 15:32:03 +0900
Message-Id: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

REQ_SECURE, REQ_FLUSH and REQ_FUA may all be set on a bio as well as
on a request, so relocate them to the shared part of the enum.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/blk_types.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6395692b2e7a..32f0076e844b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -125,7 +125,11 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+	__REQ_FUA,		/* forced unit access */
+	__REQ_FLUSH,		/* request for cache flush */
 
 	/* bio only flags */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
@@ -135,7 +139,6 @@ enum rq_flag_bits {
 	/* request only flags */
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
-	__REQ_FUA,		/* forced unit access */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
 	__REQ_DONTPREP,		/* don't call prep for this one */
@@ -146,11 +149,9 @@ enum rq_flag_bits {
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
-	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
-	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_NR_BITS,		/* stops here */
 };
 
-- 
1.7.6

