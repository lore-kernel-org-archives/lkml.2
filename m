Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3AJMTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:19:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41524 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3AJMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/9] mfd: arizona: Allow customisation of microphone detection levels
Date: Thu, 10 Jan 2013 12:18:49 +0000
Message-Id: <1357820332-14586-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microphone detection levels for Arizona parts can be customised.
Allow this to be done via platform data, the values chosen will depend
on the system design and determined in discussion with Wolfson.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c            |    8 ++++++++
 include/linux/mfd/arizona/pdata.h     |    5 +++++
 include/linux/mfd/arizona/registers.h |    4 ++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1ab02a7..5f0de90 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -458,6 +458,14 @@ int arizona_dev_init(struct arizona *arizona)
 			     arizona->pdata.gpio_defaults[i]);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(arizona->pdata.micd_level); i++) {
+		if (!arizona->pdata.micd_level[i])
+			continue;
+
+		regmap_write(arizona->regmap, ARIZONA_MIC_DETECT_LEVEL_1 + i,
+			     arizona->pdata.micd_level[i]);
+	}
+
 	pm_runtime_set_autosuspend_delay(arizona->dev, 100);
 	pm_runtime_use_autosuspend(arizona->dev);
 	pm_runtime_enable(arizona->dev);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 8b1d1da..73822bd 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -67,6 +67,8 @@
 
 #define ARIZONA_MAX_PDM_SPK 2
 
+#define ARIZONA_NUM_MICD_LEVEL 4
+
 struct regulator_init_data;
 
 struct arizona_micd_config {
@@ -99,6 +101,9 @@ struct arizona_pdata {
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
+	/** Mic detect level parameters */
+	int micd_level[ARIZONA_NUM_MICD_LEVEL];
+
 	/** Headset polarity configurations */
 	struct arizona_micd_config *micd_configs;
 	int num_micd_configs;
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 1f6fe31..fb3a1b8 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -122,6 +122,10 @@
 #define ARIZONA_MIC_DETECT_1                     0x2A3
 #define ARIZONA_MIC_DETECT_2                     0x2A4
 #define ARIZONA_MIC_DETECT_3                     0x2A5
+#define ARIZONA_MIC_DETECT_LEVEL_1		 0x2A6
+#define ARIZONA_MIC_DETECT_LEVEL_2		 0x2A7
+#define ARIZONA_MIC_DETECT_LEVEL_3		 0x2A8
+#define ARIZONA_MIC_DETECT_LEVEL_4		 0x2A9
 #define ARIZONA_MIC_NOISE_MIX_CONTROL_1          0x2C3
 #define ARIZONA_ISOLATION_CONTROL                0x2CB
 #define ARIZONA_JACK_DETECT_ANALOGUE             0x2D3
-- 
1.7.10.4

