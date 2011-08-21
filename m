Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1HUXBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:01:50 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:42874 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932082Ab1HUW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:58:33 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] [media] ene_ir: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:46 -0700
Message-Id: <374eb80085c97785c9977f067db671b5f1499ff3.1313966089.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert ene_warn and ene_notice to pr_<level>.
Use pr_debug in __dbg macro and a little neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/rc/ene_ir.c |   73 +++++++++++++++++++++++----------------------
 drivers/media/rc/ene_ir.h |   19 +++--------
 2 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 2b9c2569..cf10ecf 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -30,6 +30,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pnp.h>
@@ -118,31 +120,31 @@ static int ene_hw_detect(struct ene_device *dev)
 			dev->pll_freq == ENE_DEFAULT_PLL_FREQ ? 2 : 4;
 
 	if (hw_revision == 0xFF) {
-		ene_warn("device seems to be disabled");
-		ene_warn("send a mail to lirc-list@lists.sourceforge.net");
-		ene_warn("please attach output of acpidump and dmidecode");
+		pr_warn("device seems to be disabled\n");
+		pr_warn("send a mail to lirc-list@lists.sourceforge.net\n");
+		pr_warn("please attach output of acpidump and dmidecode\n");
 		return -ENODEV;
 	}
 
-	ene_notice("chip is 0x%02x%02x - kbver = 0x%02x, rev = 0x%02x",
-		chip_major, chip_minor, old_ver, hw_revision);
+	pr_notice("chip is 0x%02x%02x - kbver = 0x%02x, rev = 0x%02x\n",
+		  chip_major, chip_minor, old_ver, hw_revision);
 
-	ene_notice("PLL freq = %d", dev->pll_freq);
+	pr_notice("PLL freq = %d\n", dev->pll_freq);
 
 	if (chip_major == 0x33) {
-		ene_warn("chips 0x33xx aren't supported");
+		pr_warn("chips 0x33xx aren't supported\n");
 		return -ENODEV;
 	}
 
 	if (chip_major == 0x39 && chip_minor == 0x26 && hw_revision == 0xC0) {
 		dev->hw_revision = ENE_HW_C;
-		ene_notice("KB3926C detected");
+		pr_notice("KB3926C detected\n");
 	} else if (old_ver == 0x24 && hw_revision == 0xC0) {
 		dev->hw_revision = ENE_HW_B;
-		ene_notice("KB3926B detected");
+		pr_notice("KB3926B detected\n");
 	} else {
 		dev->hw_revision = ENE_HW_D;
-		ene_notice("KB3926D or higher detected");
+		pr_notice("KB3926D or higher detected\n");
 	}
 
 	/* detect features hardware supports */
@@ -152,7 +154,7 @@ static int ene_hw_detect(struct ene_device *dev)
 	fw_reg1 = ene_read_reg(dev, ENE_FW1);
 	fw_reg2 = ene_read_reg(dev, ENE_FW2);
 
-	ene_notice("Firmware regs: %02x %02x", fw_reg1, fw_reg2);
+	pr_notice("Firmware regs: %02x %02x\n", fw_reg1, fw_reg2);
 
 	dev->hw_use_gpio_0a = !!(fw_reg2 & ENE_FW2_GP0A);
 	dev->hw_learning_and_tx_capable = !!(fw_reg2 & ENE_FW2_LEARNING);
@@ -161,30 +163,29 @@ static int ene_hw_detect(struct ene_device *dev)
 	if (dev->hw_learning_and_tx_capable)
 		dev->hw_fan_input = !!(fw_reg2 & ENE_FW2_FAN_INPUT);
 
-	ene_notice("Hardware features:");
+	pr_notice("Hardware features:\n");
 
 	if (dev->hw_learning_and_tx_capable) {
-		ene_notice("* Supports transmitting & learning mode");
-		ene_notice("   This feature is rare and therefore,");
-		ene_notice("   you are welcome to test it,");
-		ene_notice("   and/or contact the author via:");
-		ene_notice("   lirc-list@lists.sourceforge.net");
-		ene_notice("   or maximlevitsky@gmail.com");
+		pr_notice("* Supports transmitting & learning mode\n");
+		pr_notice("   This feature is rare and therefore,\n");
+		pr_notice("   you are welcome to test it,\n");
+		pr_notice("   and/or contact the author via:\n");
+		pr_notice("   lirc-list@lists.sourceforge.net\n");
+		pr_notice("   or maximlevitsky@gmail.com\n");
 
-		ene_notice("* Uses GPIO %s for IR raw input",
-			dev->hw_use_gpio_0a ? "40" : "0A");
+		pr_notice("* Uses GPIO %s for IR raw input\n",
+			  dev->hw_use_gpio_0a ? "40" : "0A");
 
 		if (dev->hw_fan_input)
-			ene_notice("* Uses unused fan feedback input as source"
-					" of demodulated IR data");
+			pr_notice("* Uses unused fan feedback input as source of demodulated IR data\n");
 	}
 
 	if (!dev->hw_fan_input)
-		ene_notice("* Uses GPIO %s for IR demodulated input",
-			dev->hw_use_gpio_0a ? "0A" : "40");
+		pr_notice("* Uses GPIO %s for IR demodulated input\n",
+			  dev->hw_use_gpio_0a ? "0A" : "40");
 
 	if (dev->hw_extra_buffer)
-		ene_notice("* Uses new style input buffer");
+		pr_notice("* Uses new style input buffer\n");
 	return 0;
 }
 
@@ -215,13 +216,13 @@ static void ene_rx_setup_hw_buffer(struct ene_device *dev)
 
 	dev->buffer_len = dev->extra_buf1_len + dev->extra_buf2_len + 8;
 
-	ene_notice("Hardware uses 2 extended buffers:");
-	ene_notice("  0x%04x - len : %d", dev->extra_buf1_address,
-						dev->extra_buf1_len);
-	ene_notice("  0x%04x - len : %d", dev->extra_buf2_address,
-						dev->extra_buf2_len);
+	pr_notice("Hardware uses 2 extended buffers:\n");
+	pr_notice("  0x%04x - len : %d\n",
+		  dev->extra_buf1_address, dev->extra_buf1_len);
+	pr_notice("  0x%04x - len : %d\n",
+		  dev->extra_buf2_address, dev->extra_buf2_len);
 
-	ene_notice("Total buffer len = %d", dev->buffer_len);
+	pr_notice("Total buffer len = %d\n", dev->buffer_len);
 
 	if (dev->buffer_len > 64 || dev->buffer_len < 16)
 		goto error;
@@ -240,7 +241,7 @@ static void ene_rx_setup_hw_buffer(struct ene_device *dev)
 	ene_set_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
 	return;
 error:
-	ene_warn("Error validating extra buffers, device probably won't work");
+	pr_warn("Error validating extra buffers, device probably won't work\n");
 	dev->hw_extra_buffer = false;
 	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
 }
@@ -588,7 +589,7 @@ static void ene_tx_enable(struct ene_device *dev)
 		dbg("TX: Transmitter #2 is connected");
 
 	if (!(fwreg2 & (ENE_FW2_EMMITER1_CONN | ENE_FW2_EMMITER2_CONN)))
-		ene_warn("TX: transmitter cable isn't connected!");
+		pr_warn("TX: transmitter cable isn't connected!\n");
 
 	/* disable receive on revc */
 	if (dev->hw_revision == ENE_HW_C)
@@ -615,7 +616,7 @@ static void ene_tx_sample(struct ene_device *dev)
 	bool pulse = dev->tx_sample_pulse;
 
 	if (!dev->tx_buffer) {
-		ene_warn("TX: BUG: attempt to transmit NULL buffer");
+		pr_warn("TX: BUG: attempt to transmit NULL buffer\n");
 		return;
 	}
 
@@ -1049,7 +1050,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		dev->hw_learning_and_tx_capable = true;
 		setup_timer(&dev->tx_sim_timer, ene_tx_irqsim,
 						(long unsigned int)dev);
-		ene_warn("Simulation of TX activated");
+		pr_warn("Simulation of TX activated\n");
 	}
 
 	if (!dev->hw_learning_and_tx_capable)
@@ -1089,7 +1090,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	if (error < 0)
 		goto error;
 
-	ene_notice("driver has been successfully loaded");
+	pr_notice("driver has been successfully loaded\n");
 	return 0;
 error:
 	if (dev && dev->irq >= 0)
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 017c209..fd108d9 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -182,20 +182,11 @@
 #define  ENE_HW_C		2	/* 3926C */
 #define  ENE_HW_D		3	/* 3926D or later */
 
-#define ene_printk(level, text, ...) \
-	printk(level ENE_DRIVER_NAME ": " text "\n", ## __VA_ARGS__)
-
-#define ene_notice(text, ...) ene_printk(KERN_NOTICE, text, ## __VA_ARGS__)
-#define ene_warn(text, ...) ene_printk(KERN_WARNING, text, ## __VA_ARGS__)
-
-
-#define __dbg(level, format, ...) \
-	do { \
-		if (debug >= level) \
-			printk(KERN_DEBUG ENE_DRIVER_NAME \
-				": " format "\n", ## __VA_ARGS__); \
-	} while (0)
-
+#define __dbg(level, format, ...)				\
+do {								\
+	if (debug >= level)					\
+		pr_debug(format "\n", ## __VA_ARGS__);		\
+} while (0)
 
 #define dbg(format, ...)		__dbg(1, format, ## __VA_ARGS__)
 #define dbg_verbose(format, ...)	__dbg(2, format, ## __VA_ARGS__)
-- 
1.7.6.405.gc1be0

