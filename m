Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1EXImq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:42:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56302 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1EXImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:42:44 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: broonie@opensource.wolfsonmicro.com, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ASoc: sam9g20_wm8731: use the proper SYSCKL value
Date: Tue, 24 May 2011 11:51:16 +0200
Message-Id: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9g20 is providing master clock to wm8731: not using a crystal but an
external MCLK. We can avoid conflict and save power using WM8731_SYSCLK_MCLK as
we do not need oscillator to be powered.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/atmel/sam9g20_wm8731.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 28afbbf..95572d2 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -146,7 +146,7 @@ static int at91sam9g20ek_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 			"at91sam9g20ek_wm8731 "
 			": at91sam9g20ek_wm8731_init() called\n");
 
-	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
+	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_MCLK,
 		MCLK_RATE, SND_SOC_CLOCK_IN);
 	if (ret < 0) {
 		printk(KERN_ERR "Failed to set WM8731 SYSCLK: %d\n", ret);
-- 
1.7.3

