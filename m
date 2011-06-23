Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1FWR3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:65168 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828Ab1FWR3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 045/247] ASoC: WM8990: msleep() takes milliseconds not jiffies
Date: Thu, 23 Jun 2011 13:25:44 -0400
Message-Id: <1308850146-15061-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7ebcf5d6021a696680ee77d9162a2edec2d671dd upstream.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/codecs/wm8990.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 7c6b00e..5d1c4d0 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1185,7 +1185,7 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 				     WM8990_VMIDTOG);
 
 			/* Delay to allow output caps to discharge */
-			msleep(msecs_to_jiffies(300));
+			msleep(300);
 
 			/* Disable VMIDTOG */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1197,17 +1197,17 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 			/* Enable outputs */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1b00);
 
-			msleep(msecs_to_jiffies(50));
+			msleep(50);
 
 			/* Enable VMID at 2x50k */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f02);
 
-			msleep(msecs_to_jiffies(100));
+			msleep(100);
 
 			/* Enable VREF */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f03);
 
-			msleep(msecs_to_jiffies(600));
+			msleep(600);
 
 			/* Enable BUFIOEN */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1252,7 +1252,7 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 		/* Disable VMID */
 		snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f01);
 
-		msleep(msecs_to_jiffies(300));
+		msleep(300);
 
 		/* Enable all output discharge bits */
 		snd_soc_write(codec, WM8990_ANTIPOP1, WM8990_DIS_LLINE |
-- 
1.7.4.4

