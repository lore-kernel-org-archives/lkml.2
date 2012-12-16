Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2LPRiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:38:52 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46138 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2LPRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:38:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] asm-generic/dma-mapping-broken.h: Provide dma_alloc_attrs()/dma_free_attrs()
Date: Sun, 16 Dec 2012 18:38:47 +0100
Message-Id: <1355679527-1207-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355679527-1207-1-git-send-email-geert@linux-m68k.org>
References: <1355679527-1207-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 0049fb2603b7afb1080776ee691dfa5a3d282357 ("OMAPFB: use
dma_alloc_attrs to allocate memory") we have one non-arch user of
dma_{alloc,free}_attrs().

Hence provide these functions, as wrappers around
dma_{alloc,free}_coherent().

Note that most architectures do it the other way around. But as these are
dummy functions, we don't care.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-generic/dma-mapping-broken.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index ccf7b4f..6c32af9 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -16,6 +16,22 @@ extern void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 		    dma_addr_t dma_handle);
 
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
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-- 
1.7.0.4

