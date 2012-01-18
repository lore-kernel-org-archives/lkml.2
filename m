Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2ARAc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:32:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17302 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2ARAc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:32:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jan 2012 16:32:55 -0800
From: Robert Morell <rmorell@nvidia.com>
To: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, Robert Morell <rmorell@nvidia.com>
Subject: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Tue, 17 Jan 2012 16:08:17 -0800
Message-Id: <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
issue, and not really an interface".  The dma-buf infrastructure is
explicitly intended as an interface between modules/drivers, so it
should use EXPORT_SYMBOL instead.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
---
 drivers/base/dma-buf.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index e38ad24..4ed5a5d 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -101,7 +101,7 @@ struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
 
 	return dmabuf;
 }
-EXPORT_SYMBOL_GPL(dma_buf_export);
+EXPORT_SYMBOL(dma_buf_export);
 
 
 /**
@@ -126,7 +126,7 @@ int dma_buf_fd(struct dma_buf *dmabuf)
 
 	return fd;
 }
-EXPORT_SYMBOL_GPL(dma_buf_fd);
+EXPORT_SYMBOL(dma_buf_fd);
 
 /**
  * dma_buf_get - returns the dma_buf structure related to an fd
@@ -152,7 +152,7 @@ struct dma_buf *dma_buf_get(int fd)
 
 	return file->private_data;
 }
-EXPORT_SYMBOL_GPL(dma_buf_get);
+EXPORT_SYMBOL(dma_buf_get);
 
 /**
  * dma_buf_put - decreases refcount of the buffer
@@ -167,7 +167,7 @@ void dma_buf_put(struct dma_buf *dmabuf)
 
 	fput(dmabuf->file);
 }
-EXPORT_SYMBOL_GPL(dma_buf_put);
+EXPORT_SYMBOL(dma_buf_put);
 
 /**
  * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
@@ -213,7 +213,7 @@ err_attach:
 	mutex_unlock(&dmabuf->lock);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(dma_buf_attach);
+EXPORT_SYMBOL(dma_buf_attach);
 
 /**
  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
@@ -235,7 +235,7 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 	mutex_unlock(&dmabuf->lock);
 	kfree(attach);
 }
-EXPORT_SYMBOL_GPL(dma_buf_detach);
+EXPORT_SYMBOL(dma_buf_detach);
 
 /**
  * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
@@ -265,7 +265,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
-EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
+EXPORT_SYMBOL(dma_buf_map_attachment);
 
 /**
  * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
@@ -288,4 +288,4 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	mutex_unlock(&attach->dmabuf->lock);
 
 }
-EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
+EXPORT_SYMBOL(dma_buf_unmap_attachment);
-- 
1.7.3.4

