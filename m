Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1IOCwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:52:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51614 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IOCwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:52:40 -0400
Subject: ASoC: uninitialized variable i used in wait_for_dc_servo
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 10:52:34 +0800
Message-ID: <1316055154.3496.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,
I guess we need to initialize i to timeout value. comments?

diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index e5e4607..5aee9cb 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -713,6 +713,7 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, u16 mask)
 	snd_soc_write(codec, WM8996_DC_SERVO_2, mask);
 
 	/* Use the interrupt if possible */
+	i = timeout;
 	do {
 		if (i2c->irq) {
 			timeout = wait_for_completion_timeout(&wm8996->dcs_done,
@@ -722,7 +723,7 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, u16 mask)
 
 		} else {
 			msleep(1);
-			if (--i) {
+			if (--i == 0) {
 				timeout = 0;
 				break;
 			}



