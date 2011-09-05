Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1IEV4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 17:56:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44052 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1IEV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 17:56:12 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: [PATCH v2] leds: set LEDS_TRIGGERS as tristate
Date: Tue,  6 Sep 2011 05:56:02 +0800
Message-Id: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LEDS_TRIGGERS is depends on LEDS_CLASSS, which should be tristate. So
set it as tristate too and update header files as well.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/Kconfig |    2 +-
 drivers/leds/leds.h  |    2 +-
 include/linux/leds.h |    7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1c35927..0238719 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,7 +387,7 @@ config LEDS_ASIC3
 	  period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
 	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index e77c7f8..53b59b7 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -35,7 +35,7 @@ static inline int led_get_brightness(struct led_classdev *led_cdev)
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..051bc7e 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -66,7 +66,7 @@ struct led_classdev {
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;
 
@@ -115,7 +115,7 @@ extern void led_brightness_set(struct led_classdev *led_cdev,
 /*
  * LED Triggers
  */
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 
 #define TRIG_NAME_MAX 50
 
@@ -161,7 +161,8 @@ extern void led_trigger_blink(struct led_trigger *trigger,
 #endif
 
 /* Trigger specific functions */
-#ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
+#if defined(CONFIG_LEDS_TRIGGER_IDE_DISK) || \
+	defined(CONFIG_LEDS_TRIGGER_IDE_DISK_MODULE)
 extern void ledtrig_ide_activity(void);
 #else
 #define ledtrig_ide_activity() do {} while(0)
-- 
1.7.4.1

