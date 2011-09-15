Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab1IOMnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:43:13 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:55642 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933568Ab1IOMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 16/17] ASoC/MFD: twl6040: Combine bit definitions for Headset control registers
Date: Thu, 15 Sep 2011 15:39:38 +0300
Message-Id: <1316090379-30760-17-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one set of defines for the HS bits, since they are identical in both
control register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |   11 +++--------
 sound/soc/codecs/twl6040.c  |    2 +-
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 47470ca..d9e05ea 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -120,15 +120,10 @@
 #define TWL6040_LPLLFIN			0x08
 #define TWL6040_HPLLSEL			0x10
 
-/* HSLCTL (0x10) fields */
+/* HSLCTL/R (0x10/0x11) fields */
 
-#define TWL6040_HSDACMODEL		0x02
-#define TWL6040_HSDRVMODEL		0x08
-
-/* HSRCTL (0x11) fields */
-
-#define TWL6040_HSDACMODER		0x02
-#define TWL6040_HSDRVMODER		0x08
+#define TWL6040_HSDACMODE		(1 << 1)
+#define TWL6040_HSDRVMODE		(1 << 3)
 
 /* VIBCTLL (0x18) fields */
 
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 1be8d1b..abde625 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -638,7 +638,7 @@ static int pga_event(struct snd_soc_dapm_widget *w,
 static int headset_power_mode(struct snd_soc_codec *codec, int high_perf)
 {
 	int hslctl, hsrctl;
-	int mask = TWL6040_HSDRVMODEL | TWL6040_HSDACMODEL;
+	int mask = TWL6040_HSDRVMODE | TWL6040_HSDACMODE;
 
 	hslctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSLCTL);
 	hsrctl = twl6040_read_reg_cache(codec, TWL6040_REG_HSRCTL);
-- 
1.7.6.1

