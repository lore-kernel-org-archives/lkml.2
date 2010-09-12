Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0ILFLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1776 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0ILFLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:10 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Geoff Levand <geoff@infradead.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 11/11] sound: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:59 -0700
Message-Id: <27a88f64b5bfec16c8abf5aca89b7a1b7533ecb9.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/ppc/snd_ps3.c         |    2 +-
 sound/soc/s3c24xx/s3c-dma.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 2f12da4..581a670 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -579,7 +579,7 @@ static int snd_ps3_delay_to_bytes(struct snd_pcm_substream *substream,
 				  rate * delay_ms / 1000)
 		* substream->runtime->channels;
 
-	pr_debug(KERN_ERR "%s: time=%d rate=%d bytes=%ld, frames=%d, ret=%d\n",
+	pr_debug("%s: time=%d rate=%d bytes=%ld, frames=%d, ret=%d\n",
 		 __func__,
 		 delay_ms,
 		 rate,
diff --git a/sound/soc/s3c24xx/s3c-dma.c b/sound/soc/s3c24xx/s3c-dma.c
index 1b61c23..f1b1bc4 100644
--- a/sound/soc/s3c24xx/s3c-dma.c
+++ b/sound/soc/s3c24xx/s3c-dma.c
@@ -94,8 +94,7 @@ static void s3c_dma_enqueue(struct snd_pcm_substream *substream)
 
 		if ((pos + len) > prtd->dma_end) {
 			len  = prtd->dma_end - pos;
-			pr_debug(KERN_DEBUG "%s: corrected dma len %ld\n",
-			       __func__, len);
+			pr_debug("%s: corrected dma len %ld\n", __func__, len);
 		}
 
 		ret = s3c2410_dma_enqueue(prtd->params->channel,
-- 
1.7.3.rc1

