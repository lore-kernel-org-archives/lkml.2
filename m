Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1C2WWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:31 -0400
Received: from mail.perches.com ([173.55.12.10]:4366 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1C2WW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:26 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Frank Seidel <frank@f-seidel.de>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/23] hdaps: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:40 -0700
Message-Id: <f4fbd2191533fd96fa59ba19c9917ed679920e1b.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added pr_fmt, converted printks and removed
hard coded prefixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/hdaps.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 067bf36..5a34973 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -26,6 +26,8 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
@@ -238,7 +240,7 @@ static int hdaps_device_init(void)
 		     __check_latch(0x1611, 0x01))
 		goto out;
 
-	printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x).\n",
+	printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x)\n",
 	       __get_latch(0x1611));
 
 	outb(0x17, 0x1610);
@@ -299,7 +301,7 @@ static int hdaps_probe(struct platform_device *dev)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "hdaps: device successfully initialized.\n");
+	pr_info("device successfully initialized\n");
 	return 0;
 }
 
@@ -480,7 +482,7 @@ static struct attribute_group hdaps_attribute_group = {
 /* hdaps_dmi_match - found a match.  return one, short-circuiting the hunt. */
 static int __init hdaps_dmi_match(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO "hdaps: %s detected.\n", id->ident);
+	pr_info("%s detected\n", id->ident);
 	return 1;
 }
 
@@ -488,8 +490,7 @@ static int __init hdaps_dmi_match(const struct dmi_system_id *id)
 static int __init hdaps_dmi_match_invert(const struct dmi_system_id *id)
 {
 	hdaps_invert = (unsigned long)id->driver_data;
-	printk(KERN_INFO "hdaps: inverting axis (%u) readings.\n",
-	       hdaps_invert);
+	pr_info("inverting axis (%u) readings\n", hdaps_invert);
 	return hdaps_dmi_match(id);
 }
 
@@ -543,7 +544,7 @@ static int __init hdaps_init(void)
 	int ret;
 
 	if (!dmi_check_system(hdaps_whitelist)) {
-		printk(KERN_WARNING "hdaps: supported laptop not found!\n");
+		pr_warn("supported laptop not found!\n");
 		ret = -ENODEV;
 		goto out;
 	}
@@ -595,7 +596,7 @@ static int __init hdaps_init(void)
 	if (ret)
 		goto out_idev;
 
-	printk(KERN_INFO "hdaps: driver successfully loaded.\n");
+	pr_info("driver successfully loaded\n");
 	return 0;
 
 out_idev:
@@ -609,7 +610,7 @@ out_driver:
 out_region:
 	release_region(HDAPS_LOW_PORT, HDAPS_NR_PORTS);
 out:
-	printk(KERN_WARNING "hdaps: driver init failed (ret=%d)!\n", ret);
+	pr_warn("driver init failed (ret=%d)!\n", ret);
 	return ret;
 }
 
@@ -622,7 +623,7 @@ static void __exit hdaps_exit(void)
 	platform_driver_unregister(&hdaps_driver);
 	release_region(HDAPS_LOW_PORT, HDAPS_NR_PORTS);
 
-	printk(KERN_INFO "hdaps: driver unloaded.\n");
+	pr_info("driver unloaded\n");
 }
 
 module_init(hdaps_init);
-- 
1.7.4.2.g597a6.dirty

