Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0JTG6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:58:01 -0400
Received: from mail.perches.com ([173.55.12.10]:3208 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758328Ab0JTGwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:07 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/32] drivers/hwmon/asb100.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:29 -0700
Message-Id: <a61e9f4678dd7d839b70599d829d6a6145e81034.1287556801.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <20101020035346.GA20178@ericsson.com>
References: <20101020035346.GA20178@ericsson.com>
In-Reply-To: <cover.1287556800.git.joe@perches.com>
References: <cover.1287556800.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Coalesced any long formats
Removed prefixes from formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/asb100.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index 7dada55..c02a052 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -36,6 +36,8 @@
     asb100	7	3	1	4	0x31	0x0694	yes	no
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -701,8 +703,7 @@ static int asb100_detect(struct i2c_client *client,
 	int val1, val2;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
-		pr_debug("asb100.o: detect failed, "
-				"smbus byte data not supported!\n");
+		pr_debug("detect failed, smbus byte data not supported!\n");
 		return -ENODEV;
 	}
 
@@ -715,7 +716,7 @@ static int asb100_detect(struct i2c_client *client,
 			(((!(val1 & 0x80)) && (val2 != 0x94)) ||
 			/* Check for ASB100 ID (high byte ) */
 			((val1 & 0x80) && (val2 != 0x06)))) {
-		pr_debug("asb100: detect failed, bad chip id 0x%02x!\n", val2);
+		pr_debug("detect failed, bad chip id 0x%02x!\n", val2);
 		return -ENODEV;
 	}
 
@@ -744,7 +745,7 @@ static int asb100_probe(struct i2c_client *client,
 
 	data = kzalloc(sizeof(struct asb100_data), GFP_KERNEL);
 	if (!data) {
-		pr_debug("asb100.o: probe failed, kzalloc failed!\n");
+		pr_debug("probe failed, kzalloc failed!\n");
 		err = -ENOMEM;
 		goto ERROR0;
 	}
-- 
1.7.3.1.g432b3.dirty

