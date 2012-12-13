Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2LMOFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2LMOFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Millbrandt <emillbrandt@dekaresearch.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 079/241] ASoC: wm8978: pll incorrectly configured when codec is master
Date: Thu, 13 Dec 2012 11:57:24 -0200
Message-Id: <1355407206-17100-80-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm8978.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a5be3ad..2f46d66 100644
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
-- 
1.7.9.5

