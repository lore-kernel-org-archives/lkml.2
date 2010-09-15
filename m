Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0IOQac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:30:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59388 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0IOQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ozy2yIGSWvogmD0PtWyTzLQbxyWl8PQg1haXR7F4Dq7h7d/v2sYz869Q/vGUFTZEk+
         Ex5U/6FlfRH66JlaYJ7vfa7LbROYf2Yc+X4P5qKH2Njou4fEkrfJ+jTqhi2XiXRGHLbo
         hSLGMdHXCk3MatHuHhSDucdn0CNh6DMTUgTLE=
From: Namhyung Kim <namhyung@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 1/2] ida: document IDA_BITMAP_LONGS calculation
Date: Thu, 16 Sep 2010 01:30:19 +0900
Message-Id: <1284568219-14574-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100915082217.6bf82715.rdunlap@xenotime.net>
References: <20100915082217.6bf82715.rdunlap@xenotime.net>
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
-#define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
-#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
+#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)
+#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
 
 struct ida_bitmap {
 	long			nr_busy;
-- 
1.7.2.2

