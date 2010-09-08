Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0IHXMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 19:12:44 -0400
Received: from [69.28.251.93] ([69.28.251.93]:47095 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0IHXMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:12:37 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 8 Sep 2010 16:02:16 -0700
Subject: [PATCH 3/3] MIPS: DMA: Add plat_extra_sync_for_cpu()
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
In-Reply-To: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On noncoherent processors with a readahead cache, an extra platform-
specific invalidation is required during the dma_sync_*_for_cpu()
operations to keep drivers from seeing stale prefetched data.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   13 +++++++++++++
 arch/mips/include/asm/mach-generic/dma-coherence.h |   13 +++++++++++++
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |   13 +++++++++++++
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   13 +++++++++++++
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |   13 +++++++++++++
 .../mips/include/asm/mach-loongson/dma-coherence.h |   13 +++++++++++++
 arch/mips/include/asm/mach-powertv/dma-coherence.h |   13 +++++++++++++
 arch/mips/mm/dma-default.c                         |    3 +++
 8 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index 17d5794..8192683 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -52,6 +52,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	mb();
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_device_is_coherent(struct device *dev)
 {
 	return 1;
diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index 8da9807..20728eb 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -52,6 +52,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip27/dma-coherence.h b/arch/mips/include/asm/mach-ip27/dma-coherence.h
index d3d0401..b1cb862 100644
--- a/arch/mips/include/asm/mach-ip27/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip27/dma-coherence.h
@@ -62,6 +62,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip32/dma-coherence.h b/arch/mips/include/asm/mach-ip32/dma-coherence.h
index 3785595..c870003 100644
--- a/arch/mips/include/asm/mach-ip32/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip32/dma-coherence.h
@@ -84,6 +84,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-jazz/dma-coherence.h b/arch/mips/include/asm/mach-jazz/dma-coherence.h
index f93aee5..dd7b8e3 100644
--- a/arch/mips/include/asm/mach-jazz/dma-coherence.h
+++ b/arch/mips/include/asm/mach-jazz/dma-coherence.h
@@ -52,6 +52,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index 981c75f..7565bbc 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -58,6 +58,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-powertv/dma-coherence.h b/arch/mips/include/asm/mach-powertv/dma-coherence.h
index f76029c..1134961 100644
--- a/arch/mips/include/asm/mach-powertv/dma-coherence.h
+++ b/arch/mips/include/asm/mach-powertv/dma-coherence.h
@@ -105,6 +105,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
 	return;
 }
 
+static inline void plat_extra_sync_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	return;
+}
+
+static inline void plat_extra_sync_for_cpu_sg(struct device *dev,
+	struct scatterlist *sg, enum dma_data_direction direction)
+{
+	return;
+}
+
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 79dfb9c..ed1baaf 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -287,6 +287,7 @@ EXPORT_SYMBOL(dma_unmap_sg);
 void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 	size_t size, enum dma_data_direction direction)
 {
+	plat_extra_sync_for_cpu(dev, dma_handle, 0, size, direction);
 	if (cpu_is_noncoherent_r10000(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_handle),
 			   dma_handle & ~PAGE_MASK, size, direction);
@@ -308,6 +309,7 @@ EXPORT_SYMBOL(dma_sync_single_for_device);
 void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
 	unsigned long offset, size_t size, enum dma_data_direction direction)
 {
+	plat_extra_sync_for_cpu(dev, dma_handle, offset, size, direction);
 	if (cpu_is_noncoherent_r10000(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_handle), offset, size,
 			   direction);
@@ -333,6 +335,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
+		plat_extra_sync_for_cpu_sg(dev, sg, direction);
 		if (cpu_is_noncoherent_r10000(dev))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
-- 
1.7.0.4

