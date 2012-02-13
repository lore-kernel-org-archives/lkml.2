Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2BMDhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 22:37:15 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:9476
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756129Ab2BMDhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 22:37:04 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>,
        <w.sang@pengutronix.de>, <LW@KARO-electronics.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>, <cjb@laptop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v4 1/2] mxs-dma : move the mxs dma.h to a more common place
Date: Mon, 13 Feb 2012 11:38:22 +0800
Message-ID: <1329104303-13566-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1329104303-13566-1-git-send-email-b32955@freescale.com>
References: <1329104303-13566-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the header to a more common place.
The mxs dma engine is not only used in mx23/mx28, but also used
in mx50/mx6q.  It will also be used in the future chips.

Rename it to mxs-dma.h, and create a new folder include/linux/fsl/ to
store the Freescale's header files.

change mxs-dma driver, mxs-mmc driver, gpmi-nand driver, mxs-saif driver
to the new header file.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/dma/mxs-dma.c                              |    2 +-
 drivers/mmc/host/mxs-mmc.c                         |    2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
 .../mach/dma.h => include/linux/fsl/mxs-dma.h      |    0
 sound/soc/mxs/mxs-pcm.c                            |    2 +-
 sound/soc/mxs/mxs-pcm.h                            |    2 +-
 sound/soc/mxs/mxs-saif.c                           |    2 +-
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/fsl/mxs-dma.h (100%)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b06cd4c..0afcedb 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -22,10 +22,10 @@
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
 #include <linux/delay.h>
+#include <linux/fsl/mxs-dma.h>
 
 #include <asm/irq.h>
 #include <mach/mxs.h>
-#include <mach/dma.h>
 #include <mach/common.h>
 
 /*
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 382c835..e5ea2b1 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -38,10 +38,10 @@
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/fsl/mxs-dma.h>
 
 #include <mach/mxs.h>
 #include <mach/common.h>
-#include <mach/dma.h>
 #include <mach/mmc.h>
 
 #define DRIVER_NAME	"mxs-mmc"
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
index c93b0ae..b9002c8 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
@@ -20,7 +20,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <mach/dma.h>
+#include <linux/fsl/mxs-dma.h>
 
 struct resources {
 	void          *gpmi_regs;
diff --git a/arch/arm/mach-mxs/include/mach/dma.h b/include/linux/fsl/mxs-dma.h
similarity index 100%
rename from arch/arm/mach-mxs/include/mach/dma.h
rename to include/linux/fsl/mxs-dma.h
diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index 105f42a..420715e 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
+#include <linux/fsl/mxs-dma.h>
 
 #include <sound/core.h>
 #include <sound/initval.h>
@@ -35,7 +36,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
-#include <mach/dma.h>
 #include "mxs-pcm.h"
 
 static struct snd_pcm_hardware snd_mxs_hardware = {
diff --git a/sound/soc/mxs/mxs-pcm.h b/sound/soc/mxs/mxs-pcm.h
index f55ac4f..d2c8b12 100644
--- a/sound/soc/mxs/mxs-pcm.h
+++ b/sound/soc/mxs/mxs-pcm.h
@@ -19,7 +19,7 @@
 #ifndef _MXS_PCM_H
 #define _MXS_PCM_H
 
-#include <mach/dma.h>
+#include <linux/fsl/mxs-dma.h>
 
 struct mxs_pcm_dma_params {
 	int chan_irq;
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index f204dba..ce59112 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -24,12 +24,12 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/time.h>
+#include <linux/fsl/mxs-dma.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/saif.h>
-#include <mach/dma.h>
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/mxs.h>
-- 
1.7.0.4


