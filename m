Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2B1H2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:37 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33891 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932178Ab2B1H2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:16 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 02/13] dmaengine:open dmac and tdma support
Date: Tue, 28 Feb 2012 15:27:34 +0800
Message-Id: <1330414065-2949-3-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:27:59.0267 (UTC) FILETIME=[7F3BA730:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.open dmaengine for tdma and dmac support

Change-Id: I3251daa57cf15fc96e90fbe8be3a1ee303629bcc
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 drivers/dma/Kconfig  |   19 +++++++++++++++++++
 drivers/dma/Makefile |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 25cf327..483b782 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -237,6 +237,25 @@ config MXS_DMA
 	  Support the MXS DMA engine. This engine including APBH-DMA
 	  and APBX-DMA is integrated into Freescale i.MX23/28 chips.
 
+config PXA_DMAC
+	bool "PXA DMAC support"
+	depends on ARCH_PXA || ARCH_MMP
+	select DMA_ENGINE
+	help
+	  Support the PXA DMAC engine. This engine mainly used for PXA DMAC,
+	  also is integrated into Marvell MMP chips for peripheral DMA engine.
+
+config MMP_TDMA
+	bool "MMP Two-Channel DMA support"
+	depends on ARCH_MMP
+	select DMA_ENGINE
+	help
+	  Support the MMP Two-Channel DMA engine. This engine mainly used for
+	  Audio DMA and Memory DMA, now is integrated into Marvell MMP chips.
+
+	  Say Y here if you want to use tdma to manage the adma and mdma,
+	  otherwise say N.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 836095a..ba8e79c 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -25,3 +25,5 @@ obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
 obj-$(CONFIG_PCH_DMA) += pch_dma.o
 obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
+obj-$(CONFIG_PXA_DMAC) += pxa_dmac.o
+obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
-- 
1.7.0.4

