Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0JTG5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:57:20 -0400
Received: from mail.perches.com ([173.55.12.10]:3215 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab0JTGwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:08 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/32] drivers/hwmon/coretemp.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:31 -0700
Message-Id: <78de63116e59236eb0f4eaf7143760dc0fa9c9b2.1287556801.git.joe@perches.com>
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
 drivers/hwmon/coretemp.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42de98d..194ca0a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -20,6 +20,8 @@
  * 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -445,8 +447,8 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 	 * without thermal sensors will be filtered out.
 	 */
 	if (!cpu_has(c, X86_FEATURE_DTS)) {
-		printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
-		       " has no thermal sensor.\n", c->x86_model);
+		pr_info("CPU (model=0x%x) has no thermal sensor\n",
+			c->x86_model);
 		return 0;
 	}
 
@@ -466,7 +468,7 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -478,8 +480,7 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_free;
 	}
 
-- 
1.7.3.1.g432b3.dirty

