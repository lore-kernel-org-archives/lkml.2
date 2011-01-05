Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1AEIoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:44:12 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:3650 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1AEIoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:44:10 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_dma: support new device ML7213 IOH
Date: Wed,  5 Jan 2011 17:43:52 +0900
Message-Id: <1294217032-5054-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support new device OKI SEMICONDUCTOR's ML7213 IOH(Input/Output Hub) which is for
IVI(In-Vehicle Infotainment) use.
The ML7213 is companion chip for Intel Atom E6xx series.
The ML7213 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/Kconfig   |    9 +++++++--
 drivers/dma/pch_dma.c |   19 ++++++++++++++-----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6ee2359..1b61d3a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -200,11 +200,16 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Topcliff (Intel EG20T) PCH DMA support"
+	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH DMA support"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
-	  Enable support for the Topcliff (Intel EG20T) PCH DMA engine.
+	  Enable support for Intel EG20T PCH DMA engine.
+
+	  This driver also can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/
+	  Output Hub) which is for IVI(In-Vehicle Infotainment) use.
+	  ML7213 is companion chip for Intel Atom E6xx series.
+	  ML7213 is completely compatible for Intel EG20T PCH.
 
 config IMX_SDMA
 	tristate "i.MX SDMA support"
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index c064c89..1c38418 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -1,6 +1,7 @@
 /*
  * Topcliff PCH DMA controller driver
  * Copyright (c) 2010 Intel Corporation
+ * Copyright (C) 2011 OKI SEMICONDUCTOR CO., LTD.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -921,12 +922,19 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 }
 
 /* PCI Device ID of DMA device */
-#define PCI_DEVICE_ID_PCH_DMA_8CH        0x8810
-#define PCI_DEVICE_ID_PCH_DMA_4CH        0x8815
+#define PCI_VENDOR_ID_ROHM             0x10DB
+#define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
+#define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
+#define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
+#define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
+#define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
 
 static const struct pci_device_id pch_dma_id_table[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH_DMA_8CH), 8 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH_DMA_4CH), 4 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA2_8CH), 8}, /* PCMIF SPI */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA3_4CH), 4}, /* FPGA */
 	{ 0, },
 };
 
@@ -954,6 +962,7 @@ static void __exit pch_dma_exit(void)
 module_init(pch_dma_init);
 module_exit(pch_dma_exit);
 
-MODULE_DESCRIPTION("Topcliff PCH DMA controller driver");
+MODULE_DESCRIPTION("Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH "
+		   "DMA controller driver");
 MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
 MODULE_LICENSE("GPL v2");
-- 
1.6.2.5

