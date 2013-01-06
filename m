Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3AFRZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:25:32 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:32790 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3AFRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:25:29 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v4 1/3] videobuf2-dma-contig: user can specify GFP flags
Date: Sun,  6 Jan 2013 18:29:01 +0100
Message-Id: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful when you need to specify specific GFP flags during memory
allocation (e.g. GFP_DMA).

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 7 ++-----
 include/media/videobuf2-dma-contig.h           | 5 +++++
 2 file modificati, 7 inserzioni(+), 5 rimozioni(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 10beaee..bb411c0 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -21,10 +21,6 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
-struct vb2_dc_conf {
-	struct device		*dev;
-};
-
 struct vb2_dc_buf {
 	struct device			*dev;
 	void				*vaddr;
@@ -165,7 +161,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	/* align image size to PAGE_SIZE */
 	size = PAGE_ALIGN(size);
 
-	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
+	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
+									GFP_KERNEL | conf->mem_flags);
 	if (!buf->vaddr) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
 		kfree(buf);
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..22733f4 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -16,6 +16,11 @@
 #include <media/videobuf2-core.h>
 #include <linux/dma-mapping.h>
 
+struct vb2_dc_conf {
+	struct device		*dev;
+	gfp_t				mem_flags;
+};
+
 static inline dma_addr_t
 vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
-- 
1.7.11.7

