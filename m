Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab0JTG5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:57:18 -0400
Received: from mail.perches.com ([173.55.12.10]:3218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359Ab0JTGwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:08 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Juerg Haefliger <juergh@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/32] drivers/hwmon/dme1737.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:32 -0700
Message-Id: <cd6d2bea37cda67b4a06436e011fedf32351352b.1287556801.git.joe@perches.com>
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
 drivers/hwmon/dme1737.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 980c17d..e9a610b 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -25,6 +25,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -2446,7 +2448,7 @@ static int __init dme1737_isa_detect(int sio_cip, unsigned short *addr)
 	/* Get the base address of the runtime registers */
 	if (!(base_addr = (dme1737_sio_inb(sio_cip, 0x60) << 8) |
 			   dme1737_sio_inb(sio_cip, 0x61))) {
-		printk(KERN_ERR "dme1737: Base address not set.\n");
+		pr_err("Base address not set\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -2475,20 +2477,18 @@ static int __init dme1737_isa_device_add(unsigned short addr)
 		goto exit;
 
 	if (!(pdev = platform_device_alloc("dme1737", addr))) {
-		printk(KERN_ERR "dme1737: Failed to allocate device.\n");
+		pr_err("Failed to allocate device\n");
 		err = -ENOMEM;
 		goto exit;
 	}
 
 	if ((err = platform_device_add_resources(pdev, &res, 1))) {
-		printk(KERN_ERR "dme1737: Failed to add device resource "
-		       "(err = %d).\n", err);
+		pr_err("Failed to add device resource (err = %d)\n", err);
 		goto exit_device_put;
 	}
 
 	if ((err = platform_device_add(pdev))) {
-		printk(KERN_ERR "dme1737: Failed to add device (err = %d).\n",
-		       err);
+		pr_err("Failed to add device (err = %d)\n", err);
 		goto exit_device_put;
 	}
 
-- 
1.7.3.1.g432b3.dirty

