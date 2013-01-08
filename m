Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3AHXY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:24:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49918 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3AHXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:24:54 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/2] gfp: split out defines for gfp flags into seperate header
Date: Tue,  8 Jan 2013 15:24:14 -0800
Message-Id: <1357687455-13234-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010823-7606-0000-0000-000007426B96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the current linux/gfp.h into gfp.h and gfp-flags.h
All the defines for flags are placed into gfp-flags.h which is included
from gfp.h

This split allows the use of the defines by userspace tools, such as a
gfp decoder.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/gfp-flags.h | 143 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/gfp.h       | 144 +---------------------------------------------
 2 files changed, 144 insertions(+), 143 deletions(-)
 create mode 100644 include/linux/gfp-flags.h

diff --git a/include/linux/gfp-flags.h b/include/linux/gfp-flags.h
new file mode 100644
index 0000000..572e4c0
--- /dev/null
+++ b/include/linux/gfp-flags.h
@@ -0,0 +1,143 @@
+/* Plain integer GFP bitmasks. Do not use this directly. */
+#define ___GFP_DMA		0x01u
+#define ___GFP_HIGHMEM		0x02u
+#define ___GFP_DMA32		0x04u
+#define ___GFP_MOVABLE		0x08u
+#define ___GFP_WAIT		0x10u
+#define ___GFP_HIGH		0x20u
+#define ___GFP_IO		0x40u
+#define ___GFP_FS		0x80u
+#define ___GFP_COLD		0x100u
+#define ___GFP_NOWARN		0x200u
+#define ___GFP_REPEAT		0x400u
+#define ___GFP_NOFAIL		0x800u
+#define ___GFP_NORETRY		0x1000u
+#define ___GFP_MEMALLOC		0x2000u
+#define ___GFP_COMP		0x4000u
+#define ___GFP_ZERO		0x8000u
+#define ___GFP_NOMEMALLOC	0x10000u
+#define ___GFP_HARDWALL		0x20000u
+#define ___GFP_THISNODE		0x40000u
+#define ___GFP_RECLAIMABLE	0x80000u
+#define ___GFP_KMEMCG		0x100000u
+#define ___GFP_NOTRACK		0x200000u
+#define ___GFP_NO_KSWAPD	0x400000u
+#define ___GFP_OTHER_NODE	0x800000u
+#define ___GFP_WRITE		0x1000000u
+/* If the above are modified, __GFP_BITS_SHIFT may need updating */
+
+/*
+ * GFP bitmasks..
+ *
+ * Zone modifiers (see linux/mmzone.h - low three bits)
+ *
+ * Do not put any conditional on these. If necessary modify the definitions
+ * without the underscores and use them consistently. The definitions here may
+ * be used in bit comparisons.
+ */
+#define __GFP_DMA	((__force gfp_t)___GFP_DMA)
+#define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
+#define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
+#define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* Page is movable */
+#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
+/*
+ * Action modifiers - doesn't change the zoning
+ *
+ * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
+ * _might_ fail.  This depends upon the particular VM implementation.
+ *
+ * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
+ * cannot handle allocation failures.  This modifier is deprecated and no new
+ * users should be added.
+ *
+ * __GFP_NORETRY: The VM implementation must not retry indefinitely.
+ *
+ * __GFP_MOVABLE: Flag that this page will be movable by the page migration
+ * mechanism or reclaimed
+ */
+#define __GFP_WAIT	((__force gfp_t)___GFP_WAIT)	/* Can wait and reschedule? */
+#define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)	/* Should access emergency pools? */
+#define __GFP_IO	((__force gfp_t)___GFP_IO)	/* Can start physical IO? */
+#define __GFP_FS	((__force gfp_t)___GFP_FS)	/* Can call down to low-level FS? */
+#define __GFP_COLD	((__force gfp_t)___GFP_COLD)	/* Cache-cold page required */
+#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)	/* Suppress page allocation failure warning */
+#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
+#define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
+#define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
+#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
+#define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
+#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
+#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves.
+							 * This takes precedence over the
+							 * __GFP_MEMALLOC flag if both are
+							 * set
+							 */
+#define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
+#define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
+#define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
+#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
+
+#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
+#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
+#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes from a memcg-accounted resource */
+#define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
+
+/*
+ * This may seem redundant, but it's a way of annotating false positives vs.
+ * allocations that simply cannot be supported (e.g. page tables).
+ */
+#define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
+
+#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
+#define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
+
+/* This equals 0, but use constants in case they ever change */
+#define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
+/* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
+#define GFP_ATOMIC	(__GFP_HIGH)
+#define GFP_NOIO	(__GFP_WAIT)
+#define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
+#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
+#define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+			 __GFP_RECLAIMABLE)
+#define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
+			 __GFP_HIGHMEM)
+#define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+				 __GFP_HARDWALL | __GFP_HIGHMEM | \
+				 __GFP_MOVABLE)
+#define GFP_IOFS	(__GFP_IO | __GFP_FS)
+#define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
+			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
+			 __GFP_NO_KSWAPD)
+
+#ifdef CONFIG_NUMA
+#define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
+#else
+#define GFP_THISNODE	((__force gfp_t)0)
+#endif
+
+/* This mask makes up all the page movable related flags */
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
+
+/* Control page allocator reclaim behavior */
+#define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
+			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
+
+/* Control slab gfp mask during early boot */
+#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))
+
+/* Control allocation constraints */
+#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
+
+/* Do not use these with a slab allocator */
+#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
+
+/* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
+   platforms, used as appropriate on others */
+
+#define GFP_DMA		__GFP_DMA
+
+/* 4GB DMA on some platforms */
+#define GFP_DMA32	__GFP_DMA32
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0f615eb..33d79f3 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -9,149 +9,7 @@
 
 struct vm_area_struct;
 
-/* Plain integer GFP bitmasks. Do not use this directly. */
-#define ___GFP_DMA		0x01u
-#define ___GFP_HIGHMEM		0x02u
-#define ___GFP_DMA32		0x04u
-#define ___GFP_MOVABLE		0x08u
-#define ___GFP_WAIT		0x10u
-#define ___GFP_HIGH		0x20u
-#define ___GFP_IO		0x40u
-#define ___GFP_FS		0x80u
-#define ___GFP_COLD		0x100u
-#define ___GFP_NOWARN		0x200u
-#define ___GFP_REPEAT		0x400u
-#define ___GFP_NOFAIL		0x800u
-#define ___GFP_NORETRY		0x1000u
-#define ___GFP_MEMALLOC		0x2000u
-#define ___GFP_COMP		0x4000u
-#define ___GFP_ZERO		0x8000u
-#define ___GFP_NOMEMALLOC	0x10000u
-#define ___GFP_HARDWALL		0x20000u
-#define ___GFP_THISNODE		0x40000u
-#define ___GFP_RECLAIMABLE	0x80000u
-#define ___GFP_KMEMCG		0x100000u
-#define ___GFP_NOTRACK		0x200000u
-#define ___GFP_NO_KSWAPD	0x400000u
-#define ___GFP_OTHER_NODE	0x800000u
-#define ___GFP_WRITE		0x1000000u
-/* If the above are modified, __GFP_BITS_SHIFT may need updating */
-
-/*
- * GFP bitmasks..
- *
- * Zone modifiers (see linux/mmzone.h - low three bits)
- *
- * Do not put any conditional on these. If necessary modify the definitions
- * without the underscores and use them consistently. The definitions here may
- * be used in bit comparisons.
- */
-#define __GFP_DMA	((__force gfp_t)___GFP_DMA)
-#define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
-#define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
-#define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* Page is movable */
-#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
-/*
- * Action modifiers - doesn't change the zoning
- *
- * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
- * _might_ fail.  This depends upon the particular VM implementation.
- *
- * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.  This modifier is deprecated and no new
- * users should be added.
- *
- * __GFP_NORETRY: The VM implementation must not retry indefinitely.
- *
- * __GFP_MOVABLE: Flag that this page will be movable by the page migration
- * mechanism or reclaimed
- */
-#define __GFP_WAIT	((__force gfp_t)___GFP_WAIT)	/* Can wait and reschedule? */
-#define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)	/* Should access emergency pools? */
-#define __GFP_IO	((__force gfp_t)___GFP_IO)	/* Can start physical IO? */
-#define __GFP_FS	((__force gfp_t)___GFP_FS)	/* Can call down to low-level FS? */
-#define __GFP_COLD	((__force gfp_t)___GFP_COLD)	/* Cache-cold page required */
-#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)	/* Suppress page allocation failure warning */
-#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
-#define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
-#define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
-#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
-#define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
-#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves.
-							 * This takes precedence over the
-							 * __GFP_MEMALLOC flag if both are
-							 * set
-							 */
-#define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
-#define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
-#define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
-#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
-
-#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
-#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
-#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes from a memcg-accounted resource */
-#define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
-
-/*
- * This may seem redundant, but it's a way of annotating false positives vs.
- * allocations that simply cannot be supported (e.g. page tables).
- */
-#define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
-
-#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
-#define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
-
-/* This equals 0, but use constants in case they ever change */
-#define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
-/* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
-#define GFP_ATOMIC	(__GFP_HIGH)
-#define GFP_NOIO	(__GFP_WAIT)
-#define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
-#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
-#define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-			 __GFP_RECLAIMABLE)
-#define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
-#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
-			 __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_HIGHMEM | \
-				 __GFP_MOVABLE)
-#define GFP_IOFS	(__GFP_IO | __GFP_FS)
-#define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
-			 __GFP_NO_KSWAPD)
-
-#ifdef CONFIG_NUMA
-#define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
-#else
-#define GFP_THISNODE	((__force gfp_t)0)
-#endif
-
-/* This mask makes up all the page movable related flags */
-#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
-
-/* Control page allocator reclaim behavior */
-#define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
-			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
-
-/* Control slab gfp mask during early boot */
-#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))
-
-/* Control allocation constraints */
-#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
-
-/* Do not use these with a slab allocator */
-#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
-
-/* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
-   platforms, used as appropriate on others */
-
-#define GFP_DMA		__GFP_DMA
-
-/* 4GB DMA on some platforms */
-#define GFP_DMA32	__GFP_DMA32
+#include <linux/gfp-flags.h>
 
 /* Convert GFP flags to their corresponding migrate type */
 static inline int allocflags_to_migratetype(gfp_t gfp_flags)
-- 
1.8.0.3

