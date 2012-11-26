Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2KZNmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:42:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57877 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2KZNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:42:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-2d-50b371b901fc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dma-mapping: fix dma_common_get_sgtable() conditional
 compilation
Date: Mon, 26 Nov 2012 14:41:48 +0100
Message-id: <1353937308-887-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jQd2dhZsDDP73qVhc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmbX3NXnCSveLdmatMDYxr2boYOTkkBEwkpi58wgJh
	i0lcuLceKM7FISQwnVFiavMZVpCEkEA7k8T7VksQm03AUKLrbRdYs4hAkcTy14eZQBqYBXqY
	JO48nc8OkhAWCJGYceMTI4jNIqAq8eTrIWYQm1fATeLh1V9ANRxA2xQk5kyymcDIvYCRYRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGsC+fSe9gXNVgcYhRgINRiYdX8timACHWxLLiytxD
	jBIczEoivGe9NwcI8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJx
	cEo1MC5UYIg7+XD7vD+Lrj/zPDs9xqgs7IPlhW/xVauENp7PVv22bLGS4Nqg8M++X/idZu/7
	ZC2wNeOFVWvE4uOcEnsiP6/NPtx97girjLXYhLXXdl9o5PkUprqq+vn+O9MYHzT8ec7x5f/8
	FS1tte2hb3WUe6enlU3pSJ0ryfVgR/b6veE/tAJ15yYqsRRnJBpqMRcVJwIAA6mnOuEBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_common_get_sgtable() function doesn't depend on
ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY, so it must not be compiled
conditionally.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-mapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 3fbedc7..0ce39a3 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -218,6 +218,8 @@ void dmam_release_declared_memory(struct device *dev)
 }
 EXPORT_SYMBOL(dmam_release_declared_memory);
 
+#endif
+
 /*
  * Create scatter-list for the already allocated DMA buffer.
  */
@@ -236,8 +238,6 @@ int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
 }
 EXPORT_SYMBOL(dma_common_get_sgtable);
 
-#endif
-
 /*
  * Create userspace mapping for the DMA-coherent memory.
  */
-- 
1.7.9.5

