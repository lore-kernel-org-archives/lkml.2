Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab0ESLCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:02:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:42950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab0ESLC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:02:26 -0400
Subject: [PATCH 2/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slob_def.h>
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:01:43 +0100
Message-ID: <1274266903.6930.9835.camel@macbook.infradead.org>
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
 include/linux/slob_def.h |    8 ++++++++
 mm/slob.c                |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 0ec00b3..62667f7 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -1,6 +1,14 @@
 #ifndef __LINUX_SLOB_DEF_H
 #define __LINUX_SLOB_DEF_H
 
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
+#endif
+
+#ifndef ARCH_SLAB_MINALIGN
+#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
+#endif
+
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
 static __always_inline void *kmem_cache_alloc(struct kmem_cache *cachep,
diff --git a/mm/slob.c b/mm/slob.c
index 837ebd6..23631e2 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -467,14 +467,6 @@ out:
  * End of slob allocator proper. Begin kmem_cache_alloc and kmalloc frontend.
  */
 
-#ifndef ARCH_KMALLOC_MINALIGN
-#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
-#endif
-
-#ifndef ARCH_SLAB_MINALIGN
-#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
-#endif
-
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
-- 
1.6.6.1



