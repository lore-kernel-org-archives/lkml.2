Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1LSJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:58:16 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:4895 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1LSJ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:58:15 -0500
From: voice <voice.shen@atmel.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        alsa-devel@alsa-project.org, nicolas.ferre@atmel.com,
        Hans-Christian.Egtvedt@atmel.com, jm.lin@atmel.com, hong.xu@atmel.com,
        voice <voice.shen@atmel.com>
Subject: [PATCH] atmel ac97c: using software reset instead hardware reset if not available
Date: Mon, 19 Dec 2011 17:57:52 +0800
Message-Id: <1324288672-29556-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using software reset instead hardware reset if not available

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/atmel/ac97c.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 6e5adde..73516f6 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -899,6 +899,10 @@ static void atmel_ac97c_reset(struct atmel_ac97c *chip)
 		/* AC97 v2.2 specifications says minimum 1 us. */
 		udelay(2);
 		gpio_set_value(chip->reset_pin, 1);
+	} else {
+		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
+		udelay(2);
+		ac97c_writel(chip, MR, AC97C_MR_ENA);
 	}
 }
 
-- 
1.6.3.3

