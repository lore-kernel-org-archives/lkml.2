Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0CQQ0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:26:53 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:54015 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab0CQQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:26:28 -0400
X-Spam-Processed: digidescorp.com, Wed, 17 Mar 2010 11:26:27 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16925da2b5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, Grant Likely <grant.likely@secretlab.ca>,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH 2/4] dmaengine: Xilinx MPMC Kconfig/make
Date: Wed, 17 Mar 2010 11:26:16 -0500
Message-Id: <1268843176-15269-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate xlldma drivers into the build.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/drivers/dma/Kconfig b/drivers/dma/Kconfig
--- a/drivers/dma/Kconfig	2010-03-16 13:27:42.000000000 -0500
+++ b/drivers/dma/Kconfig	2010-03-17 11:11:57.000000000 -0500
@@ -126,6 +126,28 @@ config AMCC_PPC440SPE_ADMA
 	help
 	  Enable support for the AMCC PPC440SPe RAID engines.
 
+config XLL_DMA
+	tristate "Xilinx LocalLink DMA support"
+	depends on XILINX_VIRTEX || MICROBLAZE
+	select DMA_ENGINE
+	---help---
+	  Enable support for the Xilinx MPMC DMA controller.
+	  This requires at least one MPMC SDMA port wired as a "loopback".
+
+	  If unsure, say N.
+
+config XLL_DMA_OF
+        tristate "Xilinx LocalLink DMA OF device"
+        depends on XLL_DMA && OF
+        help
+          OpenFirmware bus attachment for the Xilinx LocalLink DMA engine.
+
+config XLL_DMA_PLAT
+        tristate "Xilinx LocalLink DMA platform device"
+        depends on XLL_DMA
+        help
+          Platform bus attachment for the Xilinx LocalLink DMA engine.
+
 config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 	bool
 
@@ -138,13 +160,13 @@ comment "DMA Clients"
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
-	default (INTEL_IOATDMA || FSL_DMA)
+	default (INTEL_IOATDMA || FSL_DMA || XLL_DMA)
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
 
-	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
-	  say N.
+	  Say Y here if you enabled INTEL_IOATDMA, FSL_DMA, or XLL_DMA,
+	  otherwise say N.
 
 config ASYNC_TX_DMA
 	bool "Async_tx: Offload support for the async_tx api"
diff -uprN a/drivers/dma/Makefile b/drivers/dma/Makefile
--- a/drivers/dma/Makefile	2010-03-16 13:27:37.000000000 -0500
+++ b/drivers/dma/Makefile	2010-03-16 15:10:54.000000000 -0500
@@ -11,4 +11,7 @@ obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
 obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
+obj-$(CONFIG_XLL_DMA) += xlldma.o
+obj-$(CONFIG_XLL_DMA_OF) += xlldma_of.o
+obj-$(CONFIG_XLL_DMA_PLAT) += xlldma_plat.o
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/


