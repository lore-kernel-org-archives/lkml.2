Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IKNB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:01:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2IKNAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Chris Ball <cjb@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 05/16] ARM: msm: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:39 +0200
Message-Id: <1347368390-31252-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Z42aUcj0KjB9+Ha0tSeQqEUPTFNu7/RArZ/R+e/d1x1
 KO+O8zmroODEJlURTaxg42gZRZtU+cVqe4+9CqfPoId1seq4LN
 CgRAOfac4n+EBBTipWs258HKLMMYRlYhdk1Xam/k1Adun9ou/T
 7wgKyKMmPJNCz4i4af2Oj9tJTz+mlZsx49mDh00dKOUrMRBK3K
 wCm9Byk32PZjy43blaoqtDzaDfRghNSxkAS8qcgjs+mL+TSnqH
 +i5zyHEzVW/S1KoBnDkKM2Z3JuZH397jn5aFIpbYpHLATomsQy
 e6QNaCG0zuTyOXw1JRYmOczHr5RbFLlMy1Vnwo/j2MRNb4nEyd
 NbkO8fhcK739NL9INHPcFfyhBGTa5TNFQACucRdapheiV55ycT
 pK/0VtuoxHGzEXkOwzJowjNJQ/rxZONd4g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the msm include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-arm-msm@vger.kernel.org
---
 arch/arm/mach-msm/board-qsd8x50.c                                    |    2 +-
 arch/arm/mach-msm/board-trout-mmc.c                                  |    2 +-
 arch/arm/mach-msm/board-trout-panel.c                                |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c                                  |    2 +-
 arch/arm/mach-msm/devices-msm7x30.c                                  |    2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                                  |    2 +-
 arch/arm/mach-msm/include/mach/board.h                               |    2 +-
 drivers/mmc/host/msm_sdcc.c                                          |    2 +-
 drivers/video/msm/mddi.c                                             |    2 +-
 drivers/video/msm/mddi_client_dummy.c                                |    2 +-
 drivers/video/msm/mddi_client_nt35399.c                              |    2 +-
 drivers/video/msm/mddi_client_toshiba.c                              |    2 +-
 drivers/video/msm/mdp.c                                              |    2 +-
 drivers/video/msm/mdp_hw.h                                           |    2 +-
 drivers/video/msm/mdp_ppp.c                                          |    2 +-
 drivers/video/msm/msm_fb.c                                           |    2 +-
 .../include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h |    0
 .../mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h      |    0
 18 files changed, 16 insertions(+), 16 deletions(-)
 rename arch/arm/mach-msm/include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h (100%)
 rename arch/arm/mach-msm/include/mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h (100%)

diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index c8fe0ed..b21bb4c 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -32,7 +32,7 @@
 #include <mach/irqs.h>
 #include <mach/sirc.h>
 #include <mach/vreg.h>
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 
 #include "devices.h"
 
diff --git a/arch/arm/mach-msm/board-trout-mmc.c b/arch/arm/mach-msm/board-trout-mmc.c
index 8650342..3723e55 100644
--- a/arch/arm/mach-msm/board-trout-mmc.c
+++ b/arch/arm/mach-msm/board-trout-mmc.c
@@ -15,7 +15,7 @@
 
 #include <mach/vreg.h>
 
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 
 #include "devices.h"
 
diff --git a/arch/arm/mach-msm/board-trout-panel.c b/arch/arm/mach-msm/board-trout-panel.c
index 89bf6b4..f9a5db6 100644
--- a/arch/arm/mach-msm/board-trout-panel.c
+++ b/arch/arm/mach-msm/board-trout-panel.c
@@ -14,7 +14,7 @@
 #include <asm/mach-types.h>
 #include <asm/system_info.h>
 
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 #include <mach/vreg.h>
 
 #include "board-trout.h"
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 993780f..f66ee6e 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -27,7 +27,7 @@
 
 #include "clock.h"
 #include "clock-pcom.h"
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 
 static struct resource resources_uart1[] = {
 	{
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 09b4f14..e90ab59 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -31,7 +31,7 @@
 #include "clock-pcom.h"
 #include "clock-7x30.h"
 
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 
 static struct resource resources_uart2[] = {
 	{
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 131633b..4db61d5 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -27,7 +27,7 @@
 
 #include <asm/mach/flash.h>
 
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 #include "clock-pcom.h"
 
 static struct resource resources_uart3[] = {
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 435f8ed..70e0f98 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -18,7 +18,7 @@
 #define __ASM_ARCH_MSM_BOARD_H
 
 #include <linux/types.h>
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 
 /* platform device data structures */
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1d14cda..7c0af0e 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -42,7 +42,7 @@
 #include <asm/div64.h>
 #include <asm/sizes.h>
 
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-msm_sdcc.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
 #include <mach/clk.h>
diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index b061d70..bf73f04 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -29,7 +29,7 @@
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 #include "mddi_hw.h"
 
 #define FLAG_DISABLE_HIBERNATION 0x0001
diff --git a/drivers/video/msm/mddi_client_dummy.c b/drivers/video/msm/mddi_client_dummy.c
index d2a091c..f1b0dfc 100644
--- a/drivers/video/msm/mddi_client_dummy.c
+++ b/drivers/video/msm/mddi_client_dummy.c
@@ -20,7 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 
 struct panel_info {
 	struct platform_device pdev;
diff --git a/drivers/video/msm/mddi_client_nt35399.c b/drivers/video/msm/mddi_client_nt35399.c
index 7fcd67e..d7a5bf8 100644
--- a/drivers/video/msm/mddi_client_nt35399.c
+++ b/drivers/video/msm/mddi_client_nt35399.c
@@ -22,7 +22,7 @@
 #include <linux/sched.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 
 static DECLARE_WAIT_QUEUE_HEAD(nt35399_vsync_wait);
 
diff --git a/drivers/video/msm/mddi_client_toshiba.c b/drivers/video/msm/mddi_client_toshiba.c
index 053eb68..061d7df 100644
--- a/drivers/video/msm/mddi_client_toshiba.c
+++ b/drivers/video/msm/mddi_client_toshiba.c
@@ -22,7 +22,7 @@
 #include <linux/gpio.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 
 
 #define LCD_CONTROL_BLOCK_BASE 0x110000
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index cb2ddf1..d1f881e 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 
 #include <mach/msm_iomap.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 #include <linux/platform_device.h>
 #include <linux/export.h>
 
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index d804774..a0bacf5 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -16,7 +16,7 @@
 #define _MDP_HW_H_
 
 #include <mach/msm_iomap.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 
 struct mdp_info {
 	struct mdp_device mdp_dev;
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 2b6564e..be6079c 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -16,7 +16,7 @@
 #include <linux/file.h>
 #include <linux/delay.h>
 #include <linux/msm_mdp.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 
 #include "mdp_hw.h"
 #include "mdp_scale_tables.h"
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index c6e3b4f..ec08a9e 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -25,7 +25,7 @@
 #include <linux/msm_mdp.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <mach/msm_fb.h>
+#include <linux/platform_data/video-msm_fb.h>
 #include <mach/board.h>
 #include <linux/workqueue.h>
 #include <linux/clk.h>
diff --git a/arch/arm/mach-msm/include/mach/mmc.h b/include/linux/platform_data/mmc-msm_sdcc.h
similarity index 100%
rename from arch/arm/mach-msm/include/mach/mmc.h
rename to include/linux/platform_data/mmc-msm_sdcc.h
diff --git a/arch/arm/mach-msm/include/mach/msm_fb.h b/include/linux/platform_data/video-msm_fb.h
similarity index 100%
rename from arch/arm/mach-msm/include/mach/msm_fb.h
rename to include/linux/platform_data/video-msm_fb.h
-- 
1.7.10

