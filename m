Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1L1HfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:35:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab1L1HfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:35:12 -0500
Message-ID: <1325057700.18468.1.camel@phoenix>
Subject: [PATCH] ASoC: Fix build error in sound/soc/kirkwood/kirkwood-i2s.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Wed, 28 Dec 2011 15:35:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit db33f4de "ARM: Orion: Remove address map info from all platform data structures",
the dram is removed from struct kirkwood_asoc_platform_data.

This patch fixes below build error:
  CC      sound/soc/kirkwood/kirkwood-i2s.o
sound/soc/kirkwood/kirkwood-i2s.c: In function 'kirkwood_i2s_dev_probe':
sound/soc/kirkwood/kirkwood-i2s.c:444: error: 'struct kirkwood_asoc_platform_data' has no member named 'dram'
sound/soc/kirkwood/kirkwood-i2s.c:450: error: 'struct kirkwood_asoc_platform_data' has no member named 'dram'
make[3]: *** [sound/soc/kirkwood/kirkwood-i2s.o] Error 1
make[2]: *** [sound/soc/kirkwood] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Nicolas Pitre <nico@fluxnic.net>
---
This patch is against linux-next tree.

 sound/soc/kirkwood/kirkwood-i2s.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index f6bb211..3cb9aa4 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -441,13 +441,12 @@ static __devinit int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	if (!data || !data->dram) {
+	if (!data) {
 		dev_err(&pdev->dev, "no platform data ?!\n");
 		err = -EINVAL;
 		goto err_ioremap;
 	}
 
-	priv->dram = data->dram;
 	priv->burst = data->burst;
 
 	return snd_soc_register_dai(&pdev->dev, &kirkwood_i2s_dai);
-- 
1.7.5.4



