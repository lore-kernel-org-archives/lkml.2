Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1A0PXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:23:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1A0PXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l+i7agbB0bKs6Ch+9Bv9KHoGAv6tiIa9q9Lulzt7+IvJummorpRZ/4UKuvlfLOh94f
         bDwkC5eUi2za123QQ5kEQaDBouEW2cvcJoJOTS67rxSs0Q4xJV96SiYA7g5fC7zvI6XA
         TO4ComMpufga9iAc5CJKE23xXzy5A/OGrhb94=
From: ygeorgie <ygeorgie@gmail.com>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@linux.intel.com>
Cc: Yury Georgievskiy <ygeorgie@gmail.com>
Subject: [PATCH RFC] leds: Allow heartbeat trigger to use user-defined brightness.
Date: Thu, 27 Jan 2011 16:22:57 +0100
Message-Id: <1296141777-6016-1-git-send-email-ygeorgie@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yury Georgievskiy <ygeorgie@gmail.com>

Led brightness for PWM leds can be dynamically adjusted.
GPIO leds are not affected as only on/off states are possible.

Checked with PWM leds.
Writing new value in /sys/class/leds/led-pwm::/brightness
alter PWM led brightness as expected.

Signed-off-by: Yury Georgievskiy <ygeorgie@gmail.com>
---
 drivers/leds/ledtrig-heartbeat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 759c0bb..74afb5a 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -48,7 +48,7 @@ static void led_heartbeat_function(unsigned long data)
 			msecs_to_jiffies(heartbeat_data->period);
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = led_cdev->max_brightness;
+		brightness = led_cdev->brightness;
 		break;
 	case 1:
 		delay = heartbeat_data->period / 4 - msecs_to_jiffies(70);
@@ -57,7 +57,7 @@ static void led_heartbeat_function(unsigned long data)
 	case 2:
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = led_cdev->max_brightness;
+		brightness = led_cdev->brightness;
 		break;
 	default:
 		delay = heartbeat_data->period - heartbeat_data->period / 4 -
@@ -66,7 +66,7 @@ static void led_heartbeat_function(unsigned long data)
 		break;
 	}

-	led_set_brightness(led_cdev, brightness);
+	led_cdev->brightness_set(led_cdev, brightness);
 	mod_timer(&heartbeat_data->timer, jiffies + delay);
 }

--
1.7.3.2

