Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab1IVHE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:04:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18708 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1IVHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:04:56 -0400
Date: Thu, 22 Sep 2011 09:04:42 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] staging: dt3155v4l: fix build break
In-reply-to: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Marin Mitov <mitov@issp.bas.bg>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1316675082-9310-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.5.4
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes build break caused by commit ba7fcb0c9549 ("[media] media: vb2: dma
contig allocator: use dma_addr instread of paddr").

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/staging/dt3155v4l/dt3155v4l.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 05aa41c..0ede5d1 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -207,7 +207,7 @@ dt3155_start_acq(struct dt3155_priv *pd)
 	struct vb2_buffer *vb = pd->curr_buf;
 	dma_addr_t dma_addr;
 
-	dma_addr = vb2_dma_contig_plane_paddr(vb, 0);
+	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
 	iowrite32(dma_addr + img_width, pd->regs + ODD_DMA_START);
 	iowrite32(img_width, pd->regs + EVEN_DMA_STRIDE);
@@ -374,7 +374,7 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 	ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
 	list_del(&ivb->done_entry);
 	ipd->curr_buf = ivb;
-	dma_addr = vb2_dma_contig_plane_paddr(ivb, 0);
+	dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
 	iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
 	iowrite32(dma_addr + img_width, ipd->regs + ODD_DMA_START);
 	iowrite32(img_width, ipd->regs + EVEN_DMA_STRIDE);
-- 
1.7.1.569.g6f426

