Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0K2JfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:35:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45132 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0K2JfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jaFyA4MlmObXK/gzGZF6ayHp1uu9H79ezlWRbbh4/Rpt7EYQ2xYGwChTMvJPT/nxQ5
         VnzYuNMYF2rBfggz5juSld9LKuIKHLJhsYd0G5bRzYPlMLlqIgPsTZO49cI3OtO3n/pl
         sWG3xDeK/RePpzAnH4ZvoG9oRQG+dK3+Sm61w=
Subject: [PATCH 3/5] ASoC: Fix compile error for nuc900-pcm.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:40:53 +0800
Message-Id: <1291023653.22911.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below error:

  CC      sound/soc/nuc900/nuc900-pcm.o
sound/soc/nuc900/nuc900-pcm.c: In function 'nuc900_dma_open':
sound/soc/nuc900/nuc900-pcm.c:267: error: 'nuc900_ac97_data' undeclared (first use in this function)
sound/soc/nuc900/nuc900-pcm.c:267: error: (Each undeclared identifier is reported only once
sound/soc/nuc900/nuc900-pcm.c:267: error: for each function it appears in.)
sound/soc/nuc900/nuc900-pcm.c: At top level:
sound/soc/nuc900/nuc900-pcm.c:337: error: expected ',' or ';' before 'static'
sound/soc/nuc900/nuc900-pcm.c:354: error: 'nuc900_soc_platform_probe' undeclared here (not in a function)
make[3]: *** [sound/soc/nuc900/nuc900-pcm.o] Error 1
make[2]: *** [sound/soc/nuc900] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-audio.h |    2 ++
 sound/soc/nuc900/nuc900-pcm.c   |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-audio.h b/sound/soc/nuc900/nuc900-audio.h
index aeed8ea..59f7e8e 100644
--- a/sound/soc/nuc900/nuc900-audio.h
+++ b/sound/soc/nuc900/nuc900-audio.h
@@ -110,4 +110,6 @@ struct nuc900_audio {
 
 };
 
+extern struct nuc900_audio *nuc900_ac97_data;
+
 #endif /*end _NUC900_AUDIO_H */
diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
index 195d1ac..2245f8b 100644
--- a/sound/soc/nuc900/nuc900-pcm.c
+++ b/sound/soc/nuc900/nuc900-pcm.c
@@ -332,7 +332,7 @@ static struct snd_soc_platform_driver nuc900_soc_platform = {
 	.ops		= &nuc900_dma_ops,
 	.pcm_new	= nuc900_dma_new,
 	.pcm_free	= nuc900_dma_free_dma_buffers,
-}
+};
 
 static int __devinit nuc900_soc_platform_probe(struct platform_device *pdev)
 {
-- 
1.7.2



