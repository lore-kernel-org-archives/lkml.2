Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab2AYSLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:11:49 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2AYSLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:11:47 -0500
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] um: Use generic io.h
Date: Wed, 25 Jan 2012 18:23:53 +0100
Message-Id: <1327512234-22578-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to implement our own basic io functions.
All we need exists already in asm-generic/io.h

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/io.h |   53 +---------------------------------------------
 1 files changed, 1 insertions(+), 52 deletions(-)

diff --git a/arch/um/include/asm/io.h b/arch/um/include/asm/io.h
index 44e8b8c..cff48f0 100644
--- a/arch/um/include/asm/io.h
+++ b/arch/um/include/asm/io.h
@@ -1,57 +1,6 @@
 #ifndef __UM_IO_H
 #define __UM_IO_H
 
-#include "asm/page.h"
-
-#define IO_SPACE_LIMIT 0xdeadbeef /* Sure hope nothing uses this */
-
-static inline int inb(unsigned long i) { return(0); }
-static inline void outb(char c, unsigned long i) { }
-
-/*
- * Change virtual addresses to physical addresses and vv.
- * These are pretty trivial
- */
-static inline unsigned long virt_to_phys(volatile void * address)
-{
-	return __pa((void *) address);
-}
-
-static inline void * phys_to_virt(unsigned long address)
-{
-	return __va(address);
-}
-
-/*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-static inline void writeb(unsigned char b, volatile void __iomem *addr)
-{
-	*(volatile unsigned char __force *) addr = b;
-}
-static inline void writew(unsigned short b, volatile void __iomem *addr)
-{
-	*(volatile unsigned short __force *) addr = b;
-}
-static inline void writel(unsigned int b, volatile void __iomem *addr)
-{
-	*(volatile unsigned int __force *) addr = b;
-}
-static inline void writeq(unsigned int b, volatile void __iomem *addr)
-{
-	*(volatile unsigned long long __force *) addr = b;
-}
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define __raw_writeq writeq
+#include <asm-generic/io.h>
 
 #endif
-- 
1.7.7

