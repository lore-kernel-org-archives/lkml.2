Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1IFCiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 22:38:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41652 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1IFCh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 22:37:58 -0400
Subject: [PATCH] ASoC: ad1980: Return proper error if vendor id mismatch
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Roy Huang <roy.huang@analog.com>, Cliff Cai <cliff.cai@analog.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 10:37:48 +0800
Message-ID: <1315276668.9619.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENODEV instead of 0 if vendor id mismatch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad1980.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index 923b364..4c0fc30 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -200,18 +200,22 @@ static int ad1980_soc_probe(struct snd_soc_codec *codec)
 	}
 
 	/* Read out vendor ID to make sure it is ad1980 */
-	if (ac97_read(codec, AC97_VENDOR_ID1) != 0x4144)
+	if (ac97_read(codec, AC97_VENDOR_ID1) != 0x4144) {
+		ret = -ENODEV;
 		goto reset_err;
+	}
 
 	vendor_id2 = ac97_read(codec, AC97_VENDOR_ID2);
 
 	if (vendor_id2 != 0x5370) {
-		if (vendor_id2 != 0x5374)
+		if (vendor_id2 != 0x5374) {
+			ret = -ENODEV;
 			goto reset_err;
-		else
+		} else {
 			printk(KERN_WARNING "ad1980: "
 				"Found AD1981 - only 2/2 IN/OUT Channels "
 				"supported\n");
+		}
 	}
 
 	/* unmute captures and playbacks volume */
-- 
1.7.4.1



