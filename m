Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1GHFFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab1GHFFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.316766322@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [088/107] ASoC: pxa-ssp: Correct check for stream presence
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 53dea36c70c1857149a8c447224e3936eb8b5339 upstream.

Don't rely on the codec's channels_min information to decide wheter or
not allocate a substream's DMA buffer. Rather check if the substream
itself was allocated previously.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/pxa2xx-pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/pxa/pxa2xx-pcm.c
+++ b/sound/soc/pxa/pxa2xx-pcm.c
@@ -95,14 +95,14 @@ static int pxa2xx_soc_pcm_new(struct snd
 	if (!card->dev->coherent_dma_mask)
 		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
-	if (dai->driver->playback.channels_min) {
+	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
 		ret = pxa2xx_pcm_preallocate_dma_buffer(pcm,
 			SNDRV_PCM_STREAM_PLAYBACK);
 		if (ret)
 			goto out;
 	}
 
-	if (dai->driver->capture.channels_min) {
+	if (pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream) {
 		ret = pxa2xx_pcm_preallocate_dma_buffer(pcm,
 			SNDRV_PCM_STREAM_CAPTURE);
 		if (ret)


