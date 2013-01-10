Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3AJMGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:06:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49998 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab3AJMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/11] extcon: arizona: Allow configuration of MICBIAS rise time
Date: Thu, 10 Jan 2013 12:04:15 +0000
Message-Id: <1357819462-12232-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow configuration of the rise time for MICBIAS via platform data, the
delay required depends on things like the external component selection.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-arizona.c   |    6 ++++++
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 9e1d104..635b707 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -417,6 +417,12 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (arizona->pdata.micd_bias_start_time)
+		regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				   ARIZONA_MICD_BIAS_STARTTIME_MASK,
+				   arizona->pdata.micd_bias_start_time
+				   << ARIZONA_MICD_BIAS_STARTTIME_SHIFT);
+
 	arizona_extcon_set_mode(info, 0);
 
 	info->input = devm_input_allocate_device(&pdev->dev);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 8b1d1da..5b05088 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -99,6 +99,9 @@ struct arizona_pdata {
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
+	/** Mic detect ramp rate */
+	int micd_bias_start_time;
+
 	/** Headset polarity configurations */
 	struct arizona_micd_config *micd_configs;
 	int num_micd_configs;
-- 
1.7.10.4

