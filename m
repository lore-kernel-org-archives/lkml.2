Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2INMvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:51:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57042 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2INMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:51:15 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 13/14] davinci: vpfe: build infrastructure for dm365
Date: Fri, 14 Sep 2012 18:16:43 +0530
Message-Id: <1347626804-5703-14-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add build infrastructure for dm365 specific modules
such as IPIPE, AEW, AF.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/Kconfig  |   40 +++++++++++++++++++++++++++++-
 drivers/media/platform/davinci/Makefile |    9 +++++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 78e26d2..4eddb00 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -56,7 +56,7 @@ config VIDEO_VPFE_CAPTURE
 
 config VIDEO_DM6446_CCDC
 	tristate "DM6446 CCDC HW module"
-	depends on VIDEO_VPFE_CAPTURE
+	depends on VIDEO_VPFE_CAPTURE && ARCH_DAVINCI_DM644x
 	select VIDEO_VPSS_SYSTEM
 	default y
 	help
@@ -85,7 +85,7 @@ config VIDEO_DM355_CCDC
 	   module will be called vpfe.
 
 config VIDEO_ISIF
-	tristate "ISIF HW module"
+	tristate "DM365 ISIF HW module"
 	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
 	select VIDEO_VPSS_SYSTEM
 	default y
@@ -119,3 +119,39 @@ config VIDEO_VPBE_DISPLAY
 
 	    To compile this driver as a module, choose M here: the
 	    module will be called vpbe_display.
+
+
+config VIDEO_365_CCDC
+	tristate "DM365 CCDC HW module"
+	depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_MC_CAPTURE
+	select VIDEO_VPSS_SYSTEM
+	default y
+	help
+	   Enables ISIF hw module. This is the hardware module for
+	   configuring ISIF in VPFE to capture Raw Bayer RGB data  from
+	   a image sensor or YUV data from a YUV source.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called vpfe.
+
+config DM365_IPIPE
+	depends on ARCH_DAVINCI && ARCH_DAVINCI_DM365 && VIDEO_VPFE_MC_CAPTURE
+	tristate "DM365 IPIPE"
+	help
+	  dm365 IPIPE hardware module.
+
+	  This is the hardware module that implements imp_hw_interface
+	  for DM365. This hardware module provides previewer and resizer
+	  functionality for image processing.
+
+config VIDEO_VPFE_MC_CAPTURE
+	tristate "VPFE Media Controller Capture Driver"
+	depends on VIDEO_V4L2 && (ARCH_DAVINCI) && !VIDEO_VPFE_CAPTURE
+	select VIDEOBUF_DMA_CONTIG
+	help
+	  Support for DMx/AMx VPFE based Media Controller Capture driver. This is the
+	  common V4L2 module for following DMx/AMx SoCs from Texas
+	  Instruments:- DM6446, DM365, DM355 & AM3517/05.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpfe-mc-capture.
diff --git a/drivers/media/platform/davinci/Makefile b/drivers/media/platform/davinci/Makefile
index 74ed92d..955f63d 100644
--- a/drivers/media/platform/davinci/Makefile
+++ b/drivers/media/platform/davinci/Makefile
@@ -16,5 +16,14 @@ obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
 obj-$(CONFIG_VIDEO_ISIF) += isif.o
+obj-$(CONFIG_VIDEO_365_CCDC) += dm365_ccdc.o
+obj-$(CONFIG_VIDEO_VPFE_MC_CAPTURE) += vpfe_mc_capture.o \
+		vpfe_ccdc.o vpfe_resizer.o vpfe_previewer.o \
+		vpfe_video.o
+
+dm365_imp-objs := dm365_ipipe.o dm365_def_para.o \
+		dm365_ipipe_hw.o dm3xx_ipipeif.o
+obj-$(CONFIG_DM365_IPIPE) += dm365_imp.o
+
 obj-$(CONFIG_VIDEO_DM644X_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
 obj-$(CONFIG_VIDEO_VPBE_DISPLAY) += vpbe_display.o
-- 
1.7.4.1

