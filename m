Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2K0F7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:59:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62329 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2K0F7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:59:54 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] media: fix a typo CONFIG_HAVE_GENERIC_DMA_COHERENT in videobuf2-dma-contig.c
Date: Tue, 27 Nov 2012 11:29:39 +0530
Message-Id: <1353995979-28792-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

from commit 93049b9368a2e257ace66252ab2cc066f3399cad, which adds
a check HAVE_GENERIC_DMA_COHERENT for dma ops, the check was wrongly
made it should have been HAVE_GENERIC_DMA_COHERENT but it was
CONFIG_HAVE_GENERIC_DMA_COHERENT.
This patch fixes the typo, which was causing following build error:

videobuf2-dma-contig.c:743: error: 'vb2_dc_get_dmabuf' undeclared here (not in a function)
make[3]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5729450..dfea692 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -739,7 +739,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
-#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
+#ifdef HAVE_GENERIC_DMA_COHERENT
 	.get_dmabuf	= vb2_dc_get_dmabuf,
 #endif
 	.cookie		= vb2_dc_cookie,
-- 
1.7.0.4

