Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1IGQyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:54:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61122 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1IGQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:54:34 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Yong Zhang <yong.zhang0@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>,
        Julia Lawall <julia@diku.dk>,
        Sylvestre Ledru <sylvestre.ledru@scilab.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Paul Mundt <lethal@linux-sh.org>, Tejun Heo <tj@kernel.org>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 38/62] Input: irq: Remove IRQF_DISABLED
Date: Wed,  7 Sep 2011 16:10:35 +0800
Message-Id: <1315383059-3673-39-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and can be removed now.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/input/keyboard/adp5588-keys.c      |    2 +-
 drivers/input/keyboard/davinci_keyscan.c   |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c     |    2 +-
 drivers/input/keyboard/imx_keypad.c        |    2 +-
 drivers/input/keyboard/jornada720_kbd.c    |    2 +-
 drivers/input/keyboard/matrix_keypad.c     |    1 -
 drivers/input/keyboard/pxa27x_keypad.c     |    2 +-
 drivers/input/keyboard/pxa930_rotary.c     |    2 +-
 drivers/input/keyboard/w90p910_keypad.c    |    2 +-
 drivers/input/misc/ixp4xx-beeper.c         |    2 +-
 drivers/input/mouse/pxa930_trkball.c       |    2 +-
 drivers/input/mouse/synaptics_i2c.c        |    2 +-
 drivers/input/touchscreen/atmel_tsadcc.c   |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c |    4 ++--
 drivers/input/touchscreen/hp680_ts_input.c |    2 +-
 drivers/input/touchscreen/jornada720_ts.c  |    2 +-
 drivers/input/touchscreen/lpc32xx_ts.c     |    2 +-
 drivers/input/touchscreen/s3c2410_ts.c     |    2 +-
 drivers/input/touchscreen/w90p910_ts.c     |    2 +-
 19 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 7b404e5..b570ed3 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -550,7 +550,7 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 	}
 
 	error = request_irq(client->irq, adp5588_irq,
-			    IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			    IRQF_TRIGGER_FALLING,
 			    client->dev.driver->name, kpad);
 	if (error) {
 		dev_err(&client->dev, "irq %d busy?\n", client->irq);
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index cd89d17..9d82b3a 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -271,7 +271,7 @@ static int __init davinci_ks_probe(struct platform_device *pdev)
 	}
 
 	error = request_irq(davinci_ks->irq, davinci_ks_interrupt,
-			  IRQF_DISABLED, pdev->name, davinci_ks);
+			  0, pdev->name, davinci_ks);
 	if (error < 0) {
 		dev_err(dev, "unable to register davinci key scan interrupt\n");
 		goto fail5;
diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index aa17e02..4662c5d 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -323,7 +323,7 @@ static int __devinit ep93xx_keypad_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, keypad);
 
 	err = request_irq(keypad->irq, ep93xx_keypad_irq_handler,
-			  IRQF_DISABLED, pdev->name, keypad);
+			  0, pdev->name, keypad);
 	if (err)
 		goto failed_free_dev;
 
diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index d92c15c..4b093fa 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -510,7 +510,7 @@ static int __devinit imx_keypad_probe(struct platform_device *pdev)
 	/* Ensure that the keypad will stay dormant until opened */
 	imx_keypad_inhibit(keypad);
 
-	error = request_irq(irq, imx_keypad_irq_handler, IRQF_DISABLED,
+	error = request_irq(irq, imx_keypad_irq_handler, 0,
 			    pdev->name, keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 2cd3e1d..0aa6740 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -129,7 +129,7 @@ static int __devinit jornada720_kbd_probe(struct platform_device *pdev)
 
 	err = request_irq(IRQ_GPIO0,
 			  jornada720_kbd_interrupt,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			  IRQF_TRIGGER_FALLING,
 			  "jornadakbd", pdev);
 	if (err) {
 		printk(KERN_INFO "jornadakbd720_kbd: Unable to grab IRQ\n");
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index b02e426..e2ae657 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -343,7 +343,6 @@ static int __devinit init_matrix_gpio(struct platform_device *pdev,
 		for (i = 0; i < pdata->num_row_gpios; i++) {
 			err = request_irq(gpio_to_irq(pdata->row_gpios[i]),
 					matrix_keypad_interrupt,
-					IRQF_DISABLED |
 					IRQF_TRIGGER_RISING |
 					IRQF_TRIGGER_FALLING,
 					"matrix-keypad", keypad);
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 4b0ec35..eca6ae6 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -535,7 +535,7 @@ static int __devinit pxa27x_keypad_probe(struct platform_device *pdev)
 		input_dev->evbit[0] |= BIT_MASK(EV_REL);
 	}
 
-	error = request_irq(irq, pxa27x_keypad_irq_handler, IRQF_DISABLED,
+	error = request_irq(irq, pxa27x_keypad_irq_handler, 0,
 			    pdev->name, keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
diff --git a/drivers/input/keyboard/pxa930_rotary.c b/drivers/input/keyboard/pxa930_rotary.c
index b7123a4..35451bf 100644
--- a/drivers/input/keyboard/pxa930_rotary.c
+++ b/drivers/input/keyboard/pxa930_rotary.c
@@ -148,7 +148,7 @@ static int __devinit pxa930_rotary_probe(struct platform_device *pdev)
 	r->input_dev = input_dev;
 	input_set_drvdata(input_dev, r);
 
-	err = request_irq(irq, rotary_irq, IRQF_DISABLED,
+	err = request_irq(irq, rotary_irq, 0,
 			"enhanced rotary", r);
 	if (err) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index ee2bf6b..318586d 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -203,7 +203,7 @@ static int __devinit w90p910_keypad_probe(struct platform_device *pdev)
 				   input_dev->keycode, input_dev->keybit);
 
 	error = request_irq(keypad->irq, w90p910_keypad_irq_handler,
-			    IRQF_DISABLED, pdev->name, keypad);
+			    0, pdev->name, keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
 		goto failed_put_clk;
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 1f38302..302ab46 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -111,7 +111,7 @@ static int __devinit ixp4xx_spkr_probe(struct platform_device *dev)
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
-			  IRQF_DISABLED | IRQF_NO_SUSPEND, "ixp4xx-beeper",
+			  IRQF_NO_SUSPEND, "ixp4xx-beeper",
 			  (void *) dev->id);
 	if (err)
 		goto err_free_device;
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index 6c5d84f..ee3b0ca 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -183,7 +183,7 @@ static int __devinit pxa930_trkball_probe(struct platform_device *pdev)
 	/* held the module in reset, will be enabled in open() */
 	pxa930_trkball_disable(trkball);
 
-	error = request_irq(irq, pxa930_trkball_interrupt, IRQF_DISABLED,
+	error = request_irq(irq, pxa930_trkball_interrupt, 0,
 			    pdev->name, trkball);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq: %d\n", error);
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index cba3c84..e28e9ce 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -570,7 +570,7 @@ static int __devinit synaptics_i2c_probe(struct i2c_client *client,
 			 "Requesting IRQ: %d\n", touch->client->irq);
 
 		ret = request_irq(touch->client->irq, synaptics_i2c_irq,
-				  IRQF_DISABLED|IRQ_TYPE_EDGE_FALLING,
+				  IRQ_TYPE_EDGE_FALLING,
 				  DRIVER_NAME, touch);
 		if (ret) {
 			dev_warn(&touch->client->dev,
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index 432c69b..122a878 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -229,7 +229,7 @@ static int __devinit atmel_tsadcc_probe(struct platform_device *pdev)
 		goto err_release_mem;
 	}
 
-	err = request_irq(ts_dev->irq, atmel_tsadcc_interrupt, IRQF_DISABLED,
+	err = request_irq(ts_dev->irq, atmel_tsadcc_interrupt, 0,
 			pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index 211811a..6107e56 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -396,14 +396,14 @@ static int h3600ts_connect(struct serio *serio, struct serio_driver *drv)
 	set_GPIO_IRQ_edge(GPIO_BITSY_NPOWER_BUTTON, GPIO_RISING_EDGE);
 
 	if (request_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, action_button_handler,
-			IRQF_SHARED | IRQF_DISABLED, "h3600_action", ts->dev)) {
+			IRQF_SHARED, "h3600_action", ts->dev)) {
 		printk(KERN_ERR "h3600ts.c: Could not allocate Action Button IRQ!\n");
 		err = -EBUSY;
 		goto fail1;
 	}
 
 	if (request_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, npower_button_handler,
-			IRQF_SHARED | IRQF_DISABLED, "h3600_suspend", ts->dev)) {
+			IRQF_SHARED, "h3600_suspend", ts->dev)) {
 		printk(KERN_ERR "h3600ts.c: Could not allocate Power Button IRQ!\n");
 		err = -EBUSY;
 		goto fail2;
diff --git a/drivers/input/touchscreen/hp680_ts_input.c b/drivers/input/touchscreen/hp680_ts_input.c
index dd4e8f0..639a604 100644
--- a/drivers/input/touchscreen/hp680_ts_input.c
+++ b/drivers/input/touchscreen/hp680_ts_input.c
@@ -93,7 +93,7 @@ static int __init hp680_ts_init(void)
 	hp680_ts_dev->phys = "hp680_ts/input0";
 
 	if (request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
-			IRQF_DISABLED, MODNAME, 0) < 0) {
+			0, MODNAME, 0) < 0) {
 		printk(KERN_ERR "hp680_touchscreen.c: Can't allocate irq %d\n",
 		       HP680_TS_IRQ);
 		err = -EBUSY;
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 4b0a061..50076c2 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -127,7 +127,7 @@ static int __devinit jornada720_ts_probe(struct platform_device *pdev)
 
 	error = request_irq(IRQ_GPIO9,
 			jornada720_ts_interrupt,
-			IRQF_DISABLED | IRQF_TRIGGER_RISING,
+			IRQF_TRIGGER_RISING,
 			"HP7XX Touchscreen driver", pdev);
 	if (error) {
 		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
diff --git a/drivers/input/touchscreen/lpc32xx_ts.c b/drivers/input/touchscreen/lpc32xx_ts.c
index dcf803f..0a484ed 100644
--- a/drivers/input/touchscreen/lpc32xx_ts.c
+++ b/drivers/input/touchscreen/lpc32xx_ts.c
@@ -276,7 +276,7 @@ static int __devinit lpc32xx_ts_probe(struct platform_device *pdev)
 	input_set_drvdata(input, tsc);
 
 	error = request_irq(tsc->irq, lpc32xx_ts_interrupt,
-			    IRQF_DISABLED, pdev->name, tsc);
+			    0, pdev->name, tsc);
 	if (error) {
 		dev_err(&pdev->dev, "failed requesting interrupt\n");
 		goto err_put_clock;
diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index 8feb7f3..64ce697 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -328,7 +328,7 @@ static int __devinit s3c2410ts_probe(struct platform_device *pdev)
 	ts.shift = info->oversampling_shift;
 	ts.features = platform_get_device_id(pdev)->driver_data;
 
-	ret = request_irq(ts.irq_tc, stylus_irq, IRQF_DISABLED,
+	ret = request_irq(ts.irq_tc, stylus_irq, 0,
 			  "s3c2410_ts_pen", ts.input);
 	if (ret) {
 		dev_err(dev, "cannot get TC interrupt\n");
diff --git a/drivers/input/touchscreen/w90p910_ts.c b/drivers/input/touchscreen/w90p910_ts.c
index 7a45d68..217aa51 100644
--- a/drivers/input/touchscreen/w90p910_ts.c
+++ b/drivers/input/touchscreen/w90p910_ts.c
@@ -279,7 +279,7 @@ static int __devinit w90x900ts_probe(struct platform_device *pdev)
 
 	w90p910_ts->irq_num = platform_get_irq(pdev, 0);
 	if (request_irq(w90p910_ts->irq_num, w90p910_ts_interrupt,
-			IRQF_DISABLED, "w90p910ts", w90p910_ts)) {
+			0, "w90p910ts", w90p910_ts)) {
 		err = -EBUSY;
 		goto fail4;
 	}
-- 
1.7.4.1

