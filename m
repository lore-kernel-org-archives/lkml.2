Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2H3H4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 03:56:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51961 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2H3Hz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 03:55:59 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v2 1/5] input: TSC: ti_tscadc: Rename the existing touchscreen driver
Date: Thu, 30 Aug 2012 13:08:22 +0530
Message-ID: <1346312306-21082-2-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346312306-21082-1-git-send-email-rachna@ti.com>
References: <1346312306-21082-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make way for addition of MFD driver.
The existing touchsreen driver is a MFD client.
For better readability we rename the file to
indicate its functionality as only touchscreen.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
Changes in v2:
	Missed changing the name of touchscreen header file
	in the previous version.
	Adding the same.

 drivers/input/touchscreen/Kconfig                  |    4 ++--
 drivers/input/touchscreen/Makefile                 |    2 +-
 .../input/touchscreen/{ti_tscadc.c => ti_tsc.c}    |    2 +-
 include/linux/input/{ti_tscadc.h => ti_tsc.h}      |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)
 rename drivers/input/touchscreen/{ti_tscadc.c => ti_tsc.c} (99%)
 rename include/linux/input/{ti_tscadc.h => ti_tsc.h} (90%)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1ba232c..68ac802 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -529,7 +529,7 @@ config TOUCHSCREEN_TOUCHWIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchwin.
 
-config TOUCHSCREEN_TI_TSCADC
+config TOUCHSCREEN_TI_TSC
 	tristate "TI Touchscreen Interface"
 	depends on ARCH_OMAP2PLUS
 	help
@@ -539,7 +539,7 @@ config TOUCHSCREEN_TI_TSCADC
 	  If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called ti_tscadc.
+	  module will be called ti_tsc.
 
 config TOUCHSCREEN_ATMEL_TSADCC
 	tristate "Atmel Touchscreen Interface"
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 178eb12..d579427 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_TOUCHSCREEN_PIXCIR)	+= pixcir_i2c_ts.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
 obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
-obj-$(CONFIG_TOUCHSCREEN_TI_TSCADC)	+= ti_tscadc.o
+obj-$(CONFIG_TOUCHSCREEN_TI_TSC)	+= ti_tsc.o
 obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
diff --git a/drivers/input/touchscreen/ti_tscadc.c b/drivers/input/touchscreen/ti_tsc.c
similarity index 99%
rename from drivers/input/touchscreen/ti_tscadc.c
rename to drivers/input/touchscreen/ti_tsc.c
index ec0a442..8e94c00 100644
--- a/drivers/input/touchscreen/ti_tscadc.c
+++ b/drivers/input/touchscreen/ti_tsc.c
@@ -24,7 +24,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/input/ti_tscadc.h>
+#include <linux/input/ti_tsc.h>
 #include <linux/delay.h>
 
 #define REG_RAWIRQSTATUS	0x024
diff --git a/include/linux/input/ti_tscadc.h b/include/linux/input/ti_tsc.h
similarity index 90%
rename from include/linux/input/ti_tscadc.h
rename to include/linux/input/ti_tsc.h
index ad442a3..5da27d6 100644
--- a/include/linux/input/ti_tscadc.h
+++ b/include/linux/input/ti_tsc.h
@@ -1,5 +1,5 @@
-#ifndef __LINUX_TI_TSCADC_H
-#define __LINUX_TI_TSCADC_H
+#ifndef __LINUX_TI_TSC_H
+#define __LINUX_TI_TSC_H
 
 /**
  * struct tsc_data	Touchscreen wire configuration
-- 
1.7.1

