Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1KQHOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:14:42 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:38008 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1KQHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:14:40 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2 v2] pch_dma: Support new device LAPIS Semiconductor ML7831 IOH
Date: Thu, 17 Nov 2011 16:14:23 +0900
Message-Id: <1321514063-14064-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321514063-14064-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321514063-14064-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/dma/Kconfig   |   12 ++++++------
 drivers/dma/pch_dma.c |    6 +++++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 495e841..22439e2 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -201,18 +201,18 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Intel EG20T PCH / LAPIS Semi IOH(ML7213/ML7223) DMA support"
+	tristate "Intel EG20T PCH / LAPIS Semicon IOH(ML7213/ML7223/ML7831) DMA"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
 	  Enable support for Intel EG20T PCH DMA engine.
 
 	  This driver also can be used for LAPIS Semiconductor IOH(Input/
-	  Output Hub), ML7213 and ML7223.
-	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
-	  for MP(Media Phone) use.
-	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
+	  Output Hub), ML7213, ML7223 and ML7831.
+	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use, ML7223 IOH is
+	  for MP(Media Phone) use and ML7831 IOH is for general purpose use.
+	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 config IMX_SDMA
 	tristate "i.MX SDMA support"
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index a9b8a79..60aca37 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -1018,6 +1018,8 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7223_DMA2_4CH	0x800E
 #define PCI_DEVICE_ID_ML7223_DMA3_4CH	0x8017
 #define PCI_DEVICE_ID_ML7223_DMA4_4CH	0x803B
+#define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
+#define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
 
 DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
@@ -1030,6 +1032,8 @@ DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA2_4CH), 4}, /* Video SPI */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA3_4CH), 4}, /* Security */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA4_4CH), 4}, /* FPGA */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_DMA1_8CH), 8}, /* UART */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_DMA2_4CH), 4}, /* SPI */
 	{ 0, },
 };
 
@@ -1057,7 +1061,7 @@ static void __exit pch_dma_exit(void)
 module_init(pch_dma_init);
 module_exit(pch_dma_exit);
 
-MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semiconductor ML7213/ML7223 IOH "
+MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semicon ML7213/ML7223/ML7831 IOH "
 		   "DMA controller driver");
 MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.4

