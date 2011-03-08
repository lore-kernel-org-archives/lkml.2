Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1CHPdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:33:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45546 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1CHPdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:33:10 -0500
From: Abhilash K V <abhilash.kv@ti.com>
To: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: jhnikula@gmail.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH] ASoC: AM3517: Update codec name after multi-component update
Date: Tue,  8 Mar 2011 21:02:43 +0530
Message-Id: <1299598363-32656-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c client device name (".2-001a" in this case, including
the separator period) for the AIC23 codec on the TI AM3517-EVM
was appended to the codec_name member of am3517evm_dai to
resolve the names mismatch happening in soc_bind_dai_link(),
due to which the card was not getting registered.

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

Acked-by: Jarkko Nikula <jhnikula@gmail.com>

---
 sound/soc/omap/am3517evm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
index 979dd50..ddbd2a1 100644
--- a/sound/soc/omap/am3517evm.c
+++ b/sound/soc/omap/am3517evm.c
@@ -139,7 +139,7 @@ static struct snd_soc_dai_link am3517evm_dai = {
 	.cpu_dai_name ="omap-mcbsp-dai.0",
 	.codec_dai_name = "tlv320aic23-hifi",
 	.platform_name = "omap-pcm-audio",
-	.codec_name = "tlv320aic23-codec",
+	.codec_name = "tlv320aic23-codec.2-001a",
 	.init = am3517evm_aic23_init,
 	.ops = &am3517evm_ops,
 };
-- 
1.6.2.4

