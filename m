Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1FQCug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:50:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50437 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1FQCuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fZjRO5AKAxu00L5J88ppWwPOPtx8wZAmnq8xlTQP23CtiU5Ha24KVJUQPPn9mWGfzJ
         8V0ZAmSs9ZAjJJKlrc+pKo+hvmg+c8S+lVecX+xcXFCkEatoCm59ZWtwhYGO4PXad9t+
         wpIJzJLF4Yb8lzXVsdF4Gpt57Miu+ME74z4MQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH RESEND] block: add REQ_SECURE to REQ_COMMON_MASK
Date: Fri, 17 Jun 2011 11:43:28 +0900
Message-Id: <1308278608-3284-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add REQ_SECURE flag to REQ_COMMON_MASK so that
init_request_from_bio() can pass it to @req->cmd_flags.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
---
 include/linux/blk_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a7cea53ca0d..6395692b2e7a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -167,7 +167,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-- 
1.7.5.2

