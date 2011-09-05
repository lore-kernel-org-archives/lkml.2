Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1IEPdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:33:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1IEPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:33:37 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        stable@kernel.org
Subject: [PATCH] leds: ledtrig-timer: fix broken sysfs delay handling
Date: Mon,  5 Sep 2011 17:33:03 +0200
Message-Id: <1315236783-513-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
5ada28bf76752e33dce3d807bf0dfbe6d1b943ad (led-class: always implement
blinking) which broke sysfs delay handling by not storing the updated
value. Consequently it was only possible to set one of the delays
through the sysfs interface as the other delay was automatically
restored to it's default value. Reading the parameters always gave the
defaults.

Cc: stable@kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/leds/ledtrig-timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index d87c9d0..328c64c 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -41,6 +41,7 @@ static ssize_t led_delay_on_store(struct device *dev,
 
 	if (count == size) {
 		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+		led_cdev->blink_delay_on = state;
 		ret = count;
 	}
 
@@ -69,6 +70,7 @@ static ssize_t led_delay_off_store(struct device *dev,
 
 	if (count == size) {
 		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+		led_cdev->blink_delay_off = state;
 		ret = count;
 	}
 
-- 
1.7.6

