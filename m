Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227Ab2GDFOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:14:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2GDFOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:14:00 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/25] leds: convert Heartbeat LED trigger driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:16 +0800
Message-Id: <1341378617-10386-25-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index d3039f2..5caa01b 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -75,7 +75,8 @@ static void heartbeat_trig_activate(struct led_classdev *led_cdev)
 {
 	struct heartbeat_trig_data *heartbeat_data;
 
-	heartbeat_data = kzalloc(sizeof(*heartbeat_data), GFP_KERNEL);
+	heartbeat_data = devm_kzalloc(led_cdev->dev, sizeof(*heartbeat_data),
+				GFP_KERNEL);
 	if (!heartbeat_data)
 		return;
 
@@ -93,7 +94,6 @@ static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
 
 	if (led_cdev->activated) {
 		del_timer_sync(&heartbeat_data->timer);
-		kfree(heartbeat_data);
 		led_cdev->activated = false;
 	}
 }
-- 
1.7.10.4

