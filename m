Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1EXImm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:42:42 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:20985 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1EXIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:42:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: broonie@opensource.wolfsonmicro.com, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ASoc: wm8731: fix wm8731_check_osc() connected condition
Date: Tue, 24 May 2011 11:50:57 +0200
Message-Id: <1306230657-28649-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crystal oscillator is only enabled if the WM8731_SYSCLK_XTAL master clock
is specified. Fix the connected() struct snd_soc_dapm_route function to take
this into account. Oscillator is not enabled on machine that need it otherwise.

Machine drivers have to make sure that they use the proper SYSCLK value.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/codecs/wm8731.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 6dec7ce..2dc964b 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -198,7 +198,7 @@ static int wm8731_check_osc(struct snd_soc_dapm_widget *source,
 {
 	struct wm8731_priv *wm8731 = snd_soc_codec_get_drvdata(source->codec);
 
-	return wm8731->sysclk_type == WM8731_SYSCLK_MCLK;
+	return wm8731->sysclk_type == WM8731_SYSCLK_XTAL;
 }
 
 static const struct snd_soc_dapm_route wm8731_intercon[] = {
-- 
1.7.3

