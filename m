Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3AJMFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:05:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214Ab3AJMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/11] mfd: wm5102: Add microphone clamp control registers
Date: Thu, 10 Jan 2013 12:04:22 +0000
Message-Id: <1357819462-12232-11-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    7 +++++++
 include/linux/mfd/arizona/registers.h |    8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 311cc36..a396a3a 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -84,6 +84,12 @@ int wm5102_patch(struct arizona *arizona)
 }
 
 static const struct regmap_irq wm5102_aod_irqs[ARIZONA_NUM_IRQ] = {
+	[ARIZONA_IRQ_MICD_CLAMP_FALL] = {
+		.mask = ARIZONA_MICD_CLAMP_FALL_EINT1
+	},
+	[ARIZONA_IRQ_MICD_CLAMP_RISE] = {
+		.mask = ARIZONA_MICD_CLAMP_RISE_EINT1
+	},
 	[ARIZONA_IRQ_GP5_FALL] = { .mask = ARIZONA_GP5_FALL_EINT1 },
 	[ARIZONA_IRQ_GP5_RISE] = { .mask = ARIZONA_GP5_RISE_EINT1 },
 	[ARIZONA_IRQ_JD_FALL] = { .mask = ARIZONA_JD1_FALL_EINT1 },
@@ -312,6 +318,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x0000021A, 0x01A6 },   /* R538   - Mic Bias Ctrl 3 */ 
 	{ 0x00000293, 0x0000 },   /* R659   - Accessory Detect Mode 1 */ 
 	{ 0x0000029B, 0x0020 },   /* R667   - Headphone Detect 1 */ 
+	{ 0x000002A2, 0x0000 },   /* R674   - Micd clamp control */
 	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */ 
 	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */ 
 	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */ 
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index e915053..79e9dd4 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -1196,6 +1196,14 @@
 /*
  * R64 (0x40) - Wake control
  */
+#define ARIZONA_WKUP_MICD_CLAMP_FALL             0x0080  /* WKUP_MICD_CLAMP_FALL */
+#define ARIZONA_WKUP_MICD_CLAMP_FALL_MASK        0x0080  /* WKUP_MICD_CLAMP_FALL */
+#define ARIZONA_WKUP_MICD_CLAMP_FALL_SHIFT            7  /* WKUP_MICD_CLAMP_FALL */
+#define ARIZONA_WKUP_MICD_CLAMP_FALL_WIDTH            1  /* WKUP_MICD_CLAMP_FALL */
+#define ARIZONA_WKUP_MICD_CLAMP_RISE             0x0040  /* WKUP_MICD_CLAMP_RISE */
+#define ARIZONA_WKUP_MICD_CLAMP_RISE_MASK        0x0040  /* WKUP_MICD_CLAMP_RISE */
+#define ARIZONA_WKUP_MICD_CLAMP_RISE_SHIFT            6  /* WKUP_MICD_CLAMP_RISE */
+#define ARIZONA_WKUP_MICD_CLAMP_RISE_WIDTH            1  /* WKUP_MICD_CLAMP_RISE */
 #define ARIZONA_WKUP_GP5_FALL                    0x0020  /* WKUP_GP5_FALL */
 #define ARIZONA_WKUP_GP5_FALL_MASK               0x0020  /* WKUP_GP5_FALL */
 #define ARIZONA_WKUP_GP5_FALL_SHIFT                   5  /* WKUP_GP5_FALL */
-- 
1.7.10.4

