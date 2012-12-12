Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2LLJXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:23:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2LLJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:23:06 -0500
Message-ID: <50C84CF7.7030602@canonical.com>
Date: Wed, 12 Dec 2012 10:23:03 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation says that code requiring dma-buf should add it to
select, so inline fallbacks are not going to be used. A link error
will make it obvious what went wrong, instead of silently doing
nothing at runtime.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Rob Clark <rob.clark@linaro.org>

---
Resubmit since it seemed to have gotten lost last cycle.

 include/linux/dma-buf.h | 99 -------------------------------------------------
 1 file changed, 99 deletions(-)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..bd2e52c 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -156,7 +156,6 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
 	get_file(dmabuf->file);
 }
 
-#ifdef CONFIG_DMA_SHARED_BUFFER
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 							struct device *dev);
 void dma_buf_detach(struct dma_buf *dmabuf,
@@ -184,103 +183,5 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
 void *dma_buf_vmap(struct dma_buf *);
 void dma_buf_vunmap(struct dma_buf *, void *vaddr);
-#else
-
-static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-							struct device *dev)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline void dma_buf_detach(struct dma_buf *dmabuf,
-				  struct dma_buf_attachment *dmabuf_attach)
-{
-	return;
-}
-
-static inline struct dma_buf *dma_buf_export(void *priv,
-					     const struct dma_buf_ops *ops,
-					     size_t size, int flags)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline int dma_buf_fd(struct dma_buf *dmabuf, int flags)
-{
-	return -ENODEV;
-}
-
-static inline struct dma_buf *dma_buf_get(int fd)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline void dma_buf_put(struct dma_buf *dmabuf)
-{
-	return;
-}
-
-static inline struct sg_table *dma_buf_map_attachment(
-	struct dma_buf_attachment *attach, enum dma_data_direction write)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
-			struct sg_table *sg, enum dma_data_direction dir)
-{
-	return;
-}
-
-static inline int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
-					   size_t start, size_t len,
-					   enum dma_data_direction dir)
-{
-	return -ENODEV;
-}
-
-static inline void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
-					  size_t start, size_t len,
-					  enum dma_data_direction dir)
-{
-}
-
-static inline void *dma_buf_kmap_atomic(struct dma_buf *dmabuf,
-					unsigned long pnum)
-{
-	return NULL;
-}
-
-static inline void dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
-					 unsigned long pnum, void *vaddr)
-{
-}
-
-static inline void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long pnum)
-{
-	return NULL;
-}
-
-static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
-				  unsigned long pnum, void *vaddr)
-{
-}
-
-static inline int dma_buf_mmap(struct dma_buf *dmabuf,
-			       struct vm_area_struct *vma,
-			       unsigned long pgoff)
-{
-	return -ENODEV;
-}
-
-static inline void *dma_buf_vmap(struct dma_buf *dmabuf)
-{
-	return NULL;
-}
-
-static inline void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
-{
-}
-#endif /* CONFIG_DMA_SHARED_BUFFER */
 
 #endif /* __DMA_BUF_H__ */
-- 
1.8.0


