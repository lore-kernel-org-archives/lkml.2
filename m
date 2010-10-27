Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab0J0CD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 22:03:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35648 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759362Ab0J0CDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 22:03:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/2] asm-generic/io.h: add reads[bwl]/writes[bwl] helpers
Date: Tue, 26 Oct 2010 22:03:26 -0400
Message-Id: <1288145006-31108-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288145006-31108-1-git-send-email-vapier@gentoo.org>
References: <1288145006-31108-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of arches define reads[bwl]/writes[bwl] helpers for accessing
memory mapped registers.  Since the Blackfin ones aren't specific to
Blackfin code, move them to the common asm-generic/io.h for people.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Note: this depends on a patch i'll be merging for 2.6.38 ... i just want
	to float this patch idea now.  if you do want it, i can just send
	you the Blackfin change that converts it to asm-generic/io.h and you
	can merge the patch.  or i can merge both.  doesn't matter to me.

 arch/blackfin/include/asm/io.h |   30 ------------------------------
 include/asm-generic/io.h       |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/blackfin/include/asm/io.h b/arch/blackfin/include/asm/io.h
index a1e1fc7..dccae26 100644
--- a/arch/blackfin/include/asm/io.h
+++ b/arch/blackfin/include/asm/io.h
@@ -58,36 +58,6 @@ extern void dma_insb(unsigned long port, void *addr, unsigned short count);
 extern void dma_insw(unsigned long port, void *addr, unsigned short count);
 extern void dma_insl(unsigned long port, void *addr, unsigned short count);
 
-static inline void readsl(const void __iomem *addr, void *buf, int len)
-{
-	insl((unsigned long)addr, buf, len);
-}
-
-static inline void readsw(const void __iomem *addr, void *buf, int len)
-{
-	insw((unsigned long)addr, buf, len);
-}
-
-static inline void readsb(const void __iomem *addr, void *buf, int len)
-{
-	insb((unsigned long)addr, buf, len);
-}
-
-static inline void writesl(const void __iomem *addr, const void *buf, int len)
-{
-	outsl((unsigned long)addr, buf, len);
-}
-
-static inline void writesw(const void __iomem *addr, const void *buf, int len)
-{
-	outsw((unsigned long)addr, buf, len);
-}
-
-static inline void writesb(const void __iomem *addr, const void *buf, int len)
-{
-	outsb((unsigned long)addr, buf, len);
-}
-
 /**
  * I/O write barrier
  *
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 3577ca1..4644c9a 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -211,6 +211,36 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 }
 #endif
 
+static inline void readsl(const void __iomem *addr, void *buf, int len)
+{
+	insl((unsigned long)addr, buf, len);
+}
+
+static inline void readsw(const void __iomem *addr, void *buf, int len)
+{
+	insw((unsigned long)addr, buf, len);
+}
+
+static inline void readsb(const void __iomem *addr, void *buf, int len)
+{
+	insb((unsigned long)addr, buf, len);
+}
+
+static inline void writesl(const void __iomem *addr, const void *buf, int len)
+{
+	outsl((unsigned long)addr, buf, len);
+}
+
+static inline void writesw(const void __iomem *addr, const void *buf, int len)
+{
+	outsw((unsigned long)addr, buf, len);
+}
+
+static inline void writesb(const void __iomem *addr, const void *buf, int len)
+{
+	outsb((unsigned long)addr, buf, len);
+}
+
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
-- 
1.7.3.2

