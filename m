Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0JZCyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab0JZCyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 17/43] MN10300: Reorder asm/cacheflush.h to put primitives
 first
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:54:32 +0100
Message-ID: <20101026025432.23512.89593.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder asm/cacheflush.h to put arch primitives first, before the main
functions so that the main functions can be inline asm rather than #defines
when non-trivial.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cacheflush.h |   88 +++++++++++++++++----------------
 1 files changed, 44 insertions(+), 44 deletions(-)


diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index b85be1d..0b5d004 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -17,49 +17,7 @@
 #include <linux/mm.h>
 
 /*
- * virtually-indexed cache management (our cache is physically indexed)
- */
-#define flush_cache_all()			do {} while (0)
-#define flush_cache_mm(mm)			do {} while (0)
-#define flush_cache_dup_mm(mm)			do {} while (0)
-#define flush_cache_range(mm, start, end)	do {} while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
-#define flush_cache_vmap(start, end)		do {} while (0)
-#define flush_cache_vunmap(start, end)		do {} while (0)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define flush_dcache_page(page)			do {} while (0)
-#define flush_dcache_mmap_lock(mapping)		do {} while (0)
-#define flush_dcache_mmap_unlock(mapping)	do {} while (0)
-
-/*
- * physically-indexed cache management
- */
-#ifdef CONFIG_MN10300_CACHE_ENABLED
-
-extern void flush_icache_range(unsigned long start, unsigned long end);
-extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
-
-#else
-
-#define flush_icache_range(start, end)		do {} while (0)
-#define flush_icache_page(vma, pg)		do {} while (0)
-
-#endif
-
-#define flush_icache_user_range(vma, pg, adr, len) \
-	flush_icache_range(adr, adr + len)
-
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	do {					\
-		memcpy(dst, src, len);		\
-		flush_icache_page(vma, page);	\
-	} while (0)
-
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-
-/*
- * primitive routines
+ * Primitive routines
  */
 #ifdef CONFIG_MN10300_CACHE_ENABLED
 extern void mn10300_icache_inv(void);
@@ -106,7 +64,49 @@ extern void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size);
 #endif /* CONFIG_MN10300_CACHE_ENABLED */
 
 /*
- * internal debugging function
+ * Virtually-indexed cache management (our cache is physically indexed)
+ */
+#define flush_cache_all()			do {} while (0)
+#define flush_cache_mm(mm)			do {} while (0)
+#define flush_cache_dup_mm(mm)			do {} while (0)
+#define flush_cache_range(mm, start, end)	do {} while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
+#define flush_cache_vmap(start, end)		do {} while (0)
+#define flush_cache_vunmap(start, end)		do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
+#define flush_dcache_page(page)			do {} while (0)
+#define flush_dcache_mmap_lock(mapping)		do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)	do {} while (0)
+
+/*
+ * Physically-indexed cache management
+ */
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+
+extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
+
+#else
+
+#define flush_icache_range(start, end)		do {} while (0)
+#define flush_icache_page(vma, pg)		do {} while (0)
+
+#endif
+
+#define flush_icache_user_range(vma, pg, adr, len) \
+	flush_icache_range(adr, adr + len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+	do {					\
+		memcpy(dst, src, len);		\
+		flush_icache_page(vma, page);	\
+	} while (0)
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+/*
+ * Internal debugging function
  */
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern void kernel_map_pages(struct page *page, int numpages, int enable);

