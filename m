Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2KZUSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab2KZUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:18:47 -0500
Date: Mon, 26 Nov 2012 18:18:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Fw: [PATCH] dma-mapping: fix dma_common_get_sgtable() conditional
 compilation
Message-ID: <20121126181837.0596a25a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Are you maintaining drivers/base/dma-mapping.c? The enclosed path is needed to
enable DMABUF handling on V4L2 on some architectures, like x86_64, as we need
dma_common_get_sgtable() on drivers/media/v4l2-core/videobuf2-dma-contig.c.

Would you mind acking it, in order to let this patch flow via my tree? This way,
I can revert a workaround I had to apply there, in order to avoid linux-next
compilation breakage.

Thanks!
Mauro

-

From: Marek Szyprowski <m.szyprowski@samsung.com>
Date: Mon, 26 Nov 2012 14:41:48 +0100

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



-- 
Regards,
Mauro
