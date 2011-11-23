Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1KWKFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:05:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:13554 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1KWKFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:05:09 -0500
From: voice <voice.shen@atmel.com>
To: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org
Cc: Nicolas.Ferre@atmel.com, JM.Lin@atmel.com, Hong.Xu@atmel.com,
        voice <voice.shen@atmel.com>
Subject: [PATCH] atmel ac97c: using software reset instead hardware reset if not available
Date: Wed, 23 Nov 2011 18:05:01 +0800
Message-Id: <1322042701-32100-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using software reset instead hardware reset if not available

Signed-off-by: Bo Shen <voice.shen@atmel.com>
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

