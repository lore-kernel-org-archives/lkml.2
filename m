Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1JCDJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 23:09:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62522 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1JCDJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 23:09:14 -0400
Subject: [PATCH] ASoC: Fix setting update bits for
 WM8741_DACRMSB_ATTENUATION
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 11:09:01 +0800
Message-ID: <1317611341.5065.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After checking the code and datasheet, I think what we want in the second
snd_soc_update_bits call is to update WM8741_DACRMSB_ATTENUATION register
instead of WM8741_DACRLSB_ATTENUATION.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have this hardware handy, thus I only check the the code and datasheet.
The bug is there since commit 992bee40 "ASoC: Initial WM8741 CODEC driver".
I'd appreciate if someone can test this patch.

Regards,
Axel
 sound/soc/codecs/wm8741.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index 78c9e5a..a42b282 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -462,7 +462,7 @@ static int wm8741_probe(struct snd_soc_codec *codec)
 			    WM8741_UPDATELM, WM8741_UPDATELM);
 	snd_soc_update_bits(codec, WM8741_DACRLSB_ATTENUATION,
 			    WM8741_UPDATERL, WM8741_UPDATERL);
-	snd_soc_update_bits(codec, WM8741_DACRLSB_ATTENUATION,
+	snd_soc_update_bits(codec, WM8741_DACRMSB_ATTENUATION,
 			    WM8741_UPDATERM, WM8741_UPDATERM);
 
 	snd_soc_add_controls(codec, wm8741_snd_controls,
-- 
1.7.4.1



