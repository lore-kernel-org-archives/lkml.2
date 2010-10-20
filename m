Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0JTGxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:53:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3256 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0JTGwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:18 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/32] drivers/hwmon/via-cputemp.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:50 -0700
Message-Id: <bd2bd159db94be1cfdb2bc176d3a5bb2705f79ef.1287556801.git.joe@perches.com>
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
 drivers/hwmon/via-cputemp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index ec7fad7..45b08c7 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -21,6 +21,8 @@
  * 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -202,7 +204,7 @@ static int __cpuinit via_cputemp_device_add(unsigned int cpu)
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -214,8 +216,7 @@ static int __cpuinit via_cputemp_device_add(unsigned int cpu)
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_free;
 	}
 
@@ -295,8 +296,7 @@ static int __init via_cputemp_init(void)
 			continue;
 
 		if (c->x86_model > 0x0f) {
-			printk(KERN_WARNING DRVNAME ": Unknown CPU "
-				"model 0x%x\n", c->x86_model);
+			pr_warn("Unknown CPU model 0x%x\n", c->x86_model);
 			continue;
 		}
 
-- 
1.7.3.1.g432b3.dirty

