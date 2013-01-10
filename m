Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3AJMHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:07:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab3AJMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/11] extcon: arizona: Only set GPIO if it has been requested
Date: Thu, 10 Jan 2013 12:04:14 +0000
Message-Id: <1357819462-12232-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The micd_pol GPIO is only requested if we've specified one greater than 0
so apply the same test before we set it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 7dbefe8..9e1d104 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -85,8 +85,9 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
 
-	gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
-				info->micd_modes[mode].gpio);
+	if (arizona->pdata.micd_pol_gpio > 0)
+		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
+					info->micd_modes[mode].gpio);
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
 			   ARIZONA_MICD_BIAS_SRC_MASK,
 			   info->micd_modes[mode].bias);
-- 
1.7.10.4

