Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1KGLCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:02:37 -0500
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:12875
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753426Ab1KGLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:02:35 -0500
X-Greylist: delayed 1538 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 06:02:35 EST
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Purdie <rpurdie@rpsys.net>, stable@kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] Revert "leds: save the delay values after a successful call to blink_set()"
Date: Mon,  7 Nov 2011 11:36:37 +0100
Message-Id: <1320662197-21471-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1317973118.3988.2.camel@jlt3.sipsolutions.net>
References: <1317973118.3988.2.camel@jlt3.sipsolutions.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 6123b0e274503a0d3588e84fbe07c9aa01bfaf5d.

The problem this patch intends to solve has already been fixed by commit
7a5caabd090b8f7 (drivers/leds/ledtrig-timer.c: fix broken sysfs delay
handling).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi, 

A fix for the problem with the delay parameters not being stored is already in
3.1 (and stable). Rather than storing both values at every call to
led_blink_set only the updated value is stored in led_delay_{on,off}_store in
ledtrig-timer.c.

Thanks,
Johan

 drivers/leds/led-class.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 661b692..6d5628b 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -270,11 +270,8 @@ void led_blink_set(struct led_classdev *led_cdev,
 	del_timer_sync(&led_cdev->blink_timer);
 
 	if (led_cdev->blink_set &&
-	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
-		led_cdev->blink_delay_on = *delay_on;
-		led_cdev->blink_delay_off = *delay_off;
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
-	}
 
 	/* blink with 1 Hz as default if nothing specified */
 	if (!*delay_on && !*delay_off)
-- 
1.7.6

