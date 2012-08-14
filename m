Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2HNO2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:28:50 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55334 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223Ab2HNOWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:22:51 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/14] MFD: twl4030-audio: Get audio MCLK via twl-core API instead of pdata
Date: Tue, 14 Aug 2012 17:22:33 +0300
Message-Id: <1344954162-7985-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl-core has API to get the boot time configured HFCLK rate which has the
same rate as the audio MCLK.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.8.6

