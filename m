Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2LMOFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2LMOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 083/241] ASoC: dapm: Use card_list during DAPM shutdown
Date: Thu, 13 Dec 2012 11:57:28 -0200
Message-Id: <1355407206-17100-84-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Misael Lopez Cruz <misael.lopez@ti.com>

commit 445632ad6dda42f4d3f9df2569a852ca0d4ea608 upstream.

DAPM shutdown incorrectly uses "list" field of codec struct while
iterating over probed components (codec_dev_list). "list" field
refers to codecs registered in the system, "card_list" field is
used for probed components.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 5b32b15..9ddc1a8 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3586,7 +3586,7 @@ void snd_soc_dapm_shutdown(struct snd_soc_card *card)
 {
 	struct snd_soc_codec *codec;
 
-	list_for_each_entry(codec, &card->codec_dev_list, list) {
+	list_for_each_entry(codec, &card->codec_dev_list, card_list) {
 		soc_dapm_shutdown_codec(&codec->dapm);
 		if (codec->dapm.bias_level == SND_SOC_BIAS_STANDBY)
 			snd_soc_dapm_set_bias_level(&codec->dapm,
-- 
1.7.9.5

