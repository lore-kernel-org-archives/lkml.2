Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2HDMBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:01:41 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:62212 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab2HDMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:00:43 -0400
X-IronPort-AV: E=Sophos;i="4.77,711,1336341600"; 
   d="scan'208";a="169070476"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>, matthias@kaehlcke.net
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sound/soc/soc-core.c: drop kfree of devm_kzalloc's data
Date: Sat,  4 Aug 2012 14:00:32 +0200
Message-Id: <1344081632-4729-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using kfree to free data allocated with devm_kzalloc causes double frees.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The kfrees were introduced in b761c0ca.

 sound/soc/soc-core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index f81c597..86d7a36 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4136,7 +4136,6 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 			dev_err(card->dev,
 				"Property '%s' index %d could not be read: %d\n",
 				propname, 2 * i, ret);
-			kfree(routes);
 			return -EINVAL;
 		}
 		ret = of_property_read_string_index(np, propname,
@@ -4145,7 +4144,6 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 			dev_err(card->dev,
 				"Property '%s' index %d could not be read: %d\n",
 				propname, (2 * i) + 1, ret);
-			kfree(routes);
 			return -EINVAL;
 		}
 	}

