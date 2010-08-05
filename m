Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab0HEHaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:30:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2275 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881Ab0HEH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:56 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] drivers/input/tablet: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:48 -0700
Message-Id: <fcdf137fd3ea0fc78ea2f13192805cc003b3558f.1280992119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/tablet/acecad.c    |    5 +++--
 drivers/input/tablet/aiptek.c    |    7 ++++---
 drivers/input/tablet/gtco.c      |    2 +-
 drivers/input/tablet/kbtab.c     |    5 +++--
 drivers/input/tablet/wacom_sys.c |    7 ++++---
 drivers/input/tablet/wacom_wac.c |    8 ++++++--
 6 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index aea9a93..bf95597 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -272,8 +274,7 @@ static int __init usb_acecad_init(void)
 {
 	int result = usb_register(&usb_acecad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 	return result;
 }
 
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 57b25b8..11f1c09 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -70,6 +70,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -1924,9 +1926,8 @@ static int __init aiptek_init(void)
 {
 	int result = usb_register(&aiptek_driver);
 	if (result == 0) {
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_AUTHOR "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
+		pr_info(DRIVER_AUTHOR "\n");
 	}
 	return result;
 }
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 8ea6afe..822941f 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -1035,7 +1035,7 @@ static int __init gtco_init(void)
 		return error;
 	}
 
-	printk("GTCO usb driver version: %s", GTCO_VERSION);
+	pr_info("GTCO usb driver version: %s\n", GTCO_VERSION);
 	return 0;
 }
 
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 290f4e5..18a4878 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -204,8 +206,7 @@ static int __init kbtab_init(void)
 	retval = usb_register(&kbtab_driver);
 	if (retval)
 		goto out;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 out:
 	return retval;
 }
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 42ba369..0b888a0 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -11,6 +11,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "wacom_wac.h"
 #include "wacom.h"
 
@@ -343,7 +345,7 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	if (usb_get_extra_descriptor(interface, HID_DEVICET_HID, &hid_desc)) {
 		if (usb_get_extra_descriptor(&interface->endpoint[0],
 				HID_DEVICET_REPORT, &hid_desc)) {
-			printk("wacom: can not retrieve extra class descriptor\n");
+			pr_info("can not retrieve extra class descriptor\n");
 			error = 1;
 			goto out;
 		}
@@ -610,8 +612,7 @@ static int __init wacom_init(void)
 
 	result = usb_register(&wacom_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 	return result;
 }
 
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 40d77ba..c9df214 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -12,6 +12,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "wacom_wac.h"
 #include "wacom.h"
 
@@ -51,7 +53,8 @@ static int wacom_penpartner_irq(struct wacom_wac *wacom)
 		break;
 
 	default:
-		printk(KERN_INFO "wacom_penpartner_irq: received unknown report #%d\n", data[0]);
+		pr_info("%s(): received unknown report #%d\n",
+			__func__, data[0]);
 		return 0;
         }
 
@@ -136,7 +139,8 @@ static int wacom_ptu_irq(struct wacom_wac *wacom)
 	struct input_dev *input = wacom->input;
 
 	if (data[0] != WACOM_REPORT_PENABLED) {
-		printk(KERN_INFO "wacom_ptu_irq: received unknown report #%d\n", data[0]);
+		pr_info("%s(): received unknown report #%d\n",
+			__func__, data[0]);
 		return 0;
 	}
 
-- 
1.7.2.19.g9a302

