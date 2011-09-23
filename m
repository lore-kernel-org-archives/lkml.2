Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1IWGuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:50:18 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54129 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067Ab1IWGuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:50:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH v2 1/6] Input: twl6040: Simplify vibra regsiter definitions
Date: Fri, 23 Sep 2011 09:49:39 +0300
Message-Id: <1316760584-27426-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bits within the two control registers (for left and right channel)
are identical.
Use common names for the bits acros the two register.
Also add the missing definition for the path selection bit.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c |   12 ++++++------
 include/linux/mfd/twl6040.h        |   20 +++++++-------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 154b7a3..cb74185 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -74,12 +74,12 @@ static irqreturn_t twl6040_vib_irq_handler(int irq, void *data)
 	if (status & TWL6040_VIBLOCDET) {
 		dev_warn(info->dev, "Left Vibrator overcurrent detected\n");
 		twl6040_clear_bits(twl6040, TWL6040_REG_VIBCTLL,
-				   TWL6040_VIBENAL);
+				   TWL6040_VIBENA);
 	}
 	if (status & TWL6040_VIBROCDET) {
 		dev_warn(info->dev, "Right Vibrator overcurrent detected\n");
 		twl6040_clear_bits(twl6040, TWL6040_REG_VIBCTLR,
-				   TWL6040_VIBENAR);
+				   TWL6040_VIBENA);
 	}
 
 	return IRQ_HANDLED;
@@ -104,16 +104,16 @@ static void twl6040_vibra_enable(struct vibra_info *info)
 		 * overcurrent detection
 		 */
 		twl6040_reg_write(twl6040, TWL6040_REG_VIBCTLL,
-				  TWL6040_VIBENAL | TWL6040_VIBCTRLL);
+				  TWL6040_VIBENA | TWL6040_VIBCTRL);
 		twl6040_reg_write(twl6040, TWL6040_REG_VIBCTLR,
-				  TWL6040_VIBENAR | TWL6040_VIBCTRLR);
+				  TWL6040_VIBENA | TWL6040_VIBCTRL);
 		usleep_range(3000, 3500);
 	}
 
 	twl6040_reg_write(twl6040, TWL6040_REG_VIBCTLL,
-			  TWL6040_VIBENAL);
+			  TWL6040_VIBENA);
 	twl6040_reg_write(twl6040, TWL6040_REG_VIBCTLR,
-			  TWL6040_VIBENAR);
+			  TWL6040_VIBENA);
 
 	info->enabled = true;
 }
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index d9e05ea..e6c755d 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -125,24 +125,18 @@
 #define TWL6040_HSDACMODE		(1 << 1)
 #define TWL6040_HSDRVMODE		(1 << 3)
 
-/* VIBCTLL (0x18) fields */
+/* VIBCTLL/R (0x18/0x1A) fields */
 
-#define TWL6040_VIBENAL			0x01
-#define TWL6040_VIBCTRLL		0x04
-#define TWL6040_VIBCTRLLP		0x08
-#define TWL6040_VIBCTRLLN		0x10
+#define TWL6040_VIBENA			(1 << 0)
+#define TWL6040_VIBSEL			(1 << 1)
+#define TWL6040_VIBCTRL			(1 << 2)
+#define TWL6040_VIBCTRL_P		(1 << 3)
+#define TWL6040_VIBCTRL_N		(1 << 4)
 
-/* VIBDATL (0x19) fields */
+/* VIBDATL/R (0x19/0x1B) fields */
 
 #define TWL6040_VIBDAT_MAX		0x64
 
-/* VIBCTLR (0x1A) fields */
-
-#define TWL6040_VIBENAR			0x01
-#define TWL6040_VIBCTRLR		0x04
-#define TWL6040_VIBCTRLRP		0x08
-#define TWL6040_VIBCTRLRN		0x10
-
 /* GPOCTL (0x1E) fields */
 
 #define TWL6040_GPO1			0x01
-- 
1.7.6.1

