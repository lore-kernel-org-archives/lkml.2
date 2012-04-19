Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2DSGkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:40:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42970 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2DSGks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:40:48 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/isa/sc6000.c: add missing sc6000_setup_board
Date: Thu, 19 Apr 2012 08:40:40 +0200
Message-Id: <1334817640-15426-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

There seems to be no interaction between *port and the requested region, so
the clearing of *vport should take place if the request_region fails.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.  sc6000_setup_board seems rather complicated, so my reasoning
could be completely wrong.

 sound/isa/sc6000.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index d97d0f3..57679cb 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -594,7 +594,7 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 		snd_printk(KERN_ERR PFX
 			   "I/O port cannot be iomaped.\n");
 		err = -EBUSY;
-		goto err_unmap1;
+		goto err_unmap0;
 	}
 
 	/* to make it marked as used */
@@ -678,9 +678,10 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	return 0;
 
 err_unmap2:
-	sc6000_setup_board(*vport, 0);
 	release_region(mss_port[dev], 4);
 err_unmap1:
+	sc6000_setup_board(*vport, 0);
+err_unmap0:
 	release_region(port[dev], 0x10);
 err_exit:
 	snd_card_free(card);

