Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2IZJtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:49:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55821 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2IZJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:49:11 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/2] scatterlist: add sg_nents
Date: Wed, 26 Sep 2012 11:49:00 +0200
Message-Id: <1348652941-31899-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful helper to know the number of entries in scatterlist.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 7b600da..4bd6c06 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -201,6 +201,7 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+int sg_nents(struct scatterlist *sg);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index e76d85c..5cd9cdc 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -39,6 +39,28 @@ struct scatterlist *sg_next(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_next);
 
 /**
+ * sg_nents - return total count of entries in scatterlist
+ * @sg:		The scatterlist
+ *
+ * Description:
+ * Allows to know how many entries are in sg, taking into acount
+ * chaining as well
+ *
+ **/
+int sg_nents(struct scatterlist *sg)
+{
+	int nents = 0;
+	while (sg) {
+		nents++;
+		sg = sg_next(sg);
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL(sg_nents);
+
+
+/**
  * sg_last - return the last scatterlist entry in a list
  * @sgl:	First entry in the scatterlist
  * @nents:	Number of entries in the scatterlist
-- 
1.7.9.5

