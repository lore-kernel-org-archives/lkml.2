Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0K2JiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:38:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63583 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0K2JiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WPW8YnynYrsP4mxS/cl2WFj9TTBuvMwA084fufa2eTtSaCioqQOj9sKCl94Af2bbEn
         K8W6TEk8Nrjz9fvKVqeMI1Ych76hujzPWBWMghuzOFziauokzwYZv5YLGyqqhSWgwC+a
         nceM5PiwpPIjwEDIuqxHRAO6im7NUc+RcFf3Y=
Subject: [PATCH 5/5] ASoC: Remove unneeded !! operations while checking
	return value of nuc900_checkready
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:43:39 +0800
Message-Id: <1291023819.22911.11.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this unneededd !! operations just reduce the readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-ac97.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index 3d9d8b1..dac6732 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -49,7 +49,7 @@ static unsigned short nuc900_ac97_read(struct snd_ac97 *ac97,
 	mutex_lock(&ac97_mutex);
 
 	val = nuc900_checkready();
-	if (!!val) {
+	if (val) {
 		dev_err(nuc900_audio->dev, "AC97 codec is not ready\n");
 		goto out;
 	}
@@ -102,7 +102,7 @@ static void nuc900_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
 	mutex_lock(&ac97_mutex);
 
 	tmp = nuc900_checkready();
-	if (!!tmp)
+	if (tmp)
 		dev_err(nuc900_audio->dev, "AC97 codec is not ready\n");
 
 	/* clear the R_WB bit and write register index */
@@ -149,7 +149,7 @@ static void nuc900_ac97_warm_reset(struct snd_ac97 *ac97)
 	udelay(100);
 
 	val = nuc900_checkready();
-	if (!!val)
+	if (val)
 		dev_err(nuc900_audio->dev, "AC97 codec is not ready\n");
 
 	mutex_unlock(&ac97_mutex);
-- 
1.7.2



