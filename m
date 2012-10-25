Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab2JYOYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:24:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42312 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758746Ab2JYOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:24:44 -0400
Date: Thu, 25 Oct 2012 15:24:42 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de
Cc: patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: wm5102: Correct micbias DAPM supplies
Message-ID: <20121025142442.GA32126@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARIZONA_MICB1_ENA_SHIFT was used for micbias 2 and 3. This change
correctly uses the ARIZONA_MICBX_ENA_SHIFT for each corresponding DAPM
supply. This should not have caused any problems as the micbias enables
are in the same place in each register.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5102.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 1722b58..8714d62 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -344,9 +344,9 @@ SND_SOC_DAPM_PGA_E("IN3R PGA", ARIZONA_INPUT_ENABLES, ARIZONA_IN3R_ENA_SHIFT,
 SND_SOC_DAPM_SUPPLY("MICBIAS1", ARIZONA_MIC_BIAS_CTRL_1,
 		    ARIZONA_MICB1_ENA_SHIFT, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY("MICBIAS2", ARIZONA_MIC_BIAS_CTRL_2,
-		    ARIZONA_MICB1_ENA_SHIFT, 0, NULL, 0),
+		    ARIZONA_MICB2_ENA_SHIFT, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY("MICBIAS3", ARIZONA_MIC_BIAS_CTRL_3,
-		    ARIZONA_MICB1_ENA_SHIFT, 0, NULL, 0),
+		    ARIZONA_MICB3_ENA_SHIFT, 0, NULL, 0),
 
 SND_SOC_DAPM_PGA("Noise Generator", ARIZONA_COMFORT_NOISE_GENERATOR,
 		 ARIZONA_NOISE_GEN_ENA_SHIFT, 0, NULL, 0),
-- 
1.7.2.5

