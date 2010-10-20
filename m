Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0JTGwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3224 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab0JTGwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:11 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/32] drivers/hwmon/hwmon.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:37 -0700
Message-Id: <d657ce6b56427cd2cce069275ec162da1815b196.1287556801.git.joe@perches.com>
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
 drivers/hwmon/hwmon.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 29ea675..a61e781 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -10,6 +10,8 @@
     the Free Software Foundation; version 2 of the License.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -119,7 +121,7 @@ static int __init hwmon_init(void)
 
 	hwmon_class = class_create(THIS_MODULE, "hwmon");
 	if (IS_ERR(hwmon_class)) {
-		printk(KERN_ERR "hwmon.c: couldn't create sysfs class\n");
+		pr_err("couldn't create sysfs class\n");
 		return PTR_ERR(hwmon_class);
 	}
 	return 0;
-- 
1.7.3.1.g432b3.dirty

