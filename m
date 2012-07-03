Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2GCBWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:22:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40510 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2GCBWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:22:20 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] backlight: move register definitions from header to
 source
Thread-Topic: [PATCH 1/2] backlight: move register definitions from header
 to source
Thread-Index: Ac1YukIHe6v1bi+vSIWXiIYAIFbA1w==
Date: Tue, 3 Jul 2012 01:22:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCCEB@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ROM boundary definitions are no need to be exported because these are used only
in lp855x driver internally.

And few code cosmetic changes

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |    8 ++++++--
 include/linux/lp855x.h              |    6 ------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 72a0e0c..3d24314 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -17,8 +17,12 @@
 #include <linux/lp855x.h>
 
 /* Registers */
-#define BRIGHTNESS_CTRL		(0x00)
-#define DEVICE_CTRL		(0x01)
+#define BRIGHTNESS_CTRL		0x00
+#define DEVICE_CTRL		0x01
+#define EEPROM_START		0xA0
+#define EEPROM_END		0xA7
+#define EPROM_START		0xA0
+#define EPROM_END		0xAF
 
 #define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
diff --git a/include/linux/lp855x.h b/include/linux/lp855x.h
index 781a490..cc76f1f 100644
--- a/include/linux/lp855x.h
+++ b/include/linux/lp855x.h
@@ -47,12 +47,6 @@
 				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
 #define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
 
-/* ROM area boundary */
-#define EEPROM_START	(0xA0)
-#define EEPROM_END	(0xA7)
-#define EPROM_START	(0xA0)
-#define EPROM_END	(0xAF)
-
 enum lp855x_chip_id {
 	LP8550,
 	LP8551,
-- 
1.7.2.5


Best Regards,
Milo



