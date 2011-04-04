Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1DDPVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:21:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42025 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1DDPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:21:48 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
Date: Mon, 4 Apr 2011 16:21:47 +0100
Message-ID: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
Subject: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
From: James Hogan <james@albanarts.com>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Hogan <james.hogan@imgtec.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

Note: I'm not in a position to compile test this patch, but I don't
foresee any problems.

Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
(d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
struct dev pointer, but these appear to be missing from the tile and
mn10300 implementations, so add them.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/mn10300/include/asm/dma-mapping.h |    2 +-
 arch/tile/include/asm/dma-mapping.h    |    3 ++-
 arch/tile/kernel/pci-dma.c             |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/include/asm/dma-mapping.h
b/arch/mn10300/include/asm/dma-mapping.h
index c1be439..6876e2b 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -162,7 +162,7 @@ int dma_set_mask(struct device *dev, u64 mask)
 }

 static inline
-void dma_cache_sync(void *vaddr, size_t size,
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
 {
 	mn10300_dcache_flush_inv();
diff --git a/arch/tile/include/asm/dma-mapping.h
b/arch/tile/include/asm/dma-mapping.h
index 15e1dce..eaa06d1 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -65,7 +65,8 @@ extern void dma_sync_single_range_for_cpu(struct
device *, dma_addr_t,
 extern void dma_sync_single_range_for_device(struct device *, dma_addr_t,
 					     unsigned long offset, size_t,
 					     enum dma_data_direction);
-extern void dma_cache_sync(void *vaddr, size_t, enum dma_data_direction);
+extern void dma_cache_sync(struct device *dev, void *vaddr, size_t,
+			   enum dma_data_direction);

 static inline int
 dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 5ad5e13..c6812d2 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -244,7 +244,7 @@ EXPORT_SYMBOL(dma_sync_single_range_for_device);
  * dma_alloc_noncoherent() returns non-cacheable memory, so there's no
  * need to do any flushing here.
  */
-void dma_cache_sync(void *vaddr, size_t size,
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
 {
 }
-- 
1.7.2.3
