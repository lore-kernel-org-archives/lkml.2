Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab2G0EDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:03:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2G0EDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:03:22 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: gregkh@linuxfoundation.org, ccross@android.com, hmh@hmh.eng.br,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH 3/3] ledtrig-timer: convert to use device_create_file_uevent API
Date: Fri, 27 Jul 2012 12:02:43 +0800
Message-Id: <1343361763-10307-4-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To send KOBJ_CHANGE uevent to userspace which is required by Android

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 9010f7a..d8b6296 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -78,10 +78,12 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 
 	led_cdev->trigger_data = NULL;
 
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
+	rc = device_create_file_uevent(led_cdev->dev, &dev_attr_delay_on,
+				"TRIGGER=timer", KOBJ_CHANGE);
 	if (rc)
 		return;
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	rc = device_create_file_uevent(led_cdev->dev, &dev_attr_delay_off,
+				"TRIGGER=timer", KOBJ_CHANGE);
 	if (rc)
 		goto err_out_delayon;
 
-- 
1.7.11.1

