Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab2EKJkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:40:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:43237 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab2EKJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:40:28 -0400
From: Bo Shen <voice.shen@atmel.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        alsa-devel@alsa-project.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, josh.wu@atmel.com, jm.lin@atmel.com,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] atmel/ac97c: correct the unexpected behavior when using uninitial value for reset pin
Date: Fri, 11 May 2012 17:39:28 +0800
Message-Id: <1336729168-20562-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pdata->reset_pin is passed with a negative value (means gpio
is invalid), then chip->reset_pin will not be assigned to a vaule,
it will use default value 0. This will cause unexpected behavior.

So, add this patch to correct.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/atmel/ac97c.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 115313e..f5ded64 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -991,6 +991,8 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 			gpio_direction_output(pdata->reset_pin, 1);
 			chip->reset_pin = pdata->reset_pin;
 		}
+	} else {
+		chip->reset_pin = -EINVAL;
 	}
 
 	snd_card_set_dev(card, &pdev->dev);
-- 
1.7.10

