Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2HTTuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:50:46 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:46116 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2HTTun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:50:43 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Massimo Piccioni <dafastidio@libero.it>
Subject: [PATCH] snd-als100: fix suspend/resume
Date: Mon, 20 Aug 2012 21:50:13 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201208202150.13593.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_card_als100_probe() does not set pcm field in struct snd_sb.
As a result, PCM is not suspended and applications don't know that they need
to resume the playback.

Tested with Labway A381-F20 card (ALS120).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -233,7 +233,7 @@ static int __devinit snd_card_als100_probe(int dev,
 			irq[dev], dma8[dev], dma16[dev]);
 	}
 
-	if ((error = snd_sb16dsp_pcm(chip, 0, NULL)) < 0) {
+	if ((error = snd_sb16dsp_pcm(chip, 0, &chip->pcm)) < 0) {
 		snd_card_free(card);
 		return error;
 	}




-- 
Ondrej Zary
