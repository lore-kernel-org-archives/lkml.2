Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0KXOlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:41:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33893 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0KXOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hUOGf+76XbgsD4SbMQKMqqp7SEtD0FPfvrYgk0yLdWpkImv/Egm3u73skcq2p/CB1n
         ObuOAcDd+INqdP1T7rSB69SrNViRCJJ7+6RCnr2oWfGTrlLoEQ+/nxPb1a9gTVh2PasK
         zwtwPhctmEIHk/KuFczZg6tOJQrPjrbLl0g54=
Subject: [PATCH] ASoC: tlv320aic3x - fix variable may be used uninitialized
 warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        vbarinov@embeddedalley.com, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 22:40:59 +0800
Message-ID: <1290609659.2749.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If aic3x_read failed , val is used uninitialized.
Fix it by initializing val to 0.

This patch fixes below compile warning:
sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_get_gpio':
sound/soc/codecs/tlv320aic3x.c:1183: warning: 'val' may be used uninitialized in this function
sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_headset_detected':
sound/soc/codecs/tlv320aic3x.c:1211: warning: 'val' may be used uninitialized in this function
sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_button_pressed':
sound/soc/codecs/tlv320aic3x.c:1219: warning: 'val' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index bfd036a..9de7c38 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1180,7 +1180,7 @@ EXPORT_SYMBOL_GPL(aic3x_set_gpio);
 int aic3x_get_gpio(struct snd_soc_codec *codec, int gpio)
 {
 	u8 reg = gpio ? AIC3X_GPIO2_REG : AIC3X_GPIO1_REG;
-	u8 val, bit = gpio ? 2: 1;
+	u8 val = 0, bit = gpio ? 2 : 1;
 
 	aic3x_read(codec, reg, &val);
 	return (val >> bit) & 1;
@@ -1208,7 +1208,7 @@ EXPORT_SYMBOL_GPL(aic3x_set_headset_detection);
 
 int aic3x_headset_detected(struct snd_soc_codec *codec)
 {
-	u8 val;
+	u8 val = 0;
 	aic3x_read(codec, AIC3X_HEADSET_DETECT_CTRL_B, &val);
 	return (val >> 4) & 1;
 }
@@ -1216,7 +1216,7 @@ EXPORT_SYMBOL_GPL(aic3x_headset_detected);
 
 int aic3x_button_pressed(struct snd_soc_codec *codec)
 {
-	u8 val;
+	u8 val = 0;
 	aic3x_read(codec, AIC3X_HEADSET_DETECT_CTRL_B, &val);
 	return (val >> 5) & 1;
 }
-- 
1.7.2



