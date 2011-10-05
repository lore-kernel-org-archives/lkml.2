Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1JEBpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:45:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42236 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab1JEBpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:45:45 -0400
Subject: [PATCH] ASoC: Return early with -EINVAL if invalid dai format is
 detected
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 09:45:34 +0800
Message-ID: <1317779135.2595.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
---
 sound/soc/codecs/cs4270.c  |    2 +-
 sound/soc/codecs/cs42l51.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 5830c93..e645d67 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -271,7 +271,7 @@ static int cs4270_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	default:
 		dev_err(codec->dev, "invalid dai format\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	/* set master/slave audio interface */
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 286878d..779294b 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -298,7 +298,7 @@ static int cs42l51_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	default:
 		dev_err(codec->dev, "invalid DAI format\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	switch (format & SND_SOC_DAIFMT_MASTER_MASK) {
-- 
1.7.4.1



