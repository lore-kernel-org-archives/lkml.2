Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2DTUR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:17:28 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35868 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2DTUR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:17:27 -0400
Message-ID: <1334953045.3255.17.camel@lorien2>
Subject: [PATCH] leds: change ledtrig-timer to use activated flag
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Fri, 20 Apr 2012 14:17:25 -0600
In-Reply-To: <1334893688.3051.5.camel@lorien2>
References: <1334703911.2655.9.camel@lorien2>
	 <20120417161239.57c41966.akpm@linux-foundation.org>
	 <1334893688.3051.5.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed existing timer trigger to use activated flag to set activate 
successful status in activate routine and check it in deactivate 
routine to do cleanup.

>From 4b7baef37d25b5ba5ed9f561375157e2a717e28f Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Fri, 20 Apr 2012 13:07:20 -0600
Subject: [PATCH] leds: change ledtrig-timer to use activated flag


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/ledtrig-timer.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 328c64c..e20d1db 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -95,8 +95,7 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
-
-	led_cdev->trigger_data = (void *)1;
+	led_cdev->activated = true;
 
 	return;
 
@@ -106,9 +105,10 @@ err_out_delayon:
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
-	if (led_cdev->trigger_data) {
+	if (led_cdev->activated) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		led_cdev->activated = false;
 	}
 
 	/* Stop blinking */
-- 
1.7.5.4



