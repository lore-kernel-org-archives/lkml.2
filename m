Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab0HEHbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:31:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2277 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab0HEH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:56 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] drivers/input/touchscreen: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:49 -0700
Message-Id: <05b77f1d6b2df969d56c9d57801cfdf4c5ce298f.1280992119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/touchscreen/gunze.c          |    5 ++++-
 drivers/input/touchscreen/h3600_ts_input.c |    8 +++++---
 drivers/input/touchscreen/hp680_ts_input.c |    3 +--
 drivers/input/touchscreen/htcpen.c         |   15 +++++++--------
 drivers/input/touchscreen/inexio.c         |    5 ++++-
 drivers/input/touchscreen/jornada720_ts.c  |    4 +++-
 drivers/input/touchscreen/mk712.c          |   10 ++++++----
 drivers/input/touchscreen/mtouch.c         |    7 +++++--
 drivers/input/touchscreen/ucb1400_ts.c     |   12 +++++++-----
 drivers/input/touchscreen/usbtouchscreen.c |    6 ++++--
 10 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/input/touchscreen/gunze.c b/drivers/input/touchscreen/gunze.c
index a54f90e..064765c4 100644
--- a/drivers/input/touchscreen/gunze.c
+++ b/drivers/input/touchscreen/gunze.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -64,7 +66,8 @@ static void gunze_process_packet(struct gunze* gunze)
 
 	if (gunze->idx != GUNZE_MAX_LENGTH || gunze->data[5] != ',' ||
 		(gunze->data[0] != 'T' && gunze->data[0] != 'R')) {
-		printk(KERN_WARNING "gunze.c: bad packet: >%.*s<\n", GUNZE_MAX_LENGTH, gunze->data);
+		pr_warning("bad packet: >%.*s<\n",
+			   GUNZE_MAX_LENGTH, gunze->data);
 		return;
 	}
 
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index b4d7f63..58a97f7 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -29,6 +29,8 @@
  * e-mail - mail your message to <jsimmons@transvirtual.com>.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -331,7 +333,7 @@ static irqreturn_t h3600ts_interrupt(struct serio *serio, unsigned char data,
 				h3600ts_process_packet(ts);
 			break;
 		default:
-			printk("Error3\n");
+			pr_info("Error3\n");
 			break;
 	}
 
@@ -397,14 +399,14 @@ static int h3600ts_connect(struct serio *serio, struct serio_driver *drv)
 
 	if (request_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, action_button_handler,
 			IRQF_SHARED | IRQF_DISABLED, "h3600_action", &ts->dev)) {
-		printk(KERN_ERR "h3600ts.c: Could not allocate Action Button IRQ!\n");
+		pr_err("Could not allocate Action Button IRQ!\n");
 		err = -EBUSY;
 		goto fail2;
 	}
 
 	if (request_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, npower_button_handler,
 			IRQF_SHARED | IRQF_DISABLED, "h3600_suspend", &ts->dev)) {
-		printk(KERN_ERR "h3600ts.c: Could not allocate Power Button IRQ!\n");
+		pr_err("Could not allocate Power Button IRQ!\n");
 		err = -EBUSY;
 		goto fail3;
 	}
diff --git a/drivers/input/touchscreen/hp680_ts_input.c b/drivers/input/touchscreen/hp680_ts_input.c
index a89700e..b6a514b 100644
--- a/drivers/input/touchscreen/hp680_ts_input.c
+++ b/drivers/input/touchscreen/hp680_ts_input.c
@@ -94,8 +94,7 @@ static int __init hp680_ts_init(void)
 
 	if (request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
 			IRQF_DISABLED, MODNAME, 0) < 0) {
-		printk(KERN_ERR "hp680_touchscreen.c: Can't allocate irq %d\n",
-		       HP680_TS_IRQ);
+		pr_err("Can't allocate irq %d\n", HP680_TS_IRQ);
 		err = -EBUSY;
 		goto fail1;
 	}
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..4d18c0f 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -8,6 +8,8 @@
  * by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -114,26 +116,23 @@ static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
 	int err = -EBUSY;
 
 	if (!request_region(HTCPEN_PORT_IRQ_CLEAR, 1, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_IRQ_CLEAR);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_IRQ_CLEAR);
 		goto request_region1_failed;
 	}
 
 	if (!request_region(HTCPEN_PORT_INIT, 1, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_INIT);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_INIT);
 		goto request_region2_failed;
 	}
 
 	if (!request_region(HTCPEN_PORT_INDEX, 2, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_INDEX);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_INDEX);
 		goto request_region3_failed;
 	}
 
 	htcpen_dev = input_allocate_device();
 	if (!htcpen_dev) {
-		printk(KERN_ERR "htcpen: can't allocate device\n");
+		pr_err("can't allocate device\n");
 		err = -ENOMEM;
 		goto input_alloc_failed;
 	}
@@ -152,7 +151,7 @@ static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
 	err = request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen",
 			htcpen_dev);
 	if (err) {
-		printk(KERN_ERR "htcpen: irq busy\n");
+		pr_err("irq busy\n");
 		goto request_irq_failed;
 	}
 
diff --git a/drivers/input/touchscreen/inexio.c b/drivers/input/touchscreen/inexio.c
index 192ade0..441ff4c 100644
--- a/drivers/input/touchscreen/inexio.c
+++ b/drivers/input/touchscreen/inexio.c
@@ -17,6 +17,8 @@
  *   Copied mtouch.c and edited for iNexio protocol
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -87,7 +89,8 @@ static irqreturn_t inexio_interrupt(struct serio *serio,
 	if (INEXIO_RESPONSE_BEGIN_BYTE&pinexio->data[0])
 		inexio_process_data(pinexio);
 	else
-		printk(KERN_DEBUG "inexio.c: unknown/unsynchronized data from device, byte %x\n",pinexio->data[0]);
+		printk(KERN_DEBUG pr_fmt("unknown/unsynchronized data from device, byte %x\n"),
+		       pinexio->data[0]);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 4b0a061..e0abada 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -13,6 +13,8 @@
  * HP Jornada 710/720/729 Touchscreen Driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -130,7 +132,7 @@ static int __devinit jornada720_ts_probe(struct platform_device *pdev)
 			IRQF_DISABLED | IRQF_TRIGGER_RISING,
 			"HP7XX Touchscreen driver", pdev);
 	if (error) {
-		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
+		pr_info("Unable to acquire irq!\n");
 		goto fail1;
 	}
 
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index efd3aeb..7896dc1 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -35,6 +35,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -154,7 +156,7 @@ static int __init mk712_init(void)
 	int err;
 
 	if (!request_region(mk712_io, 8, "mk712")) {
-		printk(KERN_WARNING "mk712: unable to get IO region\n");
+		pr_warning("unable to get IO region\n");
 		return -ENODEV;
 	}
 
@@ -163,14 +165,14 @@ static int __init mk712_init(void)
 	if ((inw(mk712_io + MK712_X) & 0xf000) ||	/* Sanity check */
 	    (inw(mk712_io + MK712_Y) & 0xf000) ||
 	    (inw(mk712_io + MK712_STATUS) & 0xf333)) {
-		printk(KERN_WARNING "mk712: device not present\n");
+		pr_warning("device not present\n");
 		err = -ENODEV;
 		goto fail1;
 	}
 
 	mk712_dev = input_allocate_device();
 	if (!mk712_dev) {
-		printk(KERN_ERR "mk712: not enough memory\n");
+		pr_err("not enough memory\n");
 		err = -ENOMEM;
 		goto fail1;
 	}
@@ -191,7 +193,7 @@ static int __init mk712_init(void)
 	input_set_abs_params(mk712_dev, ABS_Y, 0, 0xfff, 88, 0);
 
 	if (request_irq(mk712_irq, mk712_interrupt, 0, "mk712", mk712_dev)) {
-		printk(KERN_WARNING "mk712: unable to get IRQ\n");
+		pr_warning("unable to get IRQ\n");
 		err = -EBUSY;
 		goto fail1;
 	}
diff --git a/drivers/input/touchscreen/mtouch.c b/drivers/input/touchscreen/mtouch.c
index 9077228..7e58b66 100644
--- a/drivers/input/touchscreen/mtouch.c
+++ b/drivers/input/touchscreen/mtouch.c
@@ -15,6 +15,8 @@
  *   Copied elo.c and edited for MicroTouch protocol
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -83,7 +85,7 @@ static void mtouch_process_response(struct mtouch *mtouch)
 		/* FIXME - process response */
 		mtouch->idx = 0;
 	} else if (MTOUCH_MAX_LENGTH == mtouch->idx) {
-		printk(KERN_ERR "mtouch.c: too many response bytes\n");
+		pr_err("too many response bytes\n");
 		mtouch->idx = 0;
 	}
 }
@@ -100,7 +102,8 @@ static irqreturn_t mtouch_interrupt(struct serio *serio,
 	else if (MTOUCH_RESPONSE_BEGIN_BYTE == mtouch->data[0])
 		mtouch_process_response(mtouch);
 	else
-		printk(KERN_DEBUG "mtouch.c: unknown/unsynchronized data from device, byte %x\n",mtouch->data[0]);
+		printk(KERN_DEBUG pr_fmt("unknown/unsynchronized data from device, byte %x\n"),
+		       mtouch->data[0]);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 028a536..7c0c5b2 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -18,6 +18,8 @@
  * been made separate from ucb1x00-core/ucb1x00-ts on Russell's request.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/completion.h>
@@ -321,7 +323,7 @@ static int ucb1400_ts_detect_irq(struct ucb1400_ts *ucb)
 						UCB_ADC_DAT_VALID)) {
 		cpu_relax();
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "ucb1400: timed out in IRQ probe\n");
+			pr_err("timed out in IRQ probe\n");
 			probe_irq_off(mask);
 			return -ENODEV;
 		}
@@ -358,7 +360,7 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	if (ucb->irq < 0) {
 		error = ucb1400_ts_detect_irq(ucb);
 		if (error) {
-			printk(KERN_ERR "UCB1400: IRQ probe failed\n");
+			pr_err("IRQ probe failed\n");
 			goto err_free_devs;
 		}
 	}
@@ -368,11 +370,11 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	error = request_irq(ucb->irq, ucb1400_hard_irq, IRQF_TRIGGER_RISING,
 				"UCB1400", ucb);
 	if (error) {
-		printk(KERN_ERR "ucb1400: unable to grab irq%d: %d\n",
+		pr_err("unable to grab irq%d: %d\n",
 				ucb->irq, error);
 		goto err_free_devs;
 	}
-	printk(KERN_DEBUG "UCB1400: found IRQ %d\n", ucb->irq);
+	printk(KERN_DEBUG pr_fmt("found IRQ %d\n"), ucb->irq);
 
 	input_set_drvdata(ucb->ts_idev, ucb);
 
@@ -398,7 +400,7 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	x_res = ucb1400_ts_read_xres(ucb);
 	y_res = ucb1400_ts_read_yres(ucb);
 	ucb1400_adc_disable(ucb->ac97);
-	printk(KERN_DEBUG "UCB1400: x/y = %d/%d\n", x_res, y_res);
+	printk(KERN_DEBUG pr_fmt("x/y = %d/%d\n"), x_res, y_res);
 
 	input_set_abs_params(ucb->ts_idev, ABS_X, 0, x_res, 0, 0);
 	input_set_abs_params(ucb->ts_idev, ABS_Y, 0, y_res, 0, 0);
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index f45f80f..2df60cc 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -43,6 +43,8 @@
  *
  *****************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 //#define DEBUG
 
 #include <linux/kernel.h>
@@ -832,8 +834,8 @@ static int nexio_init(struct usbtouch_usb *usbtouch)
 		}
 	}
 
-	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
-	       device_name, firmware_ver);
+	pr_info("Nexio device: %s, firmware version: %s\n",
+		device_name, firmware_ver);
 
 	kfree(firmware_ver);
 	kfree(device_name);
-- 
1.7.2.19.g9a302

