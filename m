Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1CRLD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:03:27 -0400
Received: from [77.233.226.4] ([77.233.226.4]:55692 "EHLO
	public.doredevelopment.dk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752835Ab1CRLDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:03:24 -0400
From: eha@doredevelopment.dk
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Esben Haabendal <eha@doredevelopment.dk>
Subject: [PATCH] leds: Support automatic start of blinking with ledtrig-timer
Date: Fri, 18 Mar 2011 12:03:19 +0100
Message-Id: <1300446199-3234-1-git-send-email-eha@doredevelopment.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@doredevelopment.dk>

By setting initial values blink_delay_on and blink_delay_off in a
led_classdev struct, this change starts the blinking when the led
is initialized.

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
---
 drivers/leds/led-class.c     |    3 ++-
 drivers/leds/ledtrig-timer.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index d5a4ade..d7bdef8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -131,7 +131,8 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (delay_on == led_cdev->blink_delay_on &&
+	if (led_cdev->trigger_data &&
+	    delay_on == led_cdev->blink_delay_on &&
 	    delay_off == led_cdev->blink_delay_off)
 		return;
 
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index b09bcbe..d87c9d0 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -91,6 +91,9 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 	if (rc)
 		goto err_out_delayon;
 
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+		      &led_cdev->blink_delay_off);
+
 	led_cdev->trigger_data = (void *)1;
 
 	return;
-- 
1.7.1

