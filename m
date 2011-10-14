Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1JNGCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:02:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1JNGCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:02:21 -0400
Subject: [PATCH 1/2] ASoC: wm8400: Fix wrong bit setting for
 WM8400_POWER_MANAGEMENT_2
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 13:56:49 +0800
Message-ID: <1318571809.4610.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (fakepower & ((1 << WM8400_INMIXR_PWR) | (1 << WM8400_AINRMUX_PWR)))
is false, we should clear WM8400_AINR_ENA bits instead of WM8400_AINL_ENA.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8400.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index fbee556..dc13be2 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -383,7 +383,7 @@ static int inmixer_event (struct snd_soc_dapm_widget *w,
 		(1 << WM8400_AINRMUX_PWR))) {
 		reg |= WM8400_AINR_ENA;
 	} else {
-		reg &= ~WM8400_AINL_ENA;
+		reg &= ~WM8400_AINR_ENA;
 	}
 	wm8400_write(w->codec, WM8400_POWER_MANAGEMENT_2, reg);
 
-- 
1.7.4.1



