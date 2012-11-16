Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2KPOrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:47:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32926 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2KPOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:47:36 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 11/12] davinci: vpfe: dm365: add build infrastructure for capture driver
Date: Fri, 16 Nov 2012 20:15:13 +0530
Message-Id: <1353077114-19296-12-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add build infrastructure for dm365 specific modules for VPFE
capture driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/Kconfig  |   11 +++++++++++
 drivers/media/platform/davinci/Makefile |    3 +++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 78e26d2..b52c642 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -119,3 +119,14 @@ config VIDEO_VPBE_DISPLAY
 
 	    To compile this driver as a module, choose M here: the
 	    module will be called vpbe_display.
+
+
+config VIDEO_DM365_VPFE_CAPTURE
+	tristate "DM365 VPFE Media Controller Capture Driver"
+	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_VPFE_CAPTURE
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  Support for DM365 VPFE based Media Controller Capture driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpfe-mc-capture.
diff --git a/drivers/media/platform/davinci/Makefile b/drivers/media/platform/davinci/Makefile
index 74ed92d..8ca702e 100644
--- a/drivers/media/platform/davinci/Makefile
+++ b/drivers/media/platform/davinci/Makefile
@@ -18,3 +18,6 @@ obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
 obj-$(CONFIG_VIDEO_ISIF) += isif.o
 obj-$(CONFIG_VIDEO_DM644X_VPBE) += vpbe.o vpbe_osd.o vpbe_venc.o
 obj-$(CONFIG_VIDEO_VPBE_DISPLAY) += vpbe_display.o
+obj-$(CONFIG_VIDEO_DM365_VPFE_CAPTURE) += \
+	dm365_isif.o dm365_ipipe_hw.o dm365_ipipe.o \
+	dm365_resizer.o dm365_ipipeif.o vpfe_mc_capture.o vpfe_video.o
-- 
1.7.4.1

