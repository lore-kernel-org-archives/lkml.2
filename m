Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0ICJi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:38:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33600 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0ICJi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uSGy8AwcpYvkC0xE405aP8OGFny0RMJSu9PJLuvIFiNw86xP4f4M/ZuiFl1m1r2Tp5
         3rPzIoifgQzlz0CHVgI0WLhwKJXceFTf0LANKxgfHAzOVQNrhaBKtXpu4q2WjPpORrFN
         BLWA1wzPw8cqNerBmtC9Rs3XO2QXe+cy+XRKQ=
From: Namhyung Kim <namhyung@gmail.com>
To: trivial@kernel.org
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ida: document IDA_BITMAP_LONGS calculation
Date: Fri,  3 Sep 2010 18:38:18 +0900
Message-Id: <1283506698-21369-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDA_BITMAP_LONGS value is calculated take into account struct ida_bitmap
not to waste memory space. Comment it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..3f4b718 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -117,10 +117,13 @@ void idr_init(struct idr *idp);
 /*
  * IDA - IDR based id allocator, use when translation from id to
  * pointer isn't necessary.
+ *
+ * IDA_BITMAP_LONGS is calculated to be one less to accommodate
+ * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
  */
 #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
 #define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
-#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
+#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
 
 struct ida_bitmap {
 	long			nr_busy;
-- 
1.7.2.2

