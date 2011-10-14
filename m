Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1JNF5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:57:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51804 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab1JNF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:57:54 -0400
Subject: [PATCH 2/2] ASoC: wm8990: Fix wrong bit setting for
 WM8990_POWER_MANAGEMENT_2
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1318571809.4610.1.camel@phoenix>
References: <1318571809.4610.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 13:57:48 +0800
Message-ID: <1318571868.4610.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (fakepower & ((1 << WM8990_INMIXR_PWR_BIT) | (1 << WM8990_AINRMUX_PWR_BIT)))
is false, we should clear WM8990_AINR_ENA bits instead of WM8990_AINL_ENA.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8990.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index ecdb8b2..b9c5ecc 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -401,7 +401,7 @@ static int inmixer_event(struct snd_soc_dapm_widget *w,
 		(1 << WM8990_AINRMUX_PWR_BIT))) {
 		reg |= WM8990_AINR_ENA;
 	} else {
-		reg &= ~WM8990_AINL_ENA;
+		reg &= ~WM8990_AINR_ENA;
 	}
 	snd_soc_write(w->codec, WM8990_POWER_MANAGEMENT_2, reg);
 
-- 
1.7.4.1



