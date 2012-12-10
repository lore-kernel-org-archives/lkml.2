Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2LJTOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:14:17 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55677 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab2LJTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:58 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Will Deacon <will.deacon@arm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 10/10] asm-generic: io: remove {read,write} string functions
Date: Mon, 10 Dec 2012 19:12:42 +0000
Message-Id: <1355166762-15133-11-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The {read,write}s{b,w,l} functions are not defined across all
architectures and therefore shouldn't be used by portable drivers. We
should encourage driver writers to use the io{read,write}{8,16,32}_rep
functions instead.

This patch removes the {read,write} string functions for the generic IO
header as they have no place in a new architecture port.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/io.h | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index b2600f3..403b861 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -217,36 +217,6 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 }
 #endif
 
-static inline void readsl(const void __iomem *addr, void *buf, int len)
-{
-	insl(addr - PCI_IOBASE, buf, len);
-}
-
-static inline void readsw(const void __iomem *addr, void *buf, int len)
-{
-	insw(addr - PCI_IOBASE, buf, len);
-}
-
-static inline void readsb(const void __iomem *addr, void *buf, int len)
-{
-	insb(addr - PCI_IOBASE, buf, len);
-}
-
-static inline void writesl(const void __iomem *addr, const void *buf, int len)
-{
-	outsl(addr - PCI_IOBASE, buf, len);
-}
-
-static inline void writesw(const void __iomem *addr, const void *buf, int len)
-{
-	outsw(addr - PCI_IOBASE, buf, len);
-}
-
-static inline void writesb(const void __iomem *addr, const void *buf, int len)
-{
-	outsb(addr - PCI_IOBASE, buf, len);
-}
-
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
-- 
1.8.0

