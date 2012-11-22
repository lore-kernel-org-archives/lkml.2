Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2KVSdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:48999 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2KVSd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Misael Lopez Cruz <misael.lopez@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 28/83] ASoC: dapm: Use card_list during DAPM shutdown
Date: Wed, 21 Nov 2012 16:41:50 -0800
Message-Id: <20121122004215.689005057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3710,7 +3710,7 @@ void snd_soc_dapm_shutdown(struct snd_so
 {
 	struct snd_soc_codec *codec;
 
-	list_for_each_entry(codec, &card->codec_dev_list, list) {
+	list_for_each_entry(codec, &card->codec_dev_list, card_list) {
 		soc_dapm_shutdown_codec(&codec->dapm);
 		if (codec->dapm.bias_level == SND_SOC_BIAS_STANDBY)
 			snd_soc_dapm_set_bias_level(&codec->dapm,


