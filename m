Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1LMIOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:14:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20993 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1LMIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:14:17 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-8f-4ee709576554
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH RESEND 1/2] MFD: MAX8997: add platform data and devices for LED
 control
Date: Tue, 13 Dec 2011 17:13:52 +0900
Message-id: <1323764033-3979-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
References: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 device does not support LED control function of it.
To enable MAX8997-LED driver, platform data and devices for LED are updated.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8997.c       |    3 ++-
 include/linux/mfd/max8997.h |   25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 5be53ae..cb83a7a 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -43,7 +43,8 @@ static struct mfd_cell max8997_devs[] = {
 	{ .name = "max8997-battery", },
 	{ .name = "max8997-haptic", },
 	{ .name = "max8997-muic", },
-	{ .name = "max8997-flash", },
+	{ .name = "max8997-led", .id = 1 },
+	{ .name = "max8997-led", .id = 2 },
 };
 
 int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 49d2a0b..f2cb5d9 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -131,6 +131,28 @@ struct max8997_muic_platform_data {
 	int num_init_data;
 };
 
+enum max8997_led_mode {
+	MAX8997_NONE,
+	MAX8997_FLASH_MODE,
+	MAX8997_MOVIE_MODE,
+	MAX8997_FLASH_PIN_CONTROL_MODE,
+	MAX8997_MOVIE_PIN_CONTROL_MODE,
+};
+
+/**
+ *  struct max8997_led_platform_data
+ *  The number of LED devices for MAX8997 is two
+ *  @mode: LED mode for each LED device
+ *  @brightness: initial brightness for each LED device
+ *	range:
+ *	[0 - 31]: MAX8997_FLASH_MODE and MAX8997_FLASH_PIN_CONTROL_MODE
+ *	[0 - 15]: MAX8997_MOVIE_MODE and MAX8997_MOVIE_PIN_CONTROL_MODE
+ */
+struct max8997_led_platform_data {
+	enum max8997_led_mode mode[2];
+	u8 brightness[2];
+};
+
 struct max8997_platform_data {
 	/* IRQ */
 	int irq_base;
@@ -172,7 +194,8 @@ struct max8997_platform_data {
 
 	/* HAPTIC: Not implemented */
 	/* RTC: Not implemented */
-	/* Flash: Not implemented */
+	/* ---- Flash ---- */
+	struct max8997_led_platform_data *led_pdata;
 };
 
 #endif /* __LINUX_MFD_MAX8998_H */
-- 
1.7.4.1

