Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2K1KOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:14:34 -0500
Received: from skyrme.org ([193.175.80.135]:49558 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2K1KOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:14:33 -0500
Date: 28 Nov 2012 10:14:28 +0000
Message-Id: <1354097668-3780-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Wolfram Sang" <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Liam Girdwood" <lrg@ti.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Zeng Zhaoming" <zengzm.kernel@gmail.com>, alsa-devel@alsa-project.org,
        "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] sound/sgtl5000: fix initial setting for DAC data source
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <50B5E03E.2080308@ti.com>
References: <50B5E03E.2080308@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to documentation bit 3:2 in register SSS_CTRL are
reserved and zero, so the setting of 0x0008 does not make much sense.
Instead, bit 4 should be set as is with power up, to reflect
routing of I2S_IN to DAC correctly.

Looks much like an off by one error.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/soc/codecs/sgtl5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index df2f99d..5b37891 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -37,7 +37,7 @@
 static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =  {
 	[SGTL5000_CHIP_CLK_CTRL] = 0x0008,
 	[SGTL5000_CHIP_I2S_CTRL] = 0x0010,
-	[SGTL5000_CHIP_SSS_CTRL] = 0x0008,
+	[SGTL5000_CHIP_SSS_CTRL] = 0x0010,
 	[SGTL5000_CHIP_DAC_VOL] = 0x3c3c,
 	[SGTL5000_CHIP_PAD_STRENGTH] = 0x015f,
 	[SGTL5000_CHIP_ANA_HP_CTRL] = 0x1818,
-- 
1.7.9.5

