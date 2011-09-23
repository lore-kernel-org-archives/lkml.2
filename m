Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1IWFLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 01:11:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55733 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1IWFLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 01:11:11 -0400
Subject: [PATCH] ASoC: Remove unneeded mutex_init in wl1273_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 13:10:57 +0800
Message-ID: <1316754658.3012.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since f0fba2ad "ASoC: multi-component - ASoC Multi-Component Support",
snd_soc_register_codec() now does all the codec list and mutex init.
Thus don't need to call mutex_init(&codec->mutex) in wl1273_probe() any more.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wl1273.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
index 5836201..9fa1429 100644
--- a/sound/soc/codecs/wl1273.c
+++ b/sound/soc/codecs/wl1273.c
@@ -462,7 +462,6 @@ static int wl1273_probe(struct snd_soc_codec *codec)
 	wl1273->core = *core;
 
 	snd_soc_codec_set_drvdata(codec, wl1273);
-	mutex_init(&codec->mutex);
 
 	r = snd_soc_add_controls(codec, wl1273_controls,
 				 ARRAY_SIZE(wl1273_controls));
-- 
1.7.4.1



