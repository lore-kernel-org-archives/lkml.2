Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0HZNVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:21:52 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38430 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140Ab0HZNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:28 -0400
Message-Id: <20100826132126.733001476@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:20:01 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 24/25] GRU - rename gru pagesize defines
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_min_pagesize
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Change the name of GRU_GSEG_PAGESIZE to GRU_MIN_GSEG_PAGESIZE
to more accurately reflect it's use. This is in preparation for
allocating contexts using hugepages.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru.h              |   10 ++--------
 drivers/misc/sgi-gru/gru_instructions.h |    2 +-
 2 files changed, 3 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:48.856038221 -0500
+++ linux/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:51.328084904 -0500
@@ -28,15 +28,9 @@
 #define GRU_DS_BASE			0x20000
 
 /*
- * Size used to map GRU GSeg
+ * Minimum page size used to map a GRU context
  */
-#if defined(CONFIG_IA64)
-#define GRU_GSEG_PAGESIZE	(256 * 1024UL)
-#elif defined(CONFIG_X86_64)
-#define GRU_GSEG_PAGESIZE	(256 * 1024UL)		/* ZZZ 2MB ??? */
-#else
-#error "Unsupported architecture"
-#endif
+#define GRU_MIN_GSEG_PAGESIZE	(256 * 1024UL)
 
 /*
  * Statictics kept for each context.
Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:50.264036100 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:51.332083779 -0500
@@ -687,6 +687,6 @@ static inline void *gru_get_data_pointer
  */
 static inline int gru_get_tri(void *vaddr)
 {
-	return ((unsigned long)vaddr & (GRU_GSEG_PAGESIZE - 1)) - GRU_DS_BASE;
+	return ((unsigned long)vaddr & (GRU_MIN_GSEG_PAGESIZE - 1)) - GRU_DS_BASE;
 }
 #endif		/* __GRU_INSTRUCTIONS_H__ */

