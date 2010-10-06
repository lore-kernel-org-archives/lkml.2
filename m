Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab0JFJFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:05:50 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:59737 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758789Ab0JFJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:05:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/3] DMAENGINE: define a dummy filter function for ste_dma40
Date: Wed, 6 Oct 2010 11:05:29 +0200
Message-ID: <1286355929-31226-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286355929-31226-3-git-send-email-linus.walleij@stericsson.com>
References: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
 <1286355929-31226-2-git-send-email-linus.walleij@stericsson.com>
 <1286355929-31226-3-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All platform data has to be made conditional on CONFIG_STEDMA40
or we can provide a simple dummy filter functions as to avoid
cluttering the code with other #ifdef:s.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Dan I have had to bring this over from the platform (ARM) tree
since the previous patch now collides with it so please pick
it in through async_tx...
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 660552d..3dd4255 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -162,6 +162,8 @@ struct stedma40_platform_data {
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 };
 
+#ifdef CONFIG_STE_DMA40
+
 /**
  * stedma40_filter() - Provides stedma40_chan_cfg to the
  * ste_dma40 dma driver via the dmaengine framework.
@@ -223,4 +225,21 @@ dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
 						  direction, flags);
 }
 
+#else
+static inline bool stedma40_filter(struct dma_chan *chan, void *data)
+{
+	return false;
+}
+
+static inline struct
+dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
+					    dma_addr_t addr,
+					    unsigned int size,
+					    enum dma_data_direction direction,
+					    unsigned long flags)
+{
+	return NULL;
+}
+#endif
+
 #endif
-- 
1.6.3.3

