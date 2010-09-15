Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0IOMqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:46:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52821 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0IOMqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q8iQVymDIPLRpC91XCF3hIc7w3lX4WZSV5Xia3i+FcyH1qmy4m589YY2WIGOdGpRO3
         /hbBh9ECxqw01zBeh40/GSTEujvmPTX6ZAbv1uK+wWwTxgzvfECdOGwAgmtWC2xQE2mU
         9oEJ1swB7wSuk+p7MuV/wkt1Pr3FSyEvtN5uQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/2] ida: document IDA_BITMAP_LONGS calculation
Date: Wed, 15 Sep 2010 21:46:01 +0900
Message-Id: <1284554762-13278-1-git-send-email-namhyung@gmail.com>
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

