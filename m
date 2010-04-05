Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0DEXyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:54:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:47003 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab0DEXyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:38 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 01/12] asm-generic: remove ARCH_HAS_SG_CHAIN in scatterlist.h
Date: Tue,  6 Apr 2010 08:52:36 +0900
Message-Id: <1270511567-18567-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are more architectures that don't support ARCH_HAS_SG_CHAIN than
those that support it. This removes removes ARCH_HAS_SG_CHAIN in
asm-generic/scatterlist.h and lets arhictectures to define it.

It's clearer than defining ARCH_HAS_SG_CHAIN asm-generic/scatterlist.h
and undefing it in arhictectures that don't support it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/include/asm/scatterlist.h      |    4 +---
 arch/arm/include/asm/scatterlist.h        |    3 ---
 arch/ia64/include/asm/scatterlist.h       |    4 ++--
 arch/microblaze/include/asm/scatterlist.h |    4 ++--
 arch/powerpc/include/asm/scatterlist.h    |    1 +
 arch/sparc/include/asm/scatterlist.h      |    5 +++--
 arch/x86/include/asm/scatterlist.h        |    5 +++--
 include/asm-generic/scatterlist.h         |    2 --
 8 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/alpha/include/asm/scatterlist.h b/arch/alpha/include/asm/scatterlist.h
index 85a0ef2..5728c52 100644
--- a/arch/alpha/include/asm/scatterlist.h
+++ b/arch/alpha/include/asm/scatterlist.h
@@ -1,10 +1,8 @@
 #ifndef _ALPHA_SCATTERLIST_H
 #define _ALPHA_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD (~0UL)
-
 #include <asm-generic/scatterlist.h>
 
-#undef ARCH_HAS_SG_CHAIN
+#define ISA_DMA_THRESHOLD (~0UL)
 
 #endif /* !(_ALPHA_SCATTERLIST_H) */
diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
index bcda59f..2f87870 100644
--- a/arch/arm/include/asm/scatterlist.h
+++ b/arch/arm/include/asm/scatterlist.h
@@ -3,9 +3,6 @@
 
 #include <asm/memory.h>
 #include <asm/types.h>
-
 #include <asm-generic/scatterlist.h>
 
-#undef ARCH_HAS_SG_CHAIN
-
 #endif /* _ASMARM_SCATTERLIST_H */
diff --git a/arch/ia64/include/asm/scatterlist.h b/arch/ia64/include/asm/scatterlist.h
index d8e9896..f299a4f 100644
--- a/arch/ia64/include/asm/scatterlist.h
+++ b/arch/ia64/include/asm/scatterlist.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_IA64_SCATTERLIST_H
 #define _ASM_IA64_SCATTERLIST_H
 
+#include <asm-generic/scatterlist.h>
 /*
  * It used to be that ISA_DMA_THRESHOLD had something to do with the
  * DMA-limits of ISA-devices.  Nowadays, its only remaining use (apart
@@ -10,7 +11,6 @@
  * that's 4GB - 1.
  */
 #define ISA_DMA_THRESHOLD	0xffffffff
-
-#include <asm-generic/scatterlist.h>
+#define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_IA64_SCATTERLIST_H */
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
index be44d94..dc4a890 100644
--- a/arch/microblaze/include/asm/scatterlist.h
+++ b/arch/microblaze/include/asm/scatterlist.h
@@ -1,3 +1,3 @@
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
+
+#define ISA_DMA_THRESHOLD	(~0UL)
diff --git a/arch/powerpc/include/asm/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
index 4ae35da..34cc78f 100644
--- a/arch/powerpc/include/asm/scatterlist.h
+++ b/arch/powerpc/include/asm/scatterlist.h
@@ -15,5 +15,6 @@
 #ifdef __powerpc64__
 #define ISA_DMA_THRESHOLD	(~0UL)
 #endif
+#define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_POWERPC_SCATTERLIST_H */
diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
index 69d21bb..433e45f 100644
--- a/arch/sparc/include/asm/scatterlist.h
+++ b/arch/sparc/include/asm/scatterlist.h
@@ -1,8 +1,9 @@
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* !(_SPARC_SCATTERLIST_H) */
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/scatterlist.h
index 75af592..fb0b187 100644
--- a/arch/x86/include/asm/scatterlist.h
+++ b/arch/x86/include/asm/scatterlist.h
@@ -1,8 +1,9 @@
 #ifndef _ASM_X86_SCATTERLIST_H
 #define _ASM_X86_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD (0x00ffffff)
-
 #include <asm-generic/scatterlist.h>
 
+#define ISA_DMA_THRESHOLD (0x00ffffff)
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 5e08794..5de0735 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -31,6 +31,4 @@ struct scatterlist {
 #define sg_dma_len(sg)		((sg)->length)
 #endif
 
-#define ARCH_HAS_SG_CHAIN
-
 #endif /* __ASM_GENERIC_SCATTERLIST_H */
-- 
1.7.0

