Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1JKJzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:55:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37613 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1JKJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:55:12 -0400
Subject: [PATCH] ASoC: Writing register default value for the reset register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 17:55:00 +0800
Message-ID: <1318326900.3526.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8983 can be reset by performing a write of any value to
the software reset register.
To avoid writing to the software reset register while resume,
we should write the same value in wm8983_reg_defs to software
reset register in wm8983_probe().
The write to the reset register is suppressed by the cache
restore code when it skips writes of default registers.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8983.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 17f04ec..93ee284 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -1007,7 +1007,7 @@ static int wm8983_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
-	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0x8983);
+	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
 		return ret;
-- 
1.7.4.1



