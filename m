Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0JRHHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:07:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55998 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0JRHHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:07:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: allow people to override individual funcs
Date: Mon, 18 Oct 2010 03:09:39 -0400
Message-Id: <1287385779-16868-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the Blackfin port, we can use much of the asm-generic/io.h header,
but we still need to declare some of our own versions of functions.
Like the __raw_read* and in/out "string" helpers.  So let people do
this easily for many of these funcs.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/io.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 118601f..3577ca1 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -19,7 +19,9 @@
 #include <asm-generic/iomap.h>
 #endif
 
+#ifndef mmiowb
 #define mmiowb() do {} while (0)
+#endif
 
 /*****************************************************************************/
 /*
@@ -28,39 +30,51 @@
  * differently. On the simple architectures, we just read/write the
  * memory location directly.
  */
+#ifndef __raw_readb
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	return *(const volatile u8 __force *) addr;
 }
+#endif
 
+#ifndef __raw_readw
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	return *(const volatile u16 __force *) addr;
 }
+#endif
 
+#ifndef __raw_readl
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	return *(const volatile u32 __force *) addr;
 }
+#endif
 
 #define readb __raw_readb
 #define readw(addr) __le16_to_cpu(__raw_readw(addr))
 #define readl(addr) __le32_to_cpu(__raw_readl(addr))
 
+#ifndef __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 {
 	*(volatile u8 __force *) addr = b;
 }
+#endif
 
+#ifndef __raw_writew
 static inline void __raw_writew(u16 b, volatile void __iomem *addr)
 {
 	*(volatile u16 __force *) addr = b;
 }
+#endif
 
+#ifndef __raw_writel
 static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 {
 	*(volatile u32 __force *) addr = b;
 }
+#endif
 
 #define writeb __raw_writeb
 #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
@@ -122,6 +136,7 @@ static inline void outl(u32 b, unsigned long addr)
 #define outw_p(x, addr)	outw((x), (addr))
 #define outl_p(x, addr)	outl((x), (addr))
 
+#ifndef insb
 static inline void insb(unsigned long addr, void *buffer, int count)
 {
 	if (count) {
@@ -132,7 +147,9 @@ static inline void insb(unsigned long addr, void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
+#ifndef insw
 static inline void insw(unsigned long addr, void *buffer, int count)
 {
 	if (count) {
@@ -143,7 +160,9 @@ static inline void insw(unsigned long addr, void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
+#ifndef insl
 static inline void insl(unsigned long addr, void *buffer, int count)
 {
 	if (count) {
@@ -154,7 +173,9 @@ static inline void insl(unsigned long addr, void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
+#ifndef outsb
 static inline void outsb(unsigned long addr, const void *buffer, int count)
 {
 	if (count) {
@@ -164,7 +185,9 @@ static inline void outsb(unsigned long addr, const void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
+#ifndef outsw
 static inline void outsw(unsigned long addr, const void *buffer, int count)
 {
 	if (count) {
@@ -174,7 +197,9 @@ static inline void outsw(unsigned long addr, const void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
+#ifndef outsl
 static inline void outsl(unsigned long addr, const void *buffer, int count)
 {
 	if (count) {
@@ -184,6 +209,7 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 		} while (--count);
 	}
 }
+#endif
 
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
-- 
1.7.3.1

