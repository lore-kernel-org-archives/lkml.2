Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0ESLCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:02:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:42954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab0ESLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:02:29 -0400
Subject: [PATCH 3/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slub_def.h>
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>, christoph@lameter.com
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:02:14 +0100
Message-ID: <1274266934.6930.9840.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/slub_def.h |    8 ++++++++
 mm/slub.c                |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 0249d41..55695c8 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -116,6 +116,14 @@ struct kmem_cache {
 
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
+#endif
+
+#ifndef ARCH_SLAB_MINALIGN
+#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
+#endif
+
 /*
  * Maximum kmalloc object size handled by SLUB. Larger object allocations
  * are passed through to the page allocator. The page allocator "fastpath"
diff --git a/mm/slub.c b/mm/slub.c
index d2a54fe..c874c3e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -157,14 +157,6 @@
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA | SLAB_NOTRACK)
 
-#ifndef ARCH_KMALLOC_MINALIGN
-#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
-#endif
-
-#ifndef ARCH_SLAB_MINALIGN
-#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
-#endif
-
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
 #define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
-- 
1.6.6.1



