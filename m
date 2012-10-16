Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2JPHnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:43:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40391 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2JPHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:42:30 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 5/8] input: TSC: ti_tscadc: Rename the existing touchscreen driver
Date: Tue, 16 Oct 2012 12:55:42 +0530
Message-ID: <1350372345-27108-6-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350372345-27108-1-git-send-email-rachna@ti.com>
References: <1350372345-27108-1-git-send-email-rachna@ti.com>
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

Changes in v3:
	no changes.

Changes in v4:
	no changes.

 drivers/input/touchscreen/Kconfig                  |    4 +-
 drivers/input/touchscreen/Makefile                 |    2 +-
 .../touchscreen/{ti_tscadc.c => ti_am335x_tsc.c}   |   96 ++++++++++----------
 .../linux/input/{ti_tscadc.h => ti_am335x_tsc.h}   |    4 +-
 4 files changed, 53 insertions(+), 53 deletions(-)
 rename drivers/input/touchscreen/{ti_tscadc.c => ti_am335x_tsc.c} (83%)
 rename include/linux/input/{ti_tscadc.h => ti_am335x_tsc.h} (88%)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1ba232c..7bdb629 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -529,7 +529,7 @@ config TOUCHSCREEN_TOUCHWIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchwin.
 
-config TOUCHSCREEN_TI_TSCADC
+config TOUCHSCREEN_TI_AM335X_TSC
 	tristate "TI Touchscreen Interface"
 	depends on ARCH_OMAP2PLUS
 	help
@@ -539,7 +539,7 @@ config TOUCHSCREEN_TI_TSCADC
 	  If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called ti_tscadc.
+	  module will be called ti_am335x_tsc.
 
 config TOUCHSCREEN_ATMEL_TSADCC
 	tristate "Atmel Touchscreen Interface"
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 178eb12..7c4c78e 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_TOUCHSCREEN_PIXCIR)	+= pixcir_i2c_ts.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
 obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
-obj-$(CONFIG_TOUCHSCREEN_TI_TSCADC)	+= ti_tscadc.o
+obj-$(CONFIG_TOUCHSCREEN_TI_AM335X_TSC)	+= ti_am335x_tsc.o
 obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
diff --git a/drivers/input/touchscreen/ti_tscadc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
similarity index 83%
rename from drivers/input/touchscreen/ti_tscadc.c
rename to drivers/input/touchscreen/ti_am335x_tsc.c
index ec0a442..462950a 100644
--- a/drivers/input/touchscreen/ti_tscadc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -24,7 +24,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/input/ti_tscadc.h>
+#include <linux/input/ti_am335x_tsc.h>
 #include <linux/delay.h>
 
 #define REG_RAWIRQSTATUS	0x024
@@ -123,7 +123,7 @@
 #define ADC_CLK			3000000
 #define MAX_12BIT		((1 << 12) - 1)
 
-struct tscadc {
+struct titsc {
 	struct input_dev	*input;
 	struct clk		*tsc_ick;
 	void __iomem		*tsc_base;
@@ -134,18 +134,18 @@ struct tscadc {
 	int			steps_to_configure;
 };
 
-static unsigned int tscadc_readl(struct tscadc *ts, unsigned int reg)
+static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
 {
 	return readl(ts->tsc_base + reg);
 }
 
-static void tscadc_writel(struct tscadc *tsc, unsigned int reg,
+static void titsc_writel(struct titsc *tsc, unsigned int reg,
 					unsigned int val)
 {
 	writel(val, tsc->tsc_base + reg);
 }
 
-static void tscadc_step_config(struct tscadc *ts_dev)
+static void titsc_step_config(struct titsc *ts_dev)
 {
 	unsigned int	config;
 	int i, total_steps;
@@ -170,8 +170,8 @@ static void tscadc_step_config(struct tscadc *ts_dev)
 	}
 
 	for (i = 1; i <= ts_dev->steps_to_configure; i++) {
-		tscadc_writel(ts_dev, REG_STEPCONFIG(i), config);
-		tscadc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
+		titsc_writel(ts_dev, REG_STEPCONFIG(i), config);
+		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
 	}
 
 	config = 0;
@@ -192,8 +192,8 @@ static void tscadc_step_config(struct tscadc *ts_dev)
 	}
 
 	for (i = (ts_dev->steps_to_configure + 1); i <= total_steps; i++) {
-		tscadc_writel(ts_dev, REG_STEPCONFIG(i), config);
-		tscadc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
+		titsc_writel(ts_dev, REG_STEPCONFIG(i), config);
+		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
 	}
 
 	config = 0;
@@ -202,40 +202,40 @@ static void tscadc_step_config(struct tscadc *ts_dev)
 			STEPCHARGE_RFP_XPUL | STEPCHARGE_RFM_XNUR |
 			STEPCHARGE_INM_AN1 | STEPCHARGE_INP_AN1;
 
-	tscadc_writel(ts_dev, REG_CHARGECONFIG, config);
-	tscadc_writel(ts_dev, REG_CHARGEDELAY, CHARGEDLY_OPENDLY);
+	titsc_writel(ts_dev, REG_CHARGECONFIG, config);
+	titsc_writel(ts_dev, REG_CHARGEDELAY, CHARGEDLY_OPENDLY);
 
 	config = 0;
 	/* Configure to calculate pressure */
 	config = STEPCONFIG_MODE_HWSYNC |
 			STEPCONFIG_AVG_16 | STEPCONFIG_YPP |
 			STEPCONFIG_XNN | STEPCONFIG_INM_ADCREFM;
-	tscadc_writel(ts_dev, REG_STEPCONFIG(total_steps + 1), config);
-	tscadc_writel(ts_dev, REG_STEPDELAY(total_steps + 1),
+	titsc_writel(ts_dev, REG_STEPCONFIG(total_steps + 1), config);
+	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 1),
 			STEPCONFIG_OPENDLY);
 
 	config |= STEPCONFIG_INP_AN3 | STEPCONFIG_FIFO1;
-	tscadc_writel(ts_dev, REG_STEPCONFIG(total_steps + 2), config);
-	tscadc_writel(ts_dev, REG_STEPDELAY(total_steps + 2),
+	titsc_writel(ts_dev, REG_STEPCONFIG(total_steps + 2), config);
+	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 2),
 			STEPCONFIG_OPENDLY);
 
-	tscadc_writel(ts_dev, REG_SE, STPENB_STEPENB);
+	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB);
 }
 
-static void tscadc_idle_config(struct tscadc *ts_config)
+static void titsc_idle_config(struct titsc *ts_config)
 {
 	unsigned int idleconfig;
 
 	idleconfig = STEPCONFIG_YNN |
 			STEPCONFIG_INM_ADCREFM |
 			STEPCONFIG_YPN | STEPCONFIG_INP_ADCREFM;
-	tscadc_writel(ts_config, REG_IDLECONFIG, idleconfig);
+	titsc_writel(ts_config, REG_IDLECONFIG, idleconfig);
 }
 
-static void tscadc_read_coordinates(struct tscadc *ts_dev,
+static void titsc_read_coordinates(struct titsc *ts_dev,
 				    unsigned int *x, unsigned int *y)
 {
-	unsigned int fifocount = tscadc_readl(ts_dev, REG_FIFO0CNT);
+	unsigned int fifocount = titsc_readl(ts_dev, REG_FIFO0CNT);
 	unsigned int prev_val_x = ~0, prev_val_y = ~0;
 	unsigned int prev_diff_x = ~0, prev_diff_y = ~0;
 	unsigned int read, diff;
@@ -250,7 +250,7 @@ static void tscadc_read_coordinates(struct tscadc *ts_dev,
 	 * if true the value is reported to the sub system.
 	 */
 	for (i = 0; i < fifocount - 1; i++) {
-		read = tscadc_readl(ts_dev, REG_FIFO0) & 0xfff;
+		read = titsc_readl(ts_dev, REG_FIFO0) & 0xfff;
 		diff = abs(read - prev_val_x);
 		if (diff < prev_diff_x) {
 			prev_diff_x = diff;
@@ -258,7 +258,7 @@ static void tscadc_read_coordinates(struct tscadc *ts_dev,
 		}
 		prev_val_x = read;
 
-		read = tscadc_readl(ts_dev, REG_FIFO1) & 0xfff;
+		read = titsc_readl(ts_dev, REG_FIFO1) & 0xfff;
 		diff = abs(read - prev_val_y);
 		if (diff < prev_diff_y) {
 			prev_diff_y = diff;
@@ -268,21 +268,21 @@ static void tscadc_read_coordinates(struct tscadc *ts_dev,
 	}
 }
 
-static irqreturn_t tscadc_irq(int irq, void *dev)
+static irqreturn_t titsc_irq(int irq, void *dev)
 {
-	struct tscadc *ts_dev = dev;
+	struct titsc *ts_dev = dev;
 	struct input_dev *input_dev = ts_dev->input;
 	unsigned int status, irqclr = 0;
 	unsigned int x = 0, y = 0;
 	unsigned int z1, z2, z;
 	unsigned int fsm;
 
-	status = tscadc_readl(ts_dev, REG_IRQSTATUS);
+	status = titsc_readl(ts_dev, REG_IRQSTATUS);
 	if (status & IRQENB_FIFO0THRES) {
-		tscadc_read_coordinates(ts_dev, &x, &y);
+		titsc_read_coordinates(ts_dev, &x, &y);
 
-		z1 = tscadc_readl(ts_dev, REG_FIFO0) & 0xfff;
-		z2 = tscadc_readl(ts_dev, REG_FIFO1) & 0xfff;
+		z1 = titsc_readl(ts_dev, REG_FIFO0) & 0xfff;
+		z2 = titsc_readl(ts_dev, REG_FIFO1) & 0xfff;
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
 			/*
@@ -313,10 +313,10 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
 	 */
 	udelay(SEQ_SETTLE);
 
-	status = tscadc_readl(ts_dev, REG_RAWIRQSTATUS);
+	status = titsc_readl(ts_dev, REG_RAWIRQSTATUS);
 	if (status & IRQENB_PENUP) {
 		/* Pen up event */
-		fsm = tscadc_readl(ts_dev, REG_ADCFSM);
+		fsm = titsc_readl(ts_dev, REG_ADCFSM);
 		if (fsm == ADCFSM_STEPID) {
 			ts_dev->pen_down = false;
 			input_report_key(input_dev, BTN_TOUCH, 0);
@@ -328,9 +328,9 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
 		irqclr |= IRQENB_PENUP;
 	}
 
-	tscadc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+	titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
 
-	tscadc_writel(ts_dev, REG_SE, STPENB_STEPENB);
+	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB);
 	return IRQ_HANDLED;
 }
 
@@ -338,11 +338,11 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
  * The functions for inserting/removing driver as a module.
  */
 
-static int __devinit tscadc_probe(struct platform_device *pdev)
+static int __devinit titsc_probe(struct platform_device *pdev)
 {
 	const struct tsc_data *pdata = pdev->dev.platform_data;
 	struct resource *res;
-	struct tscadc *ts_dev;
+	struct titsc *ts_dev;
 	struct input_dev *input_dev;
 	struct clk *clk;
 	int err;
@@ -366,7 +366,7 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate memory for device */
-	ts_dev = kzalloc(sizeof(struct tscadc), GFP_KERNEL);
+	ts_dev = kzalloc(sizeof(struct titsc), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!ts_dev || !input_dev) {
 		dev_err(&pdev->dev, "failed to allocate memory.\n");
@@ -394,7 +394,7 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 		goto err_release_mem_region;
 	}
 
-	err = request_irq(ts_dev->irq, tscadc_irq,
+	err = request_irq(ts_dev->irq, titsc_irq,
 			  0, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
@@ -423,10 +423,10 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 		goto err_disable_clk;
 	}
 	/* CLKDIV needs to be configured to the value minus 1 */
-	tscadc_writel(ts_dev, REG_CLKDIV, clk_value - 1);
+	titsc_writel(ts_dev, REG_CLKDIV, clk_value - 1);
 
 	 /* Enable wake-up of the SoC using touchscreen */
-	tscadc_writel(ts_dev, REG_IRQWAKEUP, IRQWKUP_ENB);
+	titsc_writel(ts_dev, REG_IRQWAKEUP, IRQWKUP_ENB);
 
 	ctrl = CNTRLREG_STEPCONFIGWRT |
 			CNTRLREG_TSCENB |
@@ -442,15 +442,15 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 		ctrl |= CNTRLREG_8WIRE;
 		break;
 	}
-	tscadc_writel(ts_dev, REG_CTRL, ctrl);
+	titsc_writel(ts_dev, REG_CTRL, ctrl);
 
-	tscadc_idle_config(ts_dev);
-	tscadc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
-	tscadc_step_config(ts_dev);
-	tscadc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
+	titsc_idle_config(ts_dev);
+	titsc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
+	titsc_step_config(ts_dev);
+	titsc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
 
 	ctrl |= CNTRLREG_TSCSSENB;
-	tscadc_writel(ts_dev, REG_CTRL, ctrl);
+	titsc_writel(ts_dev, REG_CTRL, ctrl);
 
 	input_dev->name = "ti-tsc-adc";
 	input_dev->dev.parent = &pdev->dev;
@@ -485,9 +485,9 @@ err_free_mem:
 	return err;
 }
 
-static int __devexit tscadc_remove(struct platform_device *pdev)
+static int __devexit titsc_remove(struct platform_device *pdev)
 {
-	struct tscadc *ts_dev = platform_get_drvdata(pdev);
+	struct titsc *ts_dev = platform_get_drvdata(pdev);
 	struct resource *res;
 
 	free_irq(ts_dev->irq, ts_dev);
@@ -508,8 +508,8 @@ static int __devexit tscadc_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver ti_tsc_driver = {
-	.probe	= tscadc_probe,
-	.remove	= __devexit_p(tscadc_remove),
+	.probe	= titsc_probe,
+	.remove	= __devexit_p(titsc_remove),
 	.driver	= {
 		.name   = "tsc",
 		.owner	= THIS_MODULE,
diff --git a/include/linux/input/ti_tscadc.h b/include/linux/input/ti_am335x_tsc.h
similarity index 88%
rename from include/linux/input/ti_tscadc.h
rename to include/linux/input/ti_am335x_tsc.h
index ad442a3..49269a2 100644
--- a/include/linux/input/ti_tscadc.h
+++ b/include/linux/input/ti_am335x_tsc.h
@@ -1,5 +1,5 @@
-#ifndef __LINUX_TI_TSCADC_H
-#define __LINUX_TI_TSCADC_H
+#ifndef __LINUX_TI_AM335X_TSC_H
+#define __LINUX_TI_AM335X_TSC_H
 
 /**
  * struct tsc_data	Touchscreen wire configuration
-- 
1.7.0.4

