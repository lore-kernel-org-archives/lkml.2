Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0EGPsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:48:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0EGPr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:47:59 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch]hp_accel: Fix race in device removal
Date: Fri, 7 May 2010 17:47:40 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005071747.40801.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 64a9e0d8e585c65526248e6cf1659a13fb01a93a Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 7 May 2010 17:41:59 +0200
Subject: [PATCH] hp_accel: Fix race in device removal

The work queue has to be flushed after the device has been made
inaccessible.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/hwmon/hp_accel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index c8ab505..6f6e05d 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -328,9 +328,9 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(&lis3_dev);
 
-	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
-
+	flush_work(&hpled_led.work);
+	
 	return lis3lv02d_remove_fs(&lis3_dev);
 }
 
-- 
1.6.4.2

