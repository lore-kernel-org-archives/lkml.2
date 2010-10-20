Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0JTGwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:19 -0400
Received: from mail.perches.com ([173.55.12.10]:3251 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab0JTGwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:18 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/32] drivers/hwmon/smsc47m1.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:49 -0700
Message-Id: <93eb55a4b0015390c488cb8fad988c2cdd3a4686.1287556801.git.joe@perches.com>
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
 drivers/hwmon/smsc47m1.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index 8fa462f..f44a89a 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -26,6 +26,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
@@ -435,30 +437,29 @@ static int __init smsc47m1_find(unsigned short *addr,
 	 */
 	switch (val) {
 	case 0x51:
-		pr_info(DRVNAME ": Found SMSC LPC47B27x\n");
+		pr_info("Found SMSC LPC47B27x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x59:
-		pr_info(DRVNAME ": Found SMSC LPC47M10x/LPC47M112/LPC47M13x\n");
+		pr_info("Found SMSC LPC47M10x/LPC47M112/LPC47M13x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x5F:
-		pr_info(DRVNAME ": Found SMSC LPC47M14x\n");
+		pr_info("Found SMSC LPC47M14x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x60:
-		pr_info(DRVNAME ": Found SMSC LPC47M15x/LPC47M192/LPC47M997\n");
+		pr_info("Found SMSC LPC47M15x/LPC47M192/LPC47M997\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x6B:
 		if (superio_inb(SUPERIO_REG_DEVREV) & 0x80) {
-			pr_debug(DRVNAME ": "
-				 "Found SMSC LPC47M233, unsupported\n");
+			pr_debug("Found SMSC LPC47M233, unsupported\n");
 			superio_exit();
 			return -ENODEV;
 		}
 
-		pr_info(DRVNAME ": Found SMSC LPC47M292\n");
+		pr_info("Found SMSC LPC47M292\n");
 		sio_data->type = smsc47m2;
 		break;
 	default:
@@ -470,7 +471,7 @@ static int __init smsc47m1_find(unsigned short *addr,
 	*addr = (superio_inb(SUPERIO_REG_BASE) << 8)
 	      |  superio_inb(SUPERIO_REG_BASE + 1);
 	if (*addr == 0) {
-		pr_info(DRVNAME ": Device address not set, will not use\n");
+		pr_info("Device address not set, will not use\n");
 		superio_exit();
 		return -ENODEV;
 	}
@@ -479,7 +480,7 @@ static int __init smsc47m1_find(unsigned short *addr,
 	 * Compaq Presario S4000NX) */
 	sio_data->activate = superio_inb(SUPERIO_REG_ACT);
 	if ((sio_data->activate & 0x01) == 0) {
-		pr_info(DRVNAME ": Enabling device\n");
+		pr_info("Enabling device\n");
 		superio_outb(SUPERIO_REG_ACT, sio_data->activate | 0x01);
 	}
 
@@ -494,7 +495,7 @@ static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
 		superio_enter();
 		superio_select();
 
-		pr_info(DRVNAME ": Disabling device\n");
+		pr_info("Disabling device\n");
 		superio_outb(SUPERIO_REG_ACT, sio_data->activate);
 
 		superio_exit();
@@ -823,28 +824,26 @@ static int __init smsc47m1_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct smsc47m1_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
-- 
1.7.3.1.g432b3.dirty

