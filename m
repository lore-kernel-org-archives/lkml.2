Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2L1TYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:24:39 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:44886 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2L1TXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:23:52 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 3/4] avr32/bfin/c6x/cris/frv/m68k/mn10300/parisc/xtensa: Add dummy get_dma_ops()
Date: Fri, 28 Dec 2012 20:23:33 +0100
Message-Id: <1356722614-18224-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide dummy versions of get_dma_ops(), as dma_mmap_attrs() and
dma_get_sgtable_attrs() (will) need these

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/avr32/include/asm/dma-mapping.h    |    8 ++++++++
 arch/blackfin/include/asm/dma-mapping.h |    8 ++++++++
 arch/c6x/include/asm/dma-mapping.h      |    8 ++++++++
 arch/cris/include/asm/dma-mapping.h     |    8 ++++++++
 arch/frv/include/asm/dma-mapping.h      |    8 ++++++++
 arch/m68k/include/asm/dma-mapping.h     |    8 ++++++++
 arch/mn10300/include/asm/dma-mapping.h  |    8 ++++++++
 arch/parisc/include/asm/dma-mapping.h   |    8 ++++++++
 arch/xtensa/include/asm/dma-mapping.h   |    8 ++++++++
 9 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
index aaf5199..de55309 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -8,6 +8,14 @@
 #include <asm/cacheflush.h>
 #include <asm/io.h>
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	int direction);
 
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index bbf4610..a2778b3 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -10,6 +10,14 @@
 #include <asm/cacheflush.h>
 struct scatterlist;
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			 dma_addr_t *dma_handle, gfp_t gfp);
 void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
index 3c69406..5ae2f81 100644
--- a/arch/c6x/include/asm/dma-mapping.h
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -17,6 +17,14 @@
 
 #define dma_supported(d, m)	1
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index 8588b2c..05a55aa 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -10,6 +10,14 @@
 #include <asm/io.h>
 #include <asm/scatterlist.h>
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index dfb8110..862e9b8 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -12,6 +12,14 @@
  * following DMA API should work.
  */
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index c68cdb4..d8977f5 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -5,6 +5,14 @@
 
 struct scatterlist;
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 static inline int dma_supported(struct device *dev, u64 mask)
 {
 	return 1;
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index c1be439..b0cea53 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -22,6 +22,14 @@
  * following DMA API should work.
  */
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, int flag);
 
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 467bbd5..cdd450f 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -46,6 +46,14 @@ extern struct hppa_dma_ops pcx_dma_ops;
 
 extern struct hppa_dma_ops *hppa_dma_ops;
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t flag)
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 4acb5fe..0061c2d 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -26,6 +26,14 @@ extern void *consistent_alloc(int, size_t, dma_addr_t, unsigned long);
 extern void consistent_free(void*, size_t, dma_addr_t);
 extern void consistent_sync(void*, size_t, int);
 
+/*
+ *  Dummy to make dma_mmap_attrs()/dma_get_sgtable_attrs() happy
+ */
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return NULL;
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-- 
1.7.0.4

