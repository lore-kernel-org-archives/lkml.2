Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0K2Je3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:34:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63344 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0K2Je1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sm7bTtPKxXsXRX5mm0L1ZwcToSH2Kh1YqHDeT7TgLkO7i/hyI2lJuxZwsLK81CRFCf
         uiY94dszsi4v6TFhKrKQJjFoQFkVPEKXsC0b9L52/P74CNSLbj6EDYyfdouQd5VcZd5L
         K9jg8fRUsBby91EqmyWS1DwJBE2EdIw/HfKhU=
Subject: [PATCH 2/5] ASoC: Fix prototype for nuc900_ac97_probe and
	nuc900_ac97_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:40:05 +0800
Message-Id: <1291023605.22911.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below compile warning:

  CC      sound/soc/nuc900/nuc900-ac97.o
sound/soc/nuc900/nuc900-ac97.c:300: warning: initialization from incompatible pointer type
sound/soc/nuc900/nuc900-ac97.c:301: warning: initialization from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-ac97.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index 4f056b4..3d9d8b1 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -263,8 +263,7 @@ static int nuc900_ac97_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
-static int nuc900_ac97_probe(struct platform_device *pdev,
-					struct snd_soc_dai *dai)
+static int nuc900_ac97_probe(struct snd_soc_dai *dai)
 {
 	struct nuc900_audio *nuc900_audio = nuc900_ac97_data;
 	unsigned long val;
@@ -284,12 +283,12 @@ static int nuc900_ac97_probe(struct platform_device *pdev,
 	return 0;
 }
 
-static void nuc900_ac97_remove(struct platform_device *pdev,
-						struct snd_soc_dai *dai)
+static int nuc900_ac97_remove(struct snd_soc_dai *dai)
 {
 	struct nuc900_audio *nuc900_audio = nuc900_ac97_data;
 
 	clk_disable(nuc900_audio->clk);
+	return 0;
 }
 
 static struct snd_soc_dai_ops nuc900_ac97_dai_ops = {
-- 
1.7.2



