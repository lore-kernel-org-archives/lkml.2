Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1KUTsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:48:47 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:53430 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934Ab1KUTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:48:45 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/8] ARM: u300: localize GPIO assignments
Date: Mon, 21 Nov 2011 20:48:06 +0100
Message-ID: <1321904887-32311-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Move the GPIO assignments for the U300 variants down to a local
header file in the mach-u300 directory. There is no point in
broadcasting this across the entire kernel.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/include/mach/gpio-u300.h |  115 ---------------------------
 arch/arm/mach-u300/mmc.c                    |    2 +-
 arch/arm/mach-u300/u300-gpio.h              |  114 ++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 116 deletions(-)
 create mode 100644 arch/arm/mach-u300/u300-gpio.h

diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/arch/arm/mach-u300/include/mach/gpio-u300.h
index 0c2b202..bf4c793 100644
--- a/arch/arm/mach-u300/include/mach/gpio-u300.h
+++ b/arch/arm/mach-u300/include/mach/gpio-u300.h
@@ -9,121 +9,6 @@
 #ifndef __MACH_U300_GPIO_U300_H
 #define __MACH_U300_GPIO_U300_H
 
-/*
- * Individual pin assignments for the B26/S26. Notice that the
- * actual usage of these pins depends on the PAD MUX settings, that
- * is why the same number can potentially appear several times.
- * In the reference design each pin is only used for one purpose.
- * These were determined by inspecting the B26/S26 schematic:
- * 2/1911-ROA 128 1603
- */
-#ifdef CONFIG_MACH_U300_BS2X
-#define U300_GPIO_PIN_UART_RX		0
-#define U300_GPIO_PIN_UART_TX		1
-#define U300_GPIO_PIN_GPIO02		2  /* Unrouted */
-#define U300_GPIO_PIN_GPIO03		3  /* Unrouted */
-#define U300_GPIO_PIN_CAM_SLEEP		4
-#define U300_GPIO_PIN_CAM_REG_EN	5
-#define U300_GPIO_PIN_GPIO06		6  /* Unrouted */
-#define U300_GPIO_PIN_GPIO07		7  /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO08		8  /* Service point SP2321 */
-#define U300_GPIO_PIN_GPIO09		9  /* Service point SP2322 */
-#define U300_GPIO_PIN_PHFSENSE		10 /* Headphone jack sensing */
-#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
-#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
-#define U300_GPIO_PIN_FLIPSENSE		13 /* Mechanical flip sensing */
-#define U300_GPIO_PIN_GPIO14		14 /* DSP JTAG Port RTCK */
-#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO16		16 /* Unrouted */
-#define U300_GPIO_PIN_GPIO17		17 /* Unrouted */
-#define U300_GPIO_PIN_GPIO18		18 /* Unrouted */
-#define U300_GPIO_PIN_GPIO19		19 /* Unrouted */
-#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
-#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
-#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
-#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
-#endif
-
-/*
- * Individual pin assignments for the B330/S330 and B365/S365.
- * Notice that the actual usage of these pins depends on the
- * PAD MUX settings, that is why the same number can potentially
- * appear several times. In the reference design each pin is only
- * used for one purpose. These were determined by inspecting the
- * S365 schematic.
- */
-#if defined(CONFIG_MACH_U300_BS330) || defined(CONFIG_MACH_U300_BS365) || \
-    defined(CONFIG_MACH_U300_BS335)
-#define U300_GPIO_PIN_UART_RX		0
-#define U300_GPIO_PIN_UART_TX		1
-#define U300_GPIO_PIN_UART_CTS		2
-#define U300_GPIO_PIN_UART_RTS		3
-#define U300_GPIO_PIN_CAM_MAIN_STANDBY	4 /* Camera MAIN standby */
-#define U300_GPIO_PIN_GPIO05		5 /* Unrouted */
-#define U300_GPIO_PIN_MS_CD		6 /* Memory Stick Card insertion */
-#define U300_GPIO_PIN_GPIO07		7 /* Test point TP2430 */
-
-#define U300_GPIO_PIN_GPIO08		8 /* Test point TP2437 */
-#define U300_GPIO_PIN_GPIO09		9 /* Test point TP2431 */
-#define U300_GPIO_PIN_GPIO10		10 /* Test point TP2432 */
-#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
-#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
-#define U300_GPIO_PIN_CAM_SUB_STANDBY	13 /* Camera SUB standby */
-#define U300_GPIO_PIN_GPIO14		14 /* Test point TP2436 */
-#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO16		16 /* Test point TP2438 */
-#define U300_GPIO_PIN_PHFSENSE		17 /* Headphone jack sensing */
-#define U300_GPIO_PIN_GPIO18		18 /* Test point TP2439 */
-#define U300_GPIO_PIN_GPIO19		19 /* Routed somewhere */
-#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
-#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
-#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
-#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO24		24 /* Unrouted */
-#define U300_GPIO_PIN_GPIO25		25 /* Unrouted */
-#define U300_GPIO_PIN_GPIO26		26 /* Unrouted */
-#define U300_GPIO_PIN_GPIO27		27 /* Unrouted */
-#define U300_GPIO_PIN_GPIO28		28 /* Unrouted */
-#define U300_GPIO_PIN_GPIO29		29 /* Unrouted */
-#define U300_GPIO_PIN_GPIO30		30 /* Unrouted */
-#define U300_GPIO_PIN_GPIO31		31 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO32		32 /* Unrouted */
-#define U300_GPIO_PIN_GPIO33		33 /* Unrouted */
-#define U300_GPIO_PIN_GPIO34		34 /* Unrouted */
-#define U300_GPIO_PIN_GPIO35		35 /* Unrouted */
-#define U300_GPIO_PIN_GPIO36		36 /* Unrouted */
-#define U300_GPIO_PIN_GPIO37		37 /* Unrouted */
-#define U300_GPIO_PIN_GPIO38		38 /* Unrouted */
-#define U300_GPIO_PIN_GPIO39		39 /* Unrouted */
-
-#ifdef CONFIG_MACH_U300_BS335
-
-#define U300_GPIO_PIN_GPIO40		40 /* Unrouted */
-#define U300_GPIO_PIN_GPIO41		41 /* Unrouted */
-#define U300_GPIO_PIN_GPIO42		42 /* Unrouted */
-#define U300_GPIO_PIN_GPIO43		43 /* Unrouted */
-#define U300_GPIO_PIN_GPIO44		44 /* Unrouted */
-#define U300_GPIO_PIN_GPIO45		45 /* Unrouted */
-#define U300_GPIO_PIN_GPIO46		46 /* Unrouted */
-#define U300_GPIO_PIN_GPIO47		47 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO48		48 /* Unrouted */
-#define U300_GPIO_PIN_GPIO49		49 /* Unrouted */
-#define U300_GPIO_PIN_GPIO50		50 /* Unrouted */
-#define U300_GPIO_PIN_GPIO51		51 /* Unrouted */
-#define U300_GPIO_PIN_GPIO52		52 /* Unrouted */
-#define U300_GPIO_PIN_GPIO53		53 /* Unrouted */
-#define U300_GPIO_PIN_GPIO54		54 /* Unrouted */
-#define U300_GPIO_PIN_GPIO55		55 /* Unrouted */
-#endif
-
-#endif
-
 /**
  * enum u300_gpio_variant - the type of U300 GPIO employed
  */
diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index 4d482aa..05abd6a 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -18,8 +18,8 @@
 #include <linux/slab.h>
 #include <mach/coh901318.h>
 #include <mach/dma_channels.h>
-#include <mach/gpio-u300.h>
 
+#include "u300-gpio.h"
 #include "mmc.h"
 
 static struct mmci_platform_data mmc0_plat_data = {
diff --git a/arch/arm/mach-u300/u300-gpio.h b/arch/arm/mach-u300/u300-gpio.h
new file mode 100644
index 0000000..847dc25
--- /dev/null
+++ b/arch/arm/mach-u300/u300-gpio.h
@@ -0,0 +1,114 @@
+/*
+ * Individual pin assignments for the B26/S26. Notice that the
+ * actual usage of these pins depends on the PAD MUX settings, that
+ * is why the same number can potentially appear several times.
+ * In the reference design each pin is only used for one purpose.
+ * These were determined by inspecting the B26/S26 schematic:
+ * 2/1911-ROA 128 1603
+ */
+#ifdef CONFIG_MACH_U300_BS2X
+#define U300_GPIO_PIN_UART_RX		0
+#define U300_GPIO_PIN_UART_TX		1
+#define U300_GPIO_PIN_GPIO02		2  /* Unrouted */
+#define U300_GPIO_PIN_GPIO03		3  /* Unrouted */
+#define U300_GPIO_PIN_CAM_SLEEP		4
+#define U300_GPIO_PIN_CAM_REG_EN	5
+#define U300_GPIO_PIN_GPIO06		6  /* Unrouted */
+#define U300_GPIO_PIN_GPIO07		7  /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO08		8  /* Service point SP2321 */
+#define U300_GPIO_PIN_GPIO09		9  /* Service point SP2322 */
+#define U300_GPIO_PIN_PHFSENSE		10 /* Headphone jack sensing */
+#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
+#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
+#define U300_GPIO_PIN_FLIPSENSE		13 /* Mechanical flip sensing */
+#define U300_GPIO_PIN_GPIO14		14 /* DSP JTAG Port RTCK */
+#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO16		16 /* Unrouted */
+#define U300_GPIO_PIN_GPIO17		17 /* Unrouted */
+#define U300_GPIO_PIN_GPIO18		18 /* Unrouted */
+#define U300_GPIO_PIN_GPIO19		19 /* Unrouted */
+#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
+#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
+#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
+#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
+#endif
+
+/*
+ * Individual pin assignments for the B330/S330 and B365/S365.
+ * Notice that the actual usage of these pins depends on the
+ * PAD MUX settings, that is why the same number can potentially
+ * appear several times. In the reference design each pin is only
+ * used for one purpose. These were determined by inspecting the
+ * S365 schematic.
+ */
+#if defined(CONFIG_MACH_U300_BS330) || defined(CONFIG_MACH_U300_BS365) || \
+    defined(CONFIG_MACH_U300_BS335)
+#define U300_GPIO_PIN_UART_RX		0
+#define U300_GPIO_PIN_UART_TX		1
+#define U300_GPIO_PIN_UART_CTS		2
+#define U300_GPIO_PIN_UART_RTS		3
+#define U300_GPIO_PIN_CAM_MAIN_STANDBY	4 /* Camera MAIN standby */
+#define U300_GPIO_PIN_GPIO05		5 /* Unrouted */
+#define U300_GPIO_PIN_MS_CD		6 /* Memory Stick Card insertion */
+#define U300_GPIO_PIN_GPIO07		7 /* Test point TP2430 */
+
+#define U300_GPIO_PIN_GPIO08		8 /* Test point TP2437 */
+#define U300_GPIO_PIN_GPIO09		9 /* Test point TP2431 */
+#define U300_GPIO_PIN_GPIO10		10 /* Test point TP2432 */
+#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
+#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
+#define U300_GPIO_PIN_CAM_SUB_STANDBY	13 /* Camera SUB standby */
+#define U300_GPIO_PIN_GPIO14		14 /* Test point TP2436 */
+#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO16		16 /* Test point TP2438 */
+#define U300_GPIO_PIN_PHFSENSE		17 /* Headphone jack sensing */
+#define U300_GPIO_PIN_GPIO18		18 /* Test point TP2439 */
+#define U300_GPIO_PIN_GPIO19		19 /* Routed somewhere */
+#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
+#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
+#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
+#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO24		24 /* Unrouted */
+#define U300_GPIO_PIN_GPIO25		25 /* Unrouted */
+#define U300_GPIO_PIN_GPIO26		26 /* Unrouted */
+#define U300_GPIO_PIN_GPIO27		27 /* Unrouted */
+#define U300_GPIO_PIN_GPIO28		28 /* Unrouted */
+#define U300_GPIO_PIN_GPIO29		29 /* Unrouted */
+#define U300_GPIO_PIN_GPIO30		30 /* Unrouted */
+#define U300_GPIO_PIN_GPIO31		31 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO32		32 /* Unrouted */
+#define U300_GPIO_PIN_GPIO33		33 /* Unrouted */
+#define U300_GPIO_PIN_GPIO34		34 /* Unrouted */
+#define U300_GPIO_PIN_GPIO35		35 /* Unrouted */
+#define U300_GPIO_PIN_GPIO36		36 /* Unrouted */
+#define U300_GPIO_PIN_GPIO37		37 /* Unrouted */
+#define U300_GPIO_PIN_GPIO38		38 /* Unrouted */
+#define U300_GPIO_PIN_GPIO39		39 /* Unrouted */
+
+#ifdef CONFIG_MACH_U300_BS335
+
+#define U300_GPIO_PIN_GPIO40		40 /* Unrouted */
+#define U300_GPIO_PIN_GPIO41		41 /* Unrouted */
+#define U300_GPIO_PIN_GPIO42		42 /* Unrouted */
+#define U300_GPIO_PIN_GPIO43		43 /* Unrouted */
+#define U300_GPIO_PIN_GPIO44		44 /* Unrouted */
+#define U300_GPIO_PIN_GPIO45		45 /* Unrouted */
+#define U300_GPIO_PIN_GPIO46		46 /* Unrouted */
+#define U300_GPIO_PIN_GPIO47		47 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO48		48 /* Unrouted */
+#define U300_GPIO_PIN_GPIO49		49 /* Unrouted */
+#define U300_GPIO_PIN_GPIO50		50 /* Unrouted */
+#define U300_GPIO_PIN_GPIO51		51 /* Unrouted */
+#define U300_GPIO_PIN_GPIO52		52 /* Unrouted */
+#define U300_GPIO_PIN_GPIO53		53 /* Unrouted */
+#define U300_GPIO_PIN_GPIO54		54 /* Unrouted */
+#define U300_GPIO_PIN_GPIO55		55 /* Unrouted */
+#endif
+
+#endif
-- 
1.7.3.2

