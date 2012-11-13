Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2KMHm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:42:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KMHm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:42:27 -0500
Date: Mon, 12 Nov 2012 23:42:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: [patch] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7
 fix fix fix fix
In-Reply-To: <20121113170046.48e2c790d5c6c1e5f51c593d@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1211122338500.29609@chino.kir.corp.google.com>
References: <20121113170046.48e2c790d5c6c1e5f51c593d@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definitions of MAP_HUGE_SHIFT and MAP_HUGE_MASK to mman-common.h 
and fixup the architectures which do not use that file to fix the 
following build failure:

mm/mmap.c: In function 'SYSC_mmap_pgoff':
mm/mmap.c:1271:15: error: 'MAP_HUGE_SHIFT' undeclared (first use in this function)
mm/mmap.c:1271:15: note: each undeclared identifier is reported only once for each function it appears in
mm/mmap.c:1271:33: error: 'MAP_HUGE_MASK' undeclared (first use in this function)

Tested on alpha, hppa, ia64, mips, powerpc, sparc, and x86.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/alpha/include/asm/mman.h          |   11 +++++++++++
 arch/mips/include/uapi/asm/mman.h      |   11 +++++++++++
 arch/parisc/include/uapi/asm/mman.h    |   11 +++++++++++
 arch/xtensa/include/uapi/asm/mman.h    |   11 +++++++++++
 include/uapi/asm-generic/mman-common.h |   11 +++++++++++
 include/uapi/asm-generic/mman.h        |   13 +------------
 6 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/include/asm/mman.h b/arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h
+++ b/arch/alpha/include/asm/mman.h
@@ -63,4 +63,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __ALPHA_MMAN_H__ */
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -87,4 +87,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* _ASM_MMAN_H */
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -70,4 +70,15 @@
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __PARISC_MMAN_H__ */
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -93,4 +93,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* _XTENSA_MMAN_H */
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -55,4 +55,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __ASM_GENERIC_MMAN_COMMON_H */
diff --git a/include/uapi/asm-generic/mman.h b/include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h
+++ b/include/uapi/asm-generic/mman.h
@@ -13,18 +13,7 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
-/* Bits [26:31] are reserved */
-
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT  26
-#define MAP_HUGE_MASK   0x3f
+/* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
