Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2IJKtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:49:23 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:45188 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218Ab2IJKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:25 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/14] MFD: twl4030-audio: Get audio MCLK via twl-core API instead of pdata
Date: Mon, 10 Sep 2012 13:46:23 +0300
Message-Id: <1347273992-9107-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl-core has API to get the boot time configured HFCLK rate which has the
same rate as the audio MCLK.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index ca2d669..a48bf3a 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -175,7 +175,7 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mutex_init(&audio->mutex);
-	audio->audio_mclk = pdata->audio_mclk;
+	audio->audio_mclk = twl_get_hfclk_rate();
 
 	/* Configure APLL_INFREQ and disable APLL if enabled */
 	switch (audio->audio_mclk) {
-- 
1.7.12

