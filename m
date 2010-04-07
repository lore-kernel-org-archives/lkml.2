Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DGXNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:24 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65447 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756955Ab0DGXNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:13:19 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 04/11] ARM: define the PrimeCell DMA API v5
Date: Thu,  8 Apr 2010 01:12:42 +0200
Message-Id: <1270681962-5504-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the DMA engine with a PrimeCell superset with
one function to configure the DMA channel. This has been
identified as the basic extension needed to drive DMA on top of
the PL011, PL022 and PL180 PrimeCells.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/amba/dma.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/amba/dma.h

diff --git a/include/linux/amba/dma.h b/include/linux/amba/dma.h
new file mode 100644
index 0000000..382ef01
--- /dev/null
+++ b/include/linux/amba/dma.h
@@ -0,0 +1,49 @@
+/*
+ *  linux/include/amba/dma.h
+ *
+ *  Copyright (C) 2010 ST-Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#if !defined(AMBA_DMA_H) && defined(CONFIG_DMADEVICES)
+#define AMBA_DMA_H
+
+#include <linux/dma-mapping.h>
+struct dma_chan;
+
+/**
+ * struct amba_dma_channel_config - this struct is passed in as
+ * configuration data to a DMA engine in order to set up a certain
+ * channel for DMA transport. Anything the DMA engine needs to
+ * know about the PrimeCell shall be passed through this struct.
+ * The DMA engine has to provide an additional function:
+ * dma_set_ambaconfig() in order for it to work with PrimeCells.
+ * @addr: this is the physical address where DMA data should be
+ * read (RX) or written (TX)
+ * @addr_width: this is the width of the source (RX) or target
+ * (TX) register where DMA data shall be read/written, in bytes.
+ * legal values: 1, 2, 4, 8.
+ * @direction: whether the data goes in or out on this channel,
+ * right now.
+ * @maxburst: the maximum number of words (note: words, not bytes)
+ * that can be sent in one burst to the device. Typically something
+ * like half the FIFO depth on I/O peripherals so you don't
+ * overflow it.
+ */
+struct amba_dma_channel_config {
+	dma_addr_t addr;
+	u8 addr_width:4;
+	enum dma_data_direction direction;
+	int maxburst;
+};
+
+/*
+ * The following is an extension to the DMA engine framework
+ * that is needed to use the engine with PrimeCells.
+ */
+void dma_set_ambaconfig(struct dma_chan *chan,
+			struct amba_dma_channel_config *config);
+
+#endif /* AMBA_DMA_H */
-- 
1.6.3.3

