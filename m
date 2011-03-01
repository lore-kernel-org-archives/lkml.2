Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1CAPnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:43:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab1CAPny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:43:54 -0500
From: Abhilash K V <abhilash.kv@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH] audio:am3517evm support for AIC23
Date: Tue,  1 Mar 2011 21:13:38 +0530
Message-Id: <1298994218-30610-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to fix the registration of the AIC23-based audio
module on the AM3517-EVM, with the following two changes:

1. The i2c_board_info entry supporting aic23 codec was added into
   the i2c2 bus.
2. The i2c client device name (".2-001a" in this case, including
   the separator period) was appended to the codec_name member of
   am3517evm_dai to resolve the names mismatch happening in
   soc_bind_dai_link().

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c |    3 +++
 sound/soc/omap/am3517evm.c            |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index ad71cbf..8da8d20 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -358,6 +358,9 @@ static struct pca953x_platform_data am3517evm_gpio_expander_info_0 = {
 };
 static struct i2c_board_info __initdata am3517evm_i2c2_boardinfo[] = {
 	{
+		I2C_BOARD_INFO("tlv320aic23", 0x1A),
+	},
+	{
 		I2C_BOARD_INFO("tca6416", 0x21),
 		.platform_data = &am3517evm_gpio_expander_info_0,
 	},
diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
index 979dd50..ddbd2a1 100644
--- a/sound/soc/omap/am3517evm.c
+++ b/sound/soc/omap/am3517evm.c
@@ -139,7 +139,7 @@ static struct snd_soc_dai_link am3517evm_dai = {
 	.cpu_dai_name ="omap-mcbsp-dai.0",
 	.codec_dai_name = "tlv320aic23-hifi",
 	.platform_name = "omap-pcm-audio",
-	.codec_name = "tlv320aic23-codec",
+	.codec_name = "tlv320aic23-codec.2-001a",
 	.init = am3517evm_aic23_init,
 	.ops = &am3517evm_ops,
 };
-- 
1.6.2.4

