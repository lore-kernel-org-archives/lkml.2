Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2FNSbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:31:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47852 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab2FNSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:31:36 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Shuah Khan <shuahkhan@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v2] leds: use led_set_brightness in led_trigger_event
Date: Thu, 14 Jun 2012 20:33:35 +0200
Message-Id: <1339698815-1806-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1339619670.13326.22.camel@lorien2>
References: <1339619670.13326.22.camel@lorien2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix led_trigger_event() to use led_set_brightness() instead of
__led_set_brightness(), so that any pending blink timer is stopped before
setting the new brightness value.  Without this fix LED status may be
overridden by a pending timer.

This allows a trigger to use a mix of led_trigger_event(),
led_trigger_blink() and led_trigger_blink_oneshot() without races.

(applied over: leds: Rename led_brightness_set() to led_set_brightness())

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---

Hi Shuah,

thanks for the renaming, looks much more clear now, so that's my
led_trigger_event patch which applies on top of your latest patch - which
should still be needed if I didn't lost anything.

Fabio

 drivers/leds/led-triggers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 57721f2..de1c59d 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
 		struct led_classdev *led_cdev;
 
 		led_cdev = list_entry(entry, struct led_classdev, trig_list);
-		__led_set_brightness(led_cdev, brightness);
+		led_set_brightness(led_cdev, brightness);
 	}
 	read_unlock(&trig->leddev_list_lock);
 }
-- 
1.7.11.rc1.9.gf623ca1.dirty

