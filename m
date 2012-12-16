Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2LPRix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:38:53 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46116 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2LPRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:38:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Provide dma_alloc_attrs()/dma_free_attrs()
Date: Sun, 16 Dec 2012 18:38:46 +0100
Message-Id: <1355679527-1207-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 0049fb2603b7afb1080776ee691dfa5a3d282357 ("OMAPFB: use
dma_alloc_attrs to allocate memory") we have one non-arch user of
dma_{alloc,free}_attrs().

Hence provide these functions, as wrappers around
dma_{alloc,free}_coherent().

Note that most architectures do it the other way around. But as so far
m68k doesn't support the attributes at all, our solution should generate
smaller code.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/dma-mapping.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index 17f7a45..3e6b844 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -21,6 +21,22 @@ extern void *dma_alloc_coherent(struct device *, size_t,
 extern void dma_free_coherent(struct device *, size_t,
 			      void *, dma_addr_t);
 
+static inline void *dma_alloc_attrs(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t flag,
+				    struct dma_attrs *attrs)
+{
+	/* attrs is not supported and ignored */
+	return dma_alloc_coherent(dev, size, dma_handle, flag);
+}
+
+static inline void dma_free_attrs(struct device *dev, size_t size,
+				  void *cpu_addr, dma_addr_t dma_handle,
+				  struct dma_attrs *attrs)
+{
+	/* attrs is not supported and ignored */
+	dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
 					  dma_addr_t *handle, gfp_t flag)
 {
-- 
1.7.0.4

