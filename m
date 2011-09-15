Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab1IOMqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:46:37 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:35434 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab1IOMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:46:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Date: Thu, 15 Sep 2011 15:39:29 +0300
Message-Id: <1316090379-30760-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default gains on outputs/inputs are set to 0dB.
To be able to handle pop noise better, we need to lower
the gains on controls, where it is possible.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 987d9c9..1f6068b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -269,6 +269,13 @@ static void twl6040_init_chip(struct snd_soc_codec *codec)
 	/* No imput selected for microphone amplifiers */
 	twl6040_write_reg_cache(codec, TWL6040_REG_MICLCTL, 0x18);
 	twl6040_write_reg_cache(codec, TWL6040_REG_MICRCTL, 0x18);
+
+	/* Lower the gains */
+	twl6040_write_reg_cache(codec, TWL6040_REG_HSGAIN, 0xff);
+	twl6040_write_reg_cache(codec, TWL6040_REG_EARCTL, 0x1e);
+	twl6040_write_reg_cache(codec, TWL6040_REG_HFLGAIN, 0x1d);
+	twl6040_write_reg_cache(codec, TWL6040_REG_HFRGAIN, 0x1d);
+	twl6040_write_reg_cache(codec, TWL6040_REG_LINEGAIN, 0);
 }
 
 static void twl6040_restore_regs(struct snd_soc_codec *codec)
-- 
1.7.6.1

