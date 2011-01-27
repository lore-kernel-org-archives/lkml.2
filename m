Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1A0Nuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:50:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41400 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1A0Nup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:50:45 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org,
        linux-kernel@vger.kernel.org,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH] ASoC: DaVinci: fix kernel panic due to uninitialized platform_data
Date: Thu, 27 Jan 2011 19:17:43 +0530
Message-Id: <1296136063-31625-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the Kernel panic issue on accessing davinci_vc in
cq93vc_probe function. struct davinci_vc is part of platform device's
private driver data(codec->dev->p->driver_data) and this is populated
by DaVinci Voice Codec MFD driver.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
This patch applies to Linus's tree at [1].

[1] http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
---
 sound/soc/codecs/cq93vc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 46dbfd0..347a567 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -153,7 +153,7 @@ static int cq93vc_resume(struct snd_soc_codec *codec)
 
 static int cq93vc_probe(struct snd_soc_codec *codec)
 {
-	struct davinci_vc *davinci_vc = codec->dev->platform_data;
+	struct davinci_vc *davinci_vc = snd_soc_codec_get_drvdata(codec);
 
 	davinci_vc->cq93vc.codec = codec;
 	codec->control_data = davinci_vc;
-- 
1.7.1

