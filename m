Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0EGQEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:04:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab0EGQEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:04:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch]hp_accel: Fix race in device removal
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
Date: Fri, 7 May 2010 18:04:20 +0200
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201005071804.20462.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 505056649f5ecb1ebb086981243b9870ce961a87 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 7 May 2010 18:02:07 +0200
Subject: [PATCH] hp_accel: Fix race in device removal

The work queue has to be flushed after the device has been made
inaccessible.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/hwmon/hp_accel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index c8ab505..7580f55 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -328,8 +328,8 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(&lis3_dev);
 
-	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
+	flush_work(&hpled_led.work);
 
 	return lis3lv02d_remove_fs(&lis3_dev);
 }
-- 
1.6.4.2

