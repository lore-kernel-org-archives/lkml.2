Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2HGUEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:04:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49895 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2HGT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:56:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 29/41] TTY: synclink_cs, final cleanup in synclink_cs_init
Date: Tue,  7 Aug 2012 21:47:54 +0200
Message-Id: <1344368886-24033-30-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* use <tab> for indentation
* add KERN_* to printks
* no more assignments in if's like if ((rc = function()))

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/pcmcia/synclink_cs.c |   65 ++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index ce277f7..923c3a4 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2803,47 +2803,46 @@ static const struct tty_operations mgslpc_ops = {
 
 static int __init synclink_cs_init(void)
 {
-    int rc;
+	int rc;
 
-    if (break_on_load) {
-	    mgslpc_get_text_ptr();
-	    BREAKPOINT();
-    }
+	if (break_on_load) {
+		mgslpc_get_text_ptr();
+		BREAKPOINT();
+	}
 
-    serial_driver = tty_alloc_driver(MAX_DEVICE_COUNT,
-		    TTY_DRIVER_REAL_RAW |
-		    TTY_DRIVER_DYNAMIC_DEV);
-    if (!serial_driver) {
-	    rc = -ENOMEM;
-	    goto err;
-    }
+	serial_driver = tty_alloc_driver(MAX_DEVICE_COUNT,
+			TTY_DRIVER_REAL_RAW |
+			TTY_DRIVER_DYNAMIC_DEV);
+	if (!serial_driver) {
+		rc = -ENOMEM;
+		goto err;
+	}
 
-    /* Initialize the tty_driver structure */
-
-    serial_driver->driver_name = "synclink_cs";
-    serial_driver->name = "ttySLP";
-    serial_driver->major = ttymajor;
-    serial_driver->minor_start = 64;
-    serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
-    serial_driver->subtype = SERIAL_TYPE_NORMAL;
-    serial_driver->init_termios = tty_std_termios;
-    serial_driver->init_termios.c_cflag =
-	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-    tty_set_operations(serial_driver, &mgslpc_ops);
-
-    if ((rc = tty_register_driver(serial_driver)) < 0) {
-	    printk("%s(%d):Couldn't register serial driver\n",
-		   __FILE__,__LINE__);
-	    goto err_put_tty;
-    }
+	/* Initialize the tty_driver structure */
+	serial_driver->driver_name = "synclink_cs";
+	serial_driver->name = "ttySLP";
+	serial_driver->major = ttymajor;
+	serial_driver->minor_start = 64;
+	serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	serial_driver->subtype = SERIAL_TYPE_NORMAL;
+	serial_driver->init_termios = tty_std_termios;
+	serial_driver->init_termios.c_cflag =
+	B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty_set_operations(serial_driver, &mgslpc_ops);
+
+	rc = tty_register_driver(serial_driver);
+	if (rc < 0) {
+		printk(KERN_ERR "%s(%d):Couldn't register serial driver\n",
+				__FILE__, __LINE__);
+		goto err_put_tty;
+	}
 
 	rc = pcmcia_register_driver(&mgslpc_driver);
 	if (rc < 0)
 		goto err_unreg_tty;
 
-    printk("%s %s, tty major#%d\n",
-	   driver_name, driver_version,
-	   serial_driver->major);
+	printk(KERN_INFO "%s %s, tty major#%d\n", driver_name, driver_version,
+			serial_driver->major);
 
 	return 0;
 err_unreg_tty:
-- 
1.7.10.4


