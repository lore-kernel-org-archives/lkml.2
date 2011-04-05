Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1DEOrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:47:53 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50679 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab1DEOru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:50 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: eric.piel@tremplin-utc.net, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        samu.p.onkalo@nokia.com, ilkka.koskinen@nokia.com
Subject: [RFC PATCHv2 2/5] hwmon: lis3: Change naming to consistent
Date: Tue,  5 Apr 2011 17:45:11 +0300
Message-Id: <1302014714-7334-3-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/misc/lis3lv02d/lis3lv02d.c |  118 ++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index b928bc1..cb32945 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -811,23 +811,23 @@ int lis3lv02d_remove_fs(struct lis3lv02d *lis3)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
-static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
+static void lis3lv02d_8b_configure(struct lis3lv02d *lis3,
 				struct lis3lv02d_platform_data *p)
 {
 	int err;
 	int ctrl2 = p->hipass_ctrl;
 
 	if (p->click_flags) {
-		dev->write(dev, CLICK_CFG, p->click_flags);
-		dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
-		dev->write(dev, CLICK_LATENCY, p->click_latency);
-		dev->write(dev, CLICK_WINDOW, p->click_window);
-		dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
-		dev->write(dev, CLICK_THSY_X,
+		lis3->write(lis3, CLICK_CFG, p->click_flags);
+		lis3->write(lis3, CLICK_TIMELIMIT, p->click_time_limit);
+		lis3->write(lis3, CLICK_LATENCY, p->click_latency);
+		lis3->write(lis3, CLICK_WINDOW, p->click_window);
+		lis3->write(lis3, CLICK_THSZ, p->click_thresh_z & 0xf);
+		lis3->write(lis3, CLICK_THSY_X,
 			(p->click_thresh_x & 0xf) |
 			(p->click_thresh_y << 4));
 
-		if (dev->idev) {
+		if (lis3->idev) {
 			struct input_dev *input_dev = lis3_dev.idev->input;
 			input_set_capability(input_dev, EV_KEY, BTN_X);
 			input_set_capability(input_dev, EV_KEY, BTN_Y);
@@ -836,22 +836,22 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 	}
 
 	if (p->wakeup_flags) {
-		dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
-		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
+		lis3->write(lis3, FF_WU_CFG_1, p->wakeup_flags);
+		lis3->write(lis3, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 		/* pdata value + 1 to keep this backward compatible*/
-		dev->write(dev, FF_WU_DURATION_1, p->duration1 + 1);
+		lis3->write(lis3, FF_WU_DURATION_1, p->duration1 + 1);
 		ctrl2 ^= HP_FF_WU1; /* Xor to keep compatible with old pdata*/
 	}
 
 	if (p->wakeup_flags2) {
-		dev->write(dev, FF_WU_CFG_2, p->wakeup_flags2);
-		dev->write(dev, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
+		lis3->write(lis3, FF_WU_CFG_2, p->wakeup_flags2);
+		lis3->write(lis3, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
 		/* pdata value + 1 to keep this backward compatible*/
-		dev->write(dev, FF_WU_DURATION_2, p->duration2 + 1);
+		lis3->write(lis3, FF_WU_DURATION_2, p->duration2 + 1);
 		ctrl2 ^= HP_FF_WU2; /* Xor to keep compatible with old pdata*/
 	}
 	/* Configure hipass filters */
-	dev->write(dev, CTRL_REG2, ctrl2);
+	lis3->write(lis3, CTRL_REG2, ctrl2);
 
 	if (p->irq2) {
 		err = request_threaded_irq(p->irq2,
@@ -869,68 +869,68 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independent of the bus system.
  */
-int lis3lv02d_init_device(struct lis3lv02d *dev)
+int lis3lv02d_init_device(struct lis3lv02d *lis3)
 {
 	int err;
 	irq_handler_t thread_fn;
 	int irq_flags = 0;
 
-	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
+	lis3->whoami = lis3lv02d_read_8(lis3, WHO_AM_I);
 
-	switch (dev->whoami) {
+	switch (lis3->whoami) {
 	case WAI_12B:
 		pr_info("12 bits sensor found\n");
-		dev->read_data = lis3lv02d_read_12;
-		dev->mdps_max_val = 2048;
-		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
-		dev->odrs = lis3_12_rates;
-		dev->odr_mask = CTRL1_DF0 | CTRL1_DF1;
-		dev->scale = LIS3_SENSITIVITY_12B;
-		dev->regs = lis3_wai12_regs;
-		dev->regs_size = ARRAY_SIZE(lis3_wai12_regs);
+		lis3->read_data = lis3lv02d_read_12;
+		lis3->mdps_max_val = 2048;
+		lis3->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
+		lis3->odrs = lis3_12_rates;
+		lis3->odr_mask = CTRL1_DF0 | CTRL1_DF1;
+		lis3->scale = LIS3_SENSITIVITY_12B;
+		lis3->regs = lis3_wai12_regs;
+		lis3->regs_size = ARRAY_SIZE(lis3_wai12_regs);
 		break;
 	case WAI_8B:
 		pr_info("8 bits sensor found\n");
-		dev->read_data = lis3lv02d_read_8;
-		dev->mdps_max_val = 128;
-		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
-		dev->odrs = lis3_8_rates;
-		dev->odr_mask = CTRL1_DR;
-		dev->scale = LIS3_SENSITIVITY_8B;
-		dev->regs = lis3_wai8_regs;
-		dev->regs_size = ARRAY_SIZE(lis3_wai8_regs);
+		lis3->read_data = lis3lv02d_read_8;
+		lis3->mdps_max_val = 128;
+		lis3->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		lis3->odrs = lis3_8_rates;
+		lis3->odr_mask = CTRL1_DR;
+		lis3->scale = LIS3_SENSITIVITY_8B;
+		lis3->regs = lis3_wai8_regs;
+		lis3->regs_size = ARRAY_SIZE(lis3_wai8_regs);
 		break;
 	case WAI_3DC:
 		pr_info("8 bits 3DC sensor found\n");
-		dev->read_data = lis3lv02d_read_8;
-		dev->mdps_max_val = 128;
-		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
-		dev->odrs = lis3_3dc_rates;
-		dev->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
-		dev->scale = LIS3_SENSITIVITY_8B;
+		lis3->read_data = lis3lv02d_read_8;
+		lis3->mdps_max_val = 128;
+		lis3->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		lis3->odrs = lis3_3dc_rates;
+		lis3->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
+		lis3->scale = LIS3_SENSITIVITY_8B;
 		break;
 	default:
-		pr_err("unknown sensor type 0x%X\n", dev->whoami);
+		pr_err("unknown sensor type 0x%X\n", lis3->whoami);
 		return -EINVAL;
 	}
 
-	dev->reg_cache = kzalloc(max(sizeof(lis3_wai8_regs),
+	lis3->reg_cache = kzalloc(max(sizeof(lis3_wai8_regs),
 				     sizeof(lis3_wai12_regs)), GFP_KERNEL);
 
-	if (dev->reg_cache == NULL) {
+	if (lis3->reg_cache == NULL) {
 		printk(KERN_ERR DRIVER_NAME "out of memory\n");
 		return -ENOMEM;
 	}
 
-	mutex_init(&dev->mutex);
-	atomic_set(&dev->wake_thread, 0);
+	mutex_init(&lis3->mutex);
+	atomic_set(&lis3->wake_thread, 0);
 
-	lis3lv02d_add_fs(dev);
-	lis3lv02d_poweron(dev);
+	lis3lv02d_add_fs(lis3);
+	lis3lv02d_poweron(lis3);
 
-	if (dev->pm_dev) {
-		pm_runtime_set_active(dev->pm_dev);
-		pm_runtime_enable(dev->pm_dev);
+	if (lis3->pm_dev) {
+		pm_runtime_set_active(lis3->pm_dev);
+		pm_runtime_enable(lis3->pm_dev);
 	}
 
 	if (lis3lv02d_joystick_enable())
@@ -938,24 +938,24 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	/* passing in platform specific data is purely optional and only
 	 * used by the SPI transport layer at the moment */
-	if (dev->pdata) {
-		struct lis3lv02d_platform_data *p = dev->pdata;
+	if (lis3->pdata) {
+		struct lis3lv02d_platform_data *p = lis3->pdata;
 
-		if (dev->whoami == WAI_8B)
-			lis3lv02d_8b_configure(dev, p);
+		if (lis3->whoami == WAI_8B)
+			lis3lv02d_8b_configure(lis3, p);
 
 		irq_flags = p->irq_flags1 & IRQF_TRIGGER_MASK;
 
-		dev->irq_cfg = p->irq_cfg;
+		lis3->irq_cfg = p->irq_cfg;
 		if (p->irq_cfg)
-			dev->write(dev, CTRL_REG3, p->irq_cfg);
+			lis3->write(lis3, CTRL_REG3, p->irq_cfg);
 
 		if (p->default_rate)
 			lis3lv02d_set_odr(p->default_rate);
 	}
 
 	/* bail if we did not get an IRQ from the bus layer */
-	if (!dev->irq) {
+	if (!lis3->irq) {
 		pr_debug("No IRQ. Disabling /dev/freefall\n");
 		goto out;
 	}
@@ -971,12 +971,12 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	 * io-apic is not configurable (and generates a warning) but I keep it
 	 * in case of support for other hardware.
 	 */
-	if (dev->pdata && dev->whoami == WAI_8B)
+	if (lis3->pdata && lis3->whoami == WAI_8B)
 		thread_fn = lis302dl_interrupt_thread1_8b;
 	else
 		thread_fn = NULL;
 
-	err = request_threaded_irq(dev->irq, lis302dl_interrupt,
+	err = request_threaded_irq(lis3->irq, lis302dl_interrupt,
 				thread_fn,
 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 				irq_flags,
-- 
1.7.0.4

