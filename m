Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1GEJOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:14:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41175 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1GEJOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:14:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/5] MFD: twl6040: Add irq variable for slave devices
Date: Tue, 5 Jul 2011 12:14:22 +0300
Message-ID: <1309857266-3663-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new variable to pass the irq number for the slaves
devices of twl6040.
The irq number configuration is done in the twl6040-core
at probe time, so machine drivers do not need to be
modified.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |    2 ++
 include/linux/i2c/twl.h    |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index cfaedb5..8607793 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (pdata->codec) {
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-codec";
+		pdata->codec->plug_irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
 		cell->platform_data = pdata->codec;
 		cell->pdata_size = sizeof(*pdata->codec);
 		children++;
@@ -509,6 +510,7 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (pdata->vibra) {
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-vibra";
+		pdata->vibra->irq = twl6040->irq_base + TWL6040_IRQ_VIB;
 		cell->platform_data = pdata->vibra;
 		cell->pdata_size = sizeof(*pdata->vibra);
 		children++;
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 114c0f6..b28963b 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -668,6 +668,7 @@ struct twl4030_codec_data {
 	u16 hs_right_step;
 	u16 hf_left_step;
 	u16 hf_right_step;
+	int plug_irq;			/* Plug detect irq for twl6040 */
 	void (*set_hs_extmute)(int mute);
 };
 
@@ -675,6 +676,7 @@ struct twl4030_vibra_data {
 	unsigned int	coexist;
 
 	/* twl6040 */
+	int irq;			/* Vibra irq */
 	unsigned int vibldrv_res;	/* left driver resistance */
 	unsigned int vibrdrv_res;	/* right driver resistance */
 	unsigned int viblmotor_res;	/* left motor resistance */
-- 
1.7.6

