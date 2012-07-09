Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2GISdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:33:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57877 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab2GISdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:33:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: arizona: Add support for multiple PDM speaker outputs
Date: Mon,  9 Jul 2012 19:33:14 +0100
Message-Id: <1341858795-27504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers have stride 2 so we can write the loop properly now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c        |    5 ++---
 include/linux/mfd/arizona/pdata.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 83558b5..b4978b5 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -462,18 +462,17 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 				   ARIZONA_OUT1_MONO, val);
 	}
 
-	BUILD_BUG_ON(ARIZONA_MAX_PDM_SPK > 1);
 	for (i = 0; i < ARIZONA_MAX_PDM_SPK; i++) {
 		if (arizona->pdata.spk_mute[i])
 			regmap_update_bits(arizona->regmap,
-					   ARIZONA_PDM_SPK1_CTRL_1,
+					   ARIZONA_PDM_SPK1_CTRL_1 + (i * 2),
 					   ARIZONA_SPK1_MUTE_ENDIAN_MASK |
 					   ARIZONA_SPK1_MUTE_SEQ1_MASK,
 					   arizona->pdata.spk_mute[i]);
 
 		if (arizona->pdata.spk_fmt[i])
 			regmap_update_bits(arizona->regmap,
-					   ARIZONA_PDM_SPK1_CTRL_2,
+					   ARIZONA_PDM_SPK1_CTRL_2 + (i * 2),
 					   ARIZONA_SPK1_FMT_MASK,
 					   arizona->pdata.spk_fmt[i]);
 	}
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index fa2cb98..68ff91a 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -62,7 +62,7 @@
 
 #define ARIZONA_MAX_OUTPUT 5
 
-#define ARIZONA_MAX_PDM_SPK 1
+#define ARIZONA_MAX_PDM_SPK 2
 
 struct regulator_init_data;
 
-- 
1.7.10

