Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab1IOMkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:47 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53980 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521Ab1IOMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:26 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 06/17] ASoC: twl6040: Use chip defaults in the initial reg_cache
Date: Thu, 15 Sep 2011 15:39:28 +0300
Message-Id: <1316090379-30760-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the twl6040_reg array to hold the chip default values.
The only changed values were for the microphone input selection.
Select no input for the microphones in the twl6040_init_chip function.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 8bbd46a..987d9c9 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -118,8 +118,8 @@ static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
 	0x4A, /* TWL6040_LPPLLDIV	0x09	*/
 	0x00, /* TWL6040_AMICBCTL	0x0A	*/
 	0x00, /* TWL6040_DMICBCTL	0x0B	*/
-	0x18, /* TWL6040_MICLCTL	0x0C	- No input selected on Left Mic */
-	0x18, /* TWL6040_MICRCTL	0x0D	- No input selected on Right Mic */
+	0x00, /* TWL6040_MICLCTL	0x0C	*/
+	0x00, /* TWL6040_MICRCTL	0x0D	*/
 	0x00, /* TWL6040_MICGAIN	0x0E	*/
 	0x1B, /* TWL6040_LINEGAIN	0x0F	*/
 	0x00, /* TWL6040_HSLCTL		0x10	*/
@@ -265,6 +265,10 @@ static void twl6040_init_chip(struct snd_soc_codec *codec)
 	val = twl6040_get_revid(twl6040);
 	twl6040_write_reg_cache(codec, TWL6040_REG_ASICREV, val);
 
+	/* Change chip defaults */
+	/* No imput selected for microphone amplifiers */
+	twl6040_write_reg_cache(codec, TWL6040_REG_MICLCTL, 0x18);
+	twl6040_write_reg_cache(codec, TWL6040_REG_MICRCTL, 0x18);
 }
 
 static void twl6040_restore_regs(struct snd_soc_codec *codec)
-- 
1.7.6.1

