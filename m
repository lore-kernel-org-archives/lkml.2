Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2FRQnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:43:03 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29670 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751236Ab2FRQnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:43:01 -0400
From: Roland Stigge <stigge@antcom.de>
To: swarren@wwwdotorg.org, cjb@laptop.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] sound: tegra_wm8903: Adjust to of_get_named_gpio() change
Date: Mon, 18 Jun 2012 18:42:21 +0200
Message-Id: <1340037743-12924-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio() was changed to return -EPROBE_DEFER in case of
gpios not probed yet. This patch adjusts tegra_wm8903 to this.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git,
branch for-next

 sound/soc/tegra/tegra_wm8903.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 0c5bb33..d4f14e4 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -284,27 +284,27 @@ static __devinit int tegra_wm8903_driver_probe(struct platform_device *pdev)
 	} else if (np) {
 		pdata->gpio_spkr_en = of_get_named_gpio(np,
 						"nvidia,spkr-en-gpios", 0);
-		if (pdata->gpio_spkr_en == -ENODEV)
+		if (pdata->gpio_spkr_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_hp_mute = of_get_named_gpio(np,
 						"nvidia,hp-mute-gpios", 0);
-		if (pdata->gpio_hp_mute == -ENODEV)
+		if (pdata->gpio_hp_mute == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_hp_det = of_get_named_gpio(np,
 						"nvidia,hp-det-gpios", 0);
-		if (pdata->gpio_hp_det == -ENODEV)
+		if (pdata->gpio_hp_det == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_int_mic_en = of_get_named_gpio(np,
 						"nvidia,int-mic-en-gpios", 0);
-		if (pdata->gpio_int_mic_en == -ENODEV)
+		if (pdata->gpio_int_mic_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_ext_mic_en = of_get_named_gpio(np,
 						"nvidia,ext-mic-en-gpios", 0);
-		if (pdata->gpio_ext_mic_en == -ENODEV)
+		if (pdata->gpio_ext_mic_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 	}
 
-- 
1.7.10

