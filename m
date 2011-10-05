Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1JEH2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:28:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33343 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1JEH2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:28:04 -0400
Subject: [PATCH] ASoC: ak4535: Set codec->hw_write to i2c_master_send
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 15:27:56 +0800
Message-ID: <1317799677.21481.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was removed in commit f0fba2ad
"ASoC: multi-component - ASoC Multi-Component Support".

Add it back, otherwise codec->hw_write points to NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4535.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index e1a214e..00cc92c 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -439,6 +439,7 @@ static int ak4535_probe(struct snd_soc_codec *codec)
 
 	printk(KERN_INFO "AK4535 Audio Codec %s", AK4535_VERSION);
 
+	codec->hw_write = (hw_write_t)i2c_master_send;
 	codec->control_data = ak4535->control_data;
 
 	/* power on device */
-- 
1.7.4.1



