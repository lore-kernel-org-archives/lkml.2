Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CRGxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:53:19 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46165 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0CRGxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:53:17 -0400
Date: Thu, 18 Mar 2010 07:53:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: tiwai@suse.de, rmk@arm.linux.org.uk, perex@perex.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] sound/oss/vidc.c: change the field used with DMA_ACTIVE
Message-ID: <Pine.LNX.4.64.1003180752400.23843@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The constant DMA_ACTIVE is defined with the dma_buffparams structure rather
than with the audio_operations structure.  Takashi Iwai suggested that the
dmap_out field of the audio_operations structure should be used instead.

This is not tested.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/oss/vidc.c                    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/vidc.c b/sound/oss/vidc.c
index 725fef0..a4127ba 100644
--- a/sound/oss/vidc.c
+++ b/sound/oss/vidc.c
@@ -363,13 +363,13 @@ static void vidc_audio_trigger(int dev, int enable_bits)
 	struct audio_operations *adev = audio_devs[dev];
 
 	if (enable_bits & PCM_ENABLE_OUTPUT) {
-		if (!(adev->flags & DMA_ACTIVE)) {
+		if (!(adev->dmap_out->flags & DMA_ACTIVE)) {
 			unsigned long flags;
 
 			local_irq_save(flags);
 
 			/* prevent recusion */
-			adev->flags |= DMA_ACTIVE;
+			adev->dmap_out->flags |= DMA_ACTIVE;
 
 			dma_interrupt = vidc_audio_dma_interrupt;
 			vidc_sound_dma_irq(0, NULL);
