Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab1JFVfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:35:11 -0400
Received: from smtp208.alice.it ([82.57.200.104]:51271 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab1JFVfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:35:09 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: leds-lp3944, fix "sparse" warning "mixing different enum types"
Date: Thu,  6 Oct 2011 23:34:44 +0200
Message-Id: <1317936884-2320-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <20111005222143.665f7a7e922dbb2b2541007a@studenti.unina.it>
References: <20111005222143.665f7a7e922dbb2b2541007a@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a warning from "sparse":

drivers/leds/leds-lp3944.c:292:23: warning: mixing different enum types
drivers/leds/leds-lp3944.c:292:23:     int enum led_brightness  versus
drivers/leds/leds-lp3944.c:292:23:     int enum lp3944_status

Keeping track of LP3944_LED_STATUS_OFF and LP3944_LED_STATUS_ON only in
lp3944_led_set_brightness() is OK, as the handling of DIM (blinking)
mode[s] is in lp3944_led_set_blink().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/leds/leds-lp3944.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 9010c05..3cc01fb 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -289,7 +289,7 @@ static void lp3944_led_set_brightness(struct led_classdev *led_cdev,
 	dev_dbg(&led->client->dev, "%s: %s, %d\n",
 		__func__, led_cdev->name, brightness);
 
-	led->status = brightness;
+	led->status = !!brightness;
 	schedule_work(&led->work);
 }
 
-- 
1.7.6.3

