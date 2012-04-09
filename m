Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2DIIRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:17:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46607 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2DIIQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:16:41 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/isa/sscape.c: add missing resource-release code
Date: Mon,  9 Apr 2012 10:16:35 +0200
Message-Id: <1333959395-18960-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

At the point of this error-handling code, both regions and the dma have
been allocated, so free it as done in previous and subsequent
error-handling code.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/isa/sscape.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index b4a6aa9..131dd98 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -1019,13 +1019,15 @@ static int __devinit create_sscape(int dev, struct snd_card *card)
 	irq_cfg = get_irq_config(sscape->type, irq[dev]);
 	if (irq_cfg == INVALID_IRQ) {
 		snd_printk(KERN_ERR "sscape: Invalid IRQ %d\n", irq[dev]);
-		return -ENXIO;
+		err = -ENXIO;
+		goto _release_dma;
 	}
 
 	mpu_irq_cfg = get_irq_config(sscape->type, mpu_irq[dev]);
 	if (mpu_irq_cfg == INVALID_IRQ) {
 		snd_printk(KERN_ERR "sscape: Invalid IRQ %d\n", mpu_irq[dev]);
-		return -ENXIO;
+		err = -ENXIO;
+		goto _release_dma;
 	}
 
 	/*

