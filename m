Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1EIDsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:48:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:12907 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab1EIDsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:48:13 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH V2 5/5] pch_dma: Support new device ML7223 IOH
Date: Mon,  9 May 2011 12:48:05 +0900
Message-Id: <1304912885-6747-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
The ML7223 IOH is for MP(Media Phone) use.
The ML7223 is companion chip for Intel Atom E6xx series.
The ML7223 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/Kconfig   |   12 +++++++-----
 drivers/dma/pch_dma.c |    8 ++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index a572600..6eb353c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -200,16 +200,18 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH DMA support"
+	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223)"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
 	  Enable support for Intel EG20T PCH DMA engine.
 
-	  This driver also can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/
-	  Output Hub) which is for IVI(In-Vehicle Infotainment) use.
-	  ML7213 is companion chip for Intel Atom E6xx series.
-	  ML7213 is completely compatible for Intel EG20T PCH.
+	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
+	  Output Hub), ML7213 and ML7223.
+	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
+	  for MP(Media Phone) use.
+	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 
 config IMX_SDMA
 	tristate "i.MX SDMA support"
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 2c052bb..466954d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -956,6 +956,10 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
 #define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
 #define PCI_DEVICE_ID_ML7213_DMA4_12CH	0x8032
+#define PCI_DEVICE_ID_ML7223_DMA1_4CH	0x800B
+#define PCI_DEVICE_ID_ML7223_DMA2_4CH	0x800E
+#define PCI_DEVICE_ID_ML7223_DMA3_4CH	0x8017
+#define PCI_DEVICE_ID_ML7223_DMA4_4CH	0x803B
 
 static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
@@ -964,6 +968,10 @@ static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA2_8CH), 8}, /* PCMIF SPI */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA3_4CH), 4}, /* FPGA */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA4_12CH), 12}, /* I2S */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA1_4CH), 4}, /* UART */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA2_4CH), 4}, /* Video SPI */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA3_4CH), 4}, /* Security */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA4_4CH), 4}, /* FPGA */
 	{ 0, },
 };
 
-- 
1.7.4

