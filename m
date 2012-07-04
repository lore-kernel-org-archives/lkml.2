Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2GDFNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab2GDFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:34 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/25] leds: convert transient LED trigger driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:13 +0800
Message-Id: <1341378617-10386-22-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-transient.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
index 398f104..8e30b0df 100644
--- a/drivers/leds/ledtrig-transient.c
+++ b/drivers/leds/ledtrig-transient.c
@@ -161,7 +161,8 @@ static void transient_trig_activate(struct led_classdev *led_cdev)
 	int rc;
 	struct transient_trig_data *tdata;
 
-	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
+	tdata = devm_kzalloc(led_cdev->dev,
+		sizeof(struct transient_trig_data), GFP_KERNEL);
 	if (!tdata) {
 		dev_err(led_cdev->dev,
 			"unable to allocate transient trigger\n");
@@ -194,7 +195,6 @@ err_out_duration:
 err_out:
 	dev_err(led_cdev->dev, "unable to register transient trigger\n");
 	led_cdev->trigger_data = NULL;
-	kfree(tdata);
 }
 
 static void transient_trig_deactivate(struct led_classdev *led_cdev)
@@ -209,7 +209,6 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
 		device_remove_file(led_cdev->dev, &dev_attr_state);
 		led_cdev->trigger_data = NULL;
 		led_cdev->activated = false;
-		kfree(transient_data);
 	}
 }
 
-- 
1.7.10.4

