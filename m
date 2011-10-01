Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1JAUFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1JAUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:04:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/26] sound/pxa-zylonite: use a valid device for dev_err()
Date: Sat,  1 Oct 2011 22:03:34 +0200
Message-Id: <1317499438-14058-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EeE370rKbtG4uCGcocB75O243L37lc4vySUvp2VHtVk
 D2hQUBjDJS2xkd5ge5NW95SfWt3xsizv8HAD/axQ+8N+eEAVWg
 /zf0zgrywKxt4eWuk3txvUv/1BH4vlyvtVOSKcKKR0xL+SpeYw
 /In0IZyW4Czz/DtC1zI4j0pCG+9KDfbvx6MwIzXPMcOOvfJsW2
 AFDOHHQ6nsIw9QpV+qIZA7Sn3F5wpjQUIYsHgmktCw6zDBKrKO
 NBIhX0JlWUjQhV3ezQm/aP0BFrwL0lntXh/uiDDA0nj0KNwkA3
 wIxn0cXGoudu2bgKynH1Gjgv5LWxT11PJv36cRWecOdAYD4bje
 prUKMuLTePfsYDjn4dd8CpdL+V0nw9YRoXpVHy1KCAca18Jyh/
 XC7G91nMQxr1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent conversion has introduced references to &pdev->dev, which does
not actually exist in all the contexts it's used in.

Replace this with card->dev where necessary, in order to let
the driver build again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/pxa/zylonite.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/pxa/zylonite.c b/sound/soc/pxa/zylonite.c
index b644575..2b8350b 100644
--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -196,20 +196,20 @@ static int zylonite_probe(struct snd_soc_card *card)
 	if (clk_pout) {
 		pout = clk_get(NULL, "CLK_POUT");
 		if (IS_ERR(pout)) {
-			dev_err(&pdev->dev, "Unable to obtain CLK_POUT: %ld\n",
+			dev_err(card->dev, "Unable to obtain CLK_POUT: %ld\n",
 				PTR_ERR(pout));
 			return PTR_ERR(pout);
 		}
 
 		ret = clk_enable(pout);
 		if (ret != 0) {
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 			clk_put(pout);
 			return ret;
 		}
 
-		dev_dbg(&pdev->dev, "MCLK enabled at %luHz\n",
+		dev_dbg(card->dev, "MCLK enabled at %luHz\n",
 			clk_get_rate(pout));
 	}
 
@@ -241,7 +241,7 @@ static int zylonite_resume_pre(struct snd_soc_card *card)
 	if (clk_pout) {
 		ret = clk_enable(pout);
 		if (ret != 0)
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 	}
 
-- 
1.7.5.4

