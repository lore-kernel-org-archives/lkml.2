Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab1JNEIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:08:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44488 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1JNEIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:08:09 -0400
Subject: [PATCH 1/2] ASoC: wm8991: Fix wrong bit setting for
 WM8991_POWER_MANAGEMENT_2
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 12:08:00 +0800
Message-ID: <1318565280.10049.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (fakepower & ((1 << WM8991_INMIXR_PWR_BIT)|(1 << WM8991_AINRMUX_PWR_BIT))))
is false, we should clear WM8991_AINR_ENA bits instead of WM8991_AINL_ENA.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8991.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 08d64a6..708d251 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -393,7 +393,7 @@ static int inmixer_event(struct snd_soc_dapm_widget *w,
 			 (1 << WM8991_AINRMUX_PWR_BIT)))
 		reg |= WM8991_AINR_ENA;
 	else
-		reg &= ~WM8991_AINL_ENA;
+		reg &= ~WM8991_AINR_ENA;
 
 	snd_soc_write(w->codec, WM8991_POWER_MANAGEMENT_2, reg);
 	return 0;
-- 
1.7.4.1



