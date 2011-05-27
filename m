Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1E0PbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:31:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0PbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oqQBYjCF9ChBVBp1PIjjhox+9V4lNNNICfhmEXA42LPh2o3koTa7nIa7l6luGN5nZq
         vQMMWyS4EiVjX1Loeep81f0H08BKOnHMkNJYKiW0fGnSB/kJ6sVFTMswi96r9sa4GCYc
         KXDxZdp9wdaznBvN4KUVoeRilnpWr4HS/WySU=
Subject: [PATCH] ASoC: Remove redundant freq assignment for
 max98095->sysclk/max98088->sysclk
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Peter Hsiang <cdefgab1288@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 23:30:53 +0800
Message-ID: <1306510253.19556.36.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation set max98095->sysclk/max98088->sysclk to freq twice.
Set it once is enough, this patch removes the first assignment in case
we may set invalid clock frequency to max98095->sysclk/max98088->sysclk.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi Peter,
I don't have this hardware handy. Can you help to test it?
Thanks,
Axel

 sound/soc/codecs/max98088.c |    2 --
 sound/soc/codecs/max98095.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4173b67..ac65a2d 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1397,8 +1397,6 @@ static int max98088_dai_set_sysclk(struct snd_soc_dai *dai,
        if (freq == max98088->sysclk)
                return 0;
 
-       max98088->sysclk = freq; /* remember current sysclk */
-
        /* Setup clocks for slave mode, and using the PLL
         * PSCLK = 0x01 (when master clk is 10MHz to 20MHz)
         *         0x02 (when master clk is 20MHz to 30MHz)..
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index e1d282d..872a5fa 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1517,8 +1517,6 @@ static int max98095_dai_set_sysclk(struct snd_soc_dai *dai,
 	if (freq == max98095->sysclk)
 		return 0;
 
-	max98095->sysclk = freq; /* remember current sysclk */
-
 	/* Setup clocks for slave mode, and using the PLL
 	 * PSCLK = 0x01 (when master clk is 10MHz to 20MHz)
 	 *         0x02 (when master clk is 20MHz to 40MHz)..
-- 
1.7.1



