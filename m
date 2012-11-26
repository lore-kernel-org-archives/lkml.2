Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2KZL2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:28:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab2KZL2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:28:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Only set GPIO if it has been requested
Date: Mon, 26 Nov 2012 11:28:35 +0000
Message-Id: <1353929315-8874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
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
index cdab9e5..585882e 100644
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

