Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0ILPkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:40:05 -0400
Received: from lo.gmane.org ([80.91.229.12]:43824 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab0ILPkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:40:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Heiko Bauke <heiko.bauke@snafu.de>
Subject: [PATCH] net: plusb.c
Date: Sun, 12 Sep 2010 17:27:14 +0200
Message-ID: <20100912172714.3f4dd401@tron.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/sZ6Vtx9EnA5Of7F6IQGo04j"
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p54abac24.dip.t-dialin.net
X-Newsreader: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/sZ6Vtx9EnA5Of7F6IQGo04j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear Kernel-Developers,

note that the plusb.c driver for Prolific PL-2301/2302 USB Host to Host
Link Driver may be used also for Prolific PL-2501 devices if a rather
trivial patch is applied to plusb.c.


	Regards,

	Heiko



-- 
--  Cluster Computing @ http://www.clustercomputing.de
-- Number Crunch Blog @ http://numbercrunch.de
--        Heiko Bauke @ http://www.mpi-hd.mpg.de/personalhomes/bauke

--MP_/sZ6Vtx9EnA5Of7F6IQGo04j
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=plusb.patch

diff -urN linux_orig/drivers/net/usb/plusb.c linux_new/drivers/net/usb/plusb.c
--- linux_orig/drivers/net/usb/plusb.c	2010-09-12 17:07:08.377086065 +0200
+++ linux_new/drivers/net/usb/plusb.c	2010-09-12 17:10:06.088880446 +0200
@@ -1,5 +1,5 @@
 /*
- * PL-2301/2302 USB host-to-host link cables
+ * PL-2301/2302/2501 USB host-to-host link cables
  * Copyright (C) 2000-2005 by David Brownell
  *
  * This program is free software; you can redistribute it and/or modify
@@ -32,7 +32,7 @@
 
 
 /*
- * Prolific PL-2301/PL-2302 driver ... http://www.prolifictech.com
+ * Prolific PL-2301/2302/2501 driver ... http://www.prolifictech.com
  *
  * The protocol and handshaking used here should be bug-compatible
  * with the Linux 2.2 "plusb" driver, by Deti Fliegl.
@@ -95,7 +95,7 @@
 }
 
 static const struct driver_info	prolific_info = {
-	.description =	"Prolific PL-2301/PL-2302",
+	.description =	"Prolific PL-2301/2302/2501",
 	.flags =	FLAG_NO_SETINT,
 		/* some PL-2302 versions seem to fail usb_set_interface() */
 	.reset =	pl_reset,
@@ -117,6 +117,9 @@
 }, {
 	USB_DEVICE(0x067b, 0x0001),	// PL-2302
 	.driver_info =	(unsigned long) &prolific_info,
+}, {
+	USB_DEVICE(0x067b, 0x2501),	// PL-2501
+	.driver_info =	(unsigned long) &prolific_info,
 },
 
 	{ },		// END
@@ -145,5 +148,5 @@
 module_exit(plusb_exit);
 
 MODULE_AUTHOR("David Brownell");
-MODULE_DESCRIPTION("Prolific PL-2301/2302 USB Host to Host Link Driver");
+MODULE_DESCRIPTION("Prolific PL-2301/2302/2501 USB Host to Host Link Driver");
 MODULE_LICENSE("GPL");

--MP_/sZ6Vtx9EnA5Of7F6IQGo04j--


