Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2HGDkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:40:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964860Ab2HGDjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:02 -0400
Message-Id: <20120807032759.369224143@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 23/70] ASoC: wm8994: Ensure there are enough BCLKs for four channels
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b8edf3e5522735c8ce78b81845f7a1a2d4a08626 upstream.

Otherwise if someone tries to use all four channels on AIF1 with the
device in master mode we won't be able to clock out all the data.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index bb62f4b..235577a 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2649,7 +2649,7 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	bclk_rate = params_rate(params) * 2;
+	bclk_rate = params_rate(params) * 4;
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		bclk_rate *= 16;


