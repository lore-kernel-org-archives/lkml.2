Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2LCO6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:58:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311Ab2LCOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:45 -0500
Message-Id: <20121203143147.446450183@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Millbrandt <emillbrandt@dekaresearch.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 05/89] ASoC: wm8978: pll incorrectly configured when codec is master
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Millbrandt <emillbrandt@dekaresearch.com>

commit 55c6f4cb6ef49afbb86222c6a3ff85329199c729 upstream.

When MCLK is supplied externally and BCLK and LRC are configured as outputs
(codec is master), the PLL values are only calculated correctly on the first
transmission.  On subsequent transmissions, at differenct sample rates, the
wrong PLL values are used.  Test for f_opclk instead of f_pllout to determine
if the PLL values are needed.

Signed-off-by: Eric Millbrandt <emillbrandt@dekaresearch.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8978.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 5421fd9..4c0a8e4 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -782,7 +782,7 @@ static int wm8978_hw_params(struct snd_pcm_substream *substream,
 		wm8978->mclk_idx = -1;
 		f_sel = wm8978->f_mclk;
 	} else {
-		if (!wm8978->f_pllout) {
+		if (!wm8978->f_opclk) {
 			/* We only enter here, if OPCLK is not used */
 			int ret = wm8978_configure_pll(codec);
 			if (ret < 0)


