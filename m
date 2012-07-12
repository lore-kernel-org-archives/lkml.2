Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161586Ab2GLVbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:31:08 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:48776 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147Ab2GLVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:31:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] wss_lib: fix suspend/resume
Date: Thu, 12 Jul 2012 23:30:31 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207122330.34585.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting SNDRV_PCM_INFO_RESUME, wss_lib claims that it can restore the card
state fully on resume. But in fact, it can't as DMA is not restored so any
playback/capture running during suspend will fail to continue after resume.

Remove SNDRV_PCM_INFO_RESUME flag from pcm info field to fix the problem.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/isa/wss/wss_lib.c
+++ b/sound/isa/wss/wss_lib.c
@@ -1456,7 +1456,6 @@ static struct snd_pcm_hardware snd_wss_playback =
 {
 	.info =			(SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
 				 SNDRV_PCM_INFO_MMAP_VALID |
-				 SNDRV_PCM_INFO_RESUME |
 				 SNDRV_PCM_INFO_SYNC_START),
 	.formats =		(SNDRV_PCM_FMTBIT_MU_LAW | SNDRV_PCM_FMTBIT_A_LAW | SNDRV_PCM_FMTBIT_IMA_ADPCM |
 				 SNDRV_PCM_FMTBIT_U8 | SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S16_BE),

-- 
Ondrej Zary
