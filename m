Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab1FARKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:10:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38596 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1FARKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:10:19 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wan ZongShun <mcuos.com@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Timur Tabi <timur@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] sound/soc/nuc900/nuc900-ac97.c: add missing clk_put
Date: Wed,  1 Jun 2011 19:10:05 +0200
Message-Id: <1306948213-20767-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This goto is after the call to clk_get, so it should go to the label that
includes a call to clk_put.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/nuc900/nuc900-ac97.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index dac6732..9c0edad 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -356,7 +356,7 @@ static int __devinit nuc900_ac97_drvprobe(struct platform_device *pdev)
 	nuc900_audio->irq_num = platform_get_irq(pdev, 0);
 	if (!nuc900_audio->irq_num) {
 		ret = -EBUSY;
-		goto out2;
+		goto out3;
 	}
 
 	nuc900_ac97_data = nuc900_audio;

