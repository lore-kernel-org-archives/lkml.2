Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2GZK3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:29:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49118 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2GZK3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/21] ASoC: Ux500: Enable ux500 PCM driver for Device Tree
Date: Thu, 26 Jul 2012 11:28:50 +0100
Message-Id: <1343298534-13611-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we pass platform registration from platform code over to Device
Tree, when DT is enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |    3 ---
 sound/soc/ux500/ux500_pcm.c            |    6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index ce7fff9..890feb3 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -257,9 +257,6 @@ void mop500_of_msp_init(struct device *parent)
 					"could not get MSP1 idlestate\n");
 		}
 	}
-
-	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
-	platform_device_register(&ux500_pcm);
 }
 
 void mop500_msp_init(struct device *parent)
diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 1a04e24..557da2d 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -304,10 +304,16 @@ static int __devinit ux500_pcm_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ux500_pcm_match[] = {
+       { .compatible = "stericsson,ux500-pcm", },
+       {},
+};
+
 static struct platform_driver ux500_pcm_driver = {
 	.driver = {
 		.name = "ux500-pcm",
 		.owner = THIS_MODULE,
+		.of_match_table = ux500_pcm_match,
 	},
 
 	.probe = ux500_pcm_drv_probe,
-- 
1.7.9.5

