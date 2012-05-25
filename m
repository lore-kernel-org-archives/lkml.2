Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2EYLId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:08:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763Ab2EYLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:08:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIZnv09bdWOb/2dsb2JhbABEtSOBB4IWAQUnUhBRVwYTiBG7OJBHA5UYiR6GUoJi
X-IronPort-AV: E=Sophos;i="4.75,656,1330902000"; 
   d="scan'208";a="995316716"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: ipack/devices/ipoctal: change pr_* usage for dev_* functions
Date: Fri, 25 May 2012 13:08:13 +0200
Message-Id: <1337944093-16963-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337944093-16963-1-git-send-email-siglesias@igalia.com>
References: <1337944093-16963-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index a6f424e..17aa35a 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -11,8 +11,6 @@
  * Software Foundation; version 2 of the License.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -116,7 +114,8 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	ipoctal = ipoctal_find_board(tty);
 
 	if (ipoctal == NULL) {
-		pr_err("Device not found. Major %d\n", tty->driver->major);
+		dev_err(tty->dev, "Device not found. Major %d\n",
+			tty->driver->major);
 		return -ENODEV;
 	}
 
@@ -136,7 +135,8 @@ static int ipoctal_open(struct tty_struct *tty, struct file *file)
 	ipoctal = ipoctal_find_board(tty);
 
 	if (ipoctal == NULL) {
-		pr_err("Device not found. Major %d\n", tty->driver->major);
+		dev_err(tty->dev, "Device not found. Major %d\n",
+			tty->driver->major);
 		return -ENODEV;
 	}
 
@@ -381,7 +381,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
 						IPACK_ID_SPACE);
 	if (res) {
-		pr_err("Unable to map slot [%d:%d] ID space!\n", bus_nr, slot);
+		dev_err(&ipoctal->dev->dev,
+			"Unable to map slot [%d:%d] ID space!\n",
+			bus_nr, slot);
 		return res;
 	}
 
@@ -396,14 +398,18 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
 						IPACK_IO_SPACE);
 	if (res) {
-		pr_err("Unable to map slot [%d:%d] IO space!\n", bus_nr, slot);
+		dev_err(&ipoctal->dev->dev,
+			"Unable to map slot [%d:%d] IO space!\n",
+			bus_nr, slot);
 		goto out_unregister_id_space;
 	}
 
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev,
 					   0x8000, IPACK_MEM_SPACE);
 	if (res) {
-		pr_err("Unable to map slot [%d:%d] MEM space!\n", bus_nr, slot);
+		dev_err(&ipoctal->dev->dev,
+			"Unable to map slot [%d:%d] MEM space!\n",
+			bus_nr, slot);
 		goto out_unregister_io_space;
 	}
 
@@ -472,7 +478,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	tty_set_operations(tty, &ipoctal_fops);
 	res = tty_register_driver(tty);
 	if (res) {
-		pr_err("Can't register tty driver.\n");
+		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
 		put_tty_driver(tty);
 		goto out_unregister_slot_unmap;
 	}
-- 
1.7.10

