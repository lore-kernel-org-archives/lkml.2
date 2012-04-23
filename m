Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2DWXUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:20:54 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:58809 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2DWXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:20:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1335223252!9460843!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor c6xdigio driver to remove forward declarations
Date: Mon, 23 Apr 2012 16:20:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231620.42103.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver variable to remove the need
or the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 11cdaf2..5f75351 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -97,16 +97,6 @@ union encvaluetype {
 
 #define C6XDIGIO_TIME_OUT 20
 
-static int c6xdigio_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int c6xdigio_detach(struct comedi_device *dev);
-struct comedi_driver driver_c6xdigio = {
-	.driver_name = "c6xdigio",
-	.module = THIS_MODULE,
-	.attach = c6xdigio_attach,
-	.detach = c6xdigio_detach,
-};
-
 static void C6X_pwmInit(unsigned long baseAddr)
 {
 	int timeout = 0;
@@ -518,17 +508,23 @@ static int c6xdigio_detach(struct comedi_device *dev)
 	return 0;
 }
 
+struct comedi_driver driver_c6xdigio = {
+	.driver_name	= "c6xdigio",
+	.module		= THIS_MODULE,
+	.attach		= c6xdigio_attach,
+	.detach		= c6xdigio_detach,
+};
+
 static int __init driver_c6xdigio_init_module(void)
 {
 	return comedi_driver_register(&driver_c6xdigio);
 }
+module_init(driver_c6xdigio_init_module);
 
 static void __exit driver_c6xdigio_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_c6xdigio);
 }
-
-module_init(driver_c6xdigio_init_module);
 module_exit(driver_c6xdigio_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
