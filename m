Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3AJMEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:04:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49987 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab3AJMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/11] extcon: arizona: Remove duplicate mic ramp configuration
Date: Thu, 10 Jan 2013 12:04:13 +0000
Message-Id: <1357819462-12232-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this is configured by platform data remove the defualt configuration
the driver had.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 4454d2d..7dbefe8 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -473,9 +473,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	}
 
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
-			   ARIZONA_MICD_BIAS_STARTTIME_MASK |
 			   ARIZONA_MICD_RATE_MASK,
-			   7 << ARIZONA_MICD_BIAS_STARTTIME_SHIFT |
 			   8 << ARIZONA_MICD_RATE_SHIFT);
 
 	arizona_clk32k_enable(arizona);
-- 
1.7.10.4

