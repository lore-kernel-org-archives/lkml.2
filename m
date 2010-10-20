Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0JTGwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:15 -0400
Received: from mail.perches.com ([173.55.12.10]:3222 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758402Ab0JTGwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:10 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/32] drivers/hwmon/hp_accel.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:35 -0700
Message-Id: <a6d44b515f7e22737ee2e9b6f5449ea44ed19dc0.1287556801.git.joe@perches.com>
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
 drivers/hwmon/hp_accel.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index a56a784..3d21fa2 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -147,7 +149,7 @@ int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
 	lis3_dev.ac = *((union axis_conversion *)dmi->driver_data);
-	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
+	pr_info("hardware type %s found\n", dmi->ident);
 
 	return 1;
 }
@@ -303,11 +305,10 @@ static int lis3lv02d_add(struct acpi_device *device)
 
 	/* If possible use a "standard" axes order */
 	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
-		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
-		       lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
+		pr_info("Using custom axes %d,%d,%d\n",
+			lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
 	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
-		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
-				 "using default axes configuration\n");
+		pr_info("laptop model unknown, using default axes configuration\n");
 		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
 
@@ -385,7 +386,7 @@ static int __init lis3lv02d_init_module(void)
 	if (ret < 0)
 		return ret;
 
-	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+	pr_info("driver loaded\n");
 
 	return 0;
 }
-- 
1.7.3.1.g432b3.dirty

