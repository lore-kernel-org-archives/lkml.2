Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1G0JNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:13:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49081 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1G0JNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:13:42 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-23-4e2fd6c42f1c
Date: Wed, 27 Jul 2011 18:12:57 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH v2] backlight/platform_lcd: change set power function parameter
 in plat_lcd_data
To: linux-fbdev@vger.kernel.org
Cc: rpurdie@rpsys.net, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dh09.lee@samsung.com, dg77.kim@samsung.com
Message-id: <1311757977-12694-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 27 Jul 2011 09:14:01.0692 (UTC)
 FILETIME=[864EA9C0:01CC4C3D]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_power function in platdata for platform_lcd driver
has originally two parameters.
The first parameter type is struct plat_lcd_data * and
the second parameter type is unsigned int .

In some cases, it is needed to get pointer typed 'struct device'
in order to call regulator_* functions.
This patch allows users to define a set_power function
which control regulators related to platform_lcd device.

Currently, variables in struct plat_lcd_data are not used
in several set_power functions which are defined at arch/arm/ directory.

Changes since v1 :
* Remove compile warning message by including another heeder file

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 drivers/video/backlight/platform_lcd.c |    2 +-
 include/video/platform_lcd.h           |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 302330a..cf23a3f 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -49,7 +49,7 @@ static int platform_lcd_set_power(struct lcd_device *lcd, int power)
 	if (power == FB_BLANK_POWERDOWN || plcd->suspended)
 		lcd_power = 0;
 
-	plcd->pdata->set_power(plcd->pdata, lcd_power);
+	plcd->pdata->set_power(lcd, lcd_power);
 	plcd->power = power;
 
 	return 0;
diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
index ad3bdfe..5d7e943 100644
--- a/include/video/platform_lcd.h
+++ b/include/video/platform_lcd.h
@@ -10,12 +10,13 @@
  * published by the Free Software Foundation.
  *
 */
+#include <linux/lcd.h>
 
 struct plat_lcd_data;
 struct fb_info;
 
 struct plat_lcd_data {
-	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
+	void	(*set_power)(struct lcd_device *, unsigned int power);
 	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
 };
 
-- 
1.7.4.1

