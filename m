Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1KSAIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1KSAIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:05 2011
Message-Id: <20111119000005.022385328@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [12/26] Revert "leds: save the delay values after a successful call to blink_set()"
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit cb871513f656bdfc48b185b55f37857b5c750c40 upstream.

Revert commit 6123b0e274503a0d3588e84fbe07c9aa01bfaf5d.

The problem this patch intends to solve has alreadqy been fixed by
commit 7a5caabd090b ("drivers/leds/ledtrig-timer.c: fix broken sysfs
delay handling").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/led-class.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -270,11 +270,8 @@ void led_blink_set(struct led_classdev *
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


