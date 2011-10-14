Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1JNBjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 21:39:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46153 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1JNBjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 21:39:21 -0400
Subject: [PATCH 3/3] ASoC: wm8961: Convert codec->hw_read to snd_soc_read
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1318556272.6379.4.camel@phoenix>
References: <1318556120.6379.1.camel@phoenix>
	 <1318556272.6379.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 09:39:14 +0800
Message-ID: <1318556354.6379.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec->hw_read is broken now, let's covert to snd_soc_read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8961.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index cdee810..9568c8a 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -974,7 +974,9 @@ static int wm8961_probe(struct snd_soc_codec *codec)
 	}
 
 	/* This isn't volatile - readback doesn't correspond to write */
-	reg = codec->hw_read(codec, WM8961_RIGHT_INPUT_VOLUME);
+	codec->cache_bypass = 1;
+	reg = snd_soc_read(codec, WM8961_RIGHT_INPUT_VOLUME);
+	codec->cache_bypass = 0;
 	dev_info(codec->dev, "WM8961 family %d revision %c\n",
 		 (reg & WM8961_DEVICE_ID_MASK) >> WM8961_DEVICE_ID_SHIFT,
 		 ((reg & WM8961_CHIP_REV_MASK) >> WM8961_CHIP_REV_SHIFT)
-- 
1.7.4.1



