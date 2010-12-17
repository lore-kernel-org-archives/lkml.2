Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0LQKUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:20:48 -0500
Received: from smtp.nokia.com ([147.243.1.47]:31877 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0LQKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:20:28 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@rpsys.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ilkka.koskinen@nokia.com,
        arun.murthy@stericsson.com, ankur.vaish@stericsson.com
Subject: [PATCH 1/3] leds: leds-lp5523: modify the way of setting led device name
Date: Fri, 17 Dec 2010 12:19:19 +0200
Message-Id: <1292581161-1177-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all leds channels begins with string lp5523.
Patch adds a possibility to provide name via platform
data. This makes it possible to have several
chips without overlapping sysfs names.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/leds/leds-lp5523.c  |    3 ++-
 include/linux/leds-lp5523.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 0cc4ead..6cb4160 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -870,7 +870,8 @@ static int __init lp5523_init_led(struct lp5523_led *led, struct device *dev,
 			return -EINVAL;
 		}
 
-		snprintf(name, 32, "lp5523:channel%d", chan);
+		snprintf(name, sizeof(name), "%s:channel%d",
+			pdata->label ?: "lp5523", chan);
 
 		led->cdev.name = name;
 		led->cdev.brightness_set = lp5523_set_brightness;
diff --git a/include/linux/leds-lp5523.h b/include/linux/leds-lp5523.h
index 7967476..2694289 100644
--- a/include/linux/leds-lp5523.h
+++ b/include/linux/leds-lp5523.h
@@ -42,6 +42,7 @@ struct lp5523_platform_data {
 	int	(*setup_resources)(void);
 	void	(*release_resources)(void);
 	void	(*enable)(bool state);
+	const	char *label;
 };
 
 #endif /* __LINUX_LP5523_H */
-- 
1.7.0.4

