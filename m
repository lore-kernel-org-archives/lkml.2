Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0I1HDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:03:42 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:45191 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184Ab0I1HDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:03:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] DMAENGINE: define a dummy filter function for ste_dma40
Date: Tue, 28 Sep 2010 09:03:25 +0200
Message-ID: <1285657405-29059-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
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
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   26 ++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 1127af2..cf92e74 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -170,6 +170,8 @@ struct stedma40_platform_data {
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 };
 
+#ifdef CONFIG_STE_DMA40
+
 /**
  * setdma40_set_psize() - Used for changing the package size of an
  * already configured dma channel.
@@ -245,4 +247,28 @@ dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
 						  direction, flags);
 }
 
+#else
+static inline int stedma40_set_psize(struct dma_chan *chan,
+		       int src_psize,
+		       int dst_psize)
+{
+	return 0;
+}
+
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

