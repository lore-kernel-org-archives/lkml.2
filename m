Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2G0MqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:46:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48779 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2G0MqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:46:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/18] ASoC: Ux500: Enable ux500 PCM driver for Device Tree
Date: Fri, 27 Jul 2012 13:45:48 +0100
Message-Id: <1343393162-11938-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch ensures the PCM driver will be probed during
boot-up when Device Tree is enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c |    6 ++++++
 1 file changed, 6 insertions(+)

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

