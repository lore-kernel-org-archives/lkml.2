Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1AYKTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:42 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:46616 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1AYKTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:39 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 19/32] dma40: remove export of stedma40_memcpy_sg
Date: Tue, 25 Jan 2011 11:18:22 +0100
Message-ID: <1295950715-22340-20-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The dmaengine framework has the API for this now.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   19 -------------------
 drivers/dma/ste_dma40.c                        |    2 +-
 2 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 8358f85..c448860 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -172,25 +172,6 @@ struct stedma40_platform_data {
 bool stedma40_filter(struct dma_chan *chan, void *data);
 
 /**
- * stedma40_memcpy_sg() - extension of the dma framework, memcpy to/from
- * scattergatter lists.
- *
- * @chan: dmaengine handle
- * @sgl_dst: Destination scatter list
- * @sgl_src: Source scatter list
- * @sgl_len: The length of each scatterlist. Both lists must be of equal length
- * and each element must match the corresponding element in the other scatter
- * list.
- * @flags: is actually enum dma_ctrl_flags. See dmaengine.h
- */
-
-struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
-						   struct scatterlist *sgl_dst,
-						   struct scatterlist *sgl_src,
-						   unsigned int sgl_len,
-						   unsigned long flags);
-
-/**
  * stedma40_slave_mem() - Transfers a raw data buffer to or from a slave
  * (=device)
  *
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8c6abc2..0f5d617 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1733,6 +1733,7 @@ err:
 }
 
 struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
+static struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 						   struct scatterlist *sgl_dst,
 						   struct scatterlist *sgl_src,
 						   unsigned int sgl_len,
@@ -1771,7 +1772,6 @@ err:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return NULL;
 }
-EXPORT_SYMBOL(stedma40_memcpy_sg);
 
 bool stedma40_filter(struct dma_chan *chan, void *data)
 {
-- 
1.7.3.2

