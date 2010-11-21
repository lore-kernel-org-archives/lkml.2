Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0KURkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:40:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39605 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab0KURk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=d4syjEaSWe0/B3s9z3Q58qoDvk5a9drJXUs3EPDowi+GEGmsVKAr3oGBhvEBNfkG+y
         7aUeJnyN1NeKbG6b6ZRVtyEVieJEb1b9VfWObhug42zmdLKIpUbxKy0iElepZQdutCVD
         zld2YmVHH5kWdMDieZmMZqBuHrjr2PAoOlojc=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Jassi Brar <jassi.brar@samsung.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: s3c24xx: test wrong variable
Date: Sun, 21 Nov 2010 20:40:21 +0300
Message-Id: <1290361223-15211-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clk_get() mclk is checked three times instead of mout_epll
and sclk_spdif checks.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested.

 sound/soc/s3c24xx/smdk_spdif.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/s3c24xx/smdk_spdif.c b/sound/soc/s3c24xx/smdk_spdif.c
index 11c88b1..761e02b 100644
--- a/sound/soc/s3c24xx/smdk_spdif.c
+++ b/sound/soc/s3c24xx/smdk_spdif.c
@@ -38,7 +38,7 @@ static int set_audio_clock_heirachy(struct platform_device *pdev)
 	}
 
 	mout_epll = clk_get(NULL, "mout_epll");
-	if (IS_ERR(fout_epll)) {
+	if (IS_ERR(mout_epll)) {
 		printk(KERN_WARNING "%s: Cannot find mout_epll.\n",
 				__func__);
 		ret = -EINVAL;
@@ -54,7 +54,7 @@ static int set_audio_clock_heirachy(struct platform_device *pdev)
 	}
 
 	sclk_spdif = clk_get(NULL, "sclk_spdif");
-	if (IS_ERR(fout_epll)) {
+	if (IS_ERR(sclk_spdif)) {
 		printk(KERN_WARNING "%s: Cannot find sclk_spdif.\n",
 				__func__);
 		ret = -EINVAL;
-- 
1.7.0.4

