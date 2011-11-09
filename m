Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1KIBbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:31:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38034 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KIBbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:31:10 -0500
Message-ID: <1320802258.2564.3.camel@phoenix>
Subject: [PATCH][STABLE 2.6.32]ASoC: wm8940: Properly set codec->bias_level
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, chris@edesix.com,
        stefan.bader@canonical.com, stable@vger.kernel.org,
        stable-commits@vger.kernel.org
Date: Wed, 09 Nov 2011 09:30:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Chris Paulson-Ellis <chris@edesix.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Due to API change, the patch "ASoC: wm8940: Properly set codec->dapm.bias_level"
won't build in linux-2.6.32. Thus we need this revision for 2.6.32.
This patch is against linux-2.6.32.

Regards,
Axel
 sound/soc/codecs/wm8940.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 1ef2454..de081df 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -472,6 +472,7 @@ static int wm8940_set_bias_level(struct snd_soc_codec *codec,
 		ret = snd_soc_write(codec, WM8940_POWER1, pwr_reg);
 		break;
 	}
+	codec->bias_level = level;
 
 	return ret;
 }
-- 
1.7.5.4



