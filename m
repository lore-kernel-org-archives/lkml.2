Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2K1O6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:58:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab2K1O6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:58:53 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH] media: davinci: vpbe: enable building of vpbe driver for DM355 and DM365
Date: Wed, 28 Nov 2012 20:28:47 +0530
Message-Id: <1354114727-12547-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch allows enabling building of VPBE display driver for DM365
and DM355. This also removes unnecessary entry VIDEO_DM644X_VPBE
in Kconfig, which could have been done with single entry, and
appropriate changes in Makefile for building.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/platform/davinci/Kconfig  |   22 ++++++----------------
 drivers/media/platform/davinci/Makefile |    4 ++--
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 3c56037..ccfde4e 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -97,25 +97,15 @@ config VIDEO_ISIF
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
 
-config VIDEO_DM644X_VPBE
-	tristate "DM644X VPBE HW module"
-	depends on ARCH_DAVINCI_DM644x
+config VIDEO_DAVINCI_VPBE_DISPLAY
+	tristate "DM644X/DM365/DM355 VPBE HW module"
+	depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365
 	select VIDEO_VPSS_SYSTEM
 	select VIDEOBUF2_DMA_CONTIG
 	help
-	    Enables VPBE modules used for display on a DM644x
-	    SoC.
+	    Enables Davinci VPBE module used for display devices.
+	    This module is common for following DM644x/DM365/DM355
+	    based display devices.
 
 	    To compile this driver as a module, choose M here: the
 	    module will be called vpbe.
-
-
-config VIDEO_VPBE_DISPLAY
-	tristate "VPBE V4L2 Display driver"
-	depends on ARCH_DAVINCI_DM644x
-	select VIDEO_DM644X_VPBE
-	help
-	    Enables VPBE V4L2 Display driver on a DM644x device
-
-	    To compile this driver as a module, choose M here: the
-	    module will be called vpbe_display.
diff --git a/drivers/media/platform/davinci/Makefile b/drivers/media/platform/davinci/Makefile
index 74ed92d..f40f521 100644
--- a/drivers/media/platform/davinci/Makefile
+++ b/drivers/media/platform/davinci/Makefile
@@ -16,5 +16,5 @@ obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
 obj-$(CONFIG_VIDEO_ISIF) += isif.o
-obj-$(CONFIG_VIDEO_DM644X_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
-obj-$(CONFIG_VIDEO_VPBE_DISPLAY) += vpbe_display.o
+obj-$(CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY) += vpbe.o vpbe_osd.o \
+	vpbe_venc.o vpbe_display.o
-- 
1.7.4.1

