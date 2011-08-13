Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1HMDdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 23:33:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51990 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1HMDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 23:33:15 -0400
Subject: [PATCH] ASoC: sta32x: Fix a memory leak if snd_soc_register_codec
 fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Johannes Stezenbach <js@sig21.net>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:33:08 +0800
Message-ID: <1313206388.29596.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sta32x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 409d89d..fbd7eb9 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -857,6 +857,7 @@ static __devinit int sta32x_i2c_probe(struct i2c_client *i2c,
 	ret = snd_soc_register_codec(&i2c->dev, &sta32x_codec, &sta32x_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register codec (%d)\n", ret);
+		kfree(sta32x);
 		return ret;
 	}
 
-- 
1.7.4.1



