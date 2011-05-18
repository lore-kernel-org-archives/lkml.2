Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab1ERMTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:19:34 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50440 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576Ab1ERMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:19:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dmaengine: move link order
Date: Wed, 18 May 2011 14:18:57 +0200
Message-ID: <1305721137-11433-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dmaengine subsystem up early in the drivers Makefile so
DMA is made available early to all drivers, just like e.g.
regulators. Now even regulators can use DMA on the same initlevel.
As a result we can bump the ste_dma40 and coh901318 dmaengine
drivers down one initlevel to subsys_init().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/Makefile        |    4 +++-
 drivers/dma/coh901318.c |    2 +-
 drivers/dma/ste_dma40.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..e68423d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -17,6 +17,9 @@ obj-$(CONFIG_SFI)		+= sfi/
 # was used and do nothing if so
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
+# Many drivers will want to use DMA so this has to be made available
+# really early.
+obj-$(CONFIG_DMA_ENGINE)	+= dma/
 
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
@@ -92,7 +95,6 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
-obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index f48e540..af8c0b5 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1610,7 +1610,7 @@ int __init coh901318_init(void)
 {
 	return platform_driver_probe(&coh901318_driver, coh901318_probe);
 }
-arch_initcall(coh901318_init);
+subsys_initcall(coh901318_init);
 
 void __exit coh901318_exit(void)
 {
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 94ee15d..22a6d8b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2962,4 +2962,4 @@ static int __init stedma40_init(void)
 {
 	return platform_driver_probe(&d40_driver, d40_probe);
 }
-arch_initcall(stedma40_init);
+subsys_initcall(stedma40_init);
-- 
1.7.3.2

