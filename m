Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1I1HVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:21:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34409 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1I1HVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:21:35 -0400
Subject: [PATCH] ASoC: adau1701: Initialize codec->control_data before
 using it
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cliff Cai <cliff.cai@analog.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 15:21:28 +0800
Message-ID: <1317194488.2498.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently codec->control_data is not initialized before calling
process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/adau1701.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index b7e4cc7..8b7e1c5 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -458,6 +458,7 @@ static int adau1701_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->dapm.idle_bias_off = 1;
+	codec->control_data = to_i2c_client(codec->dev);
 
 	ret = adau1701_load_firmware(codec);
 	if (ret)
-- 
1.7.4.1



