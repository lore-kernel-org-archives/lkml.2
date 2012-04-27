Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2D0Vsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:48:35 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:65422 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2D0Vse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:48:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1335563300!4195659!28
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor rti802 driver to remove forward declarations
Date: Fri, 27 Apr 2012 14:48:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271448.28787.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index f59cb11..21baf1a 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -47,29 +47,6 @@ Configuration Options:
 #define RTI802_DATALOW 1
 #define RTI802_DATAHIGH 2
 
-static int rti802_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int rti802_detach(struct comedi_device *dev);
-static struct comedi_driver driver_rti802 = {
-	.driver_name = "rti802",
-	.module = THIS_MODULE,
-	.attach = rti802_attach,
-	.detach = rti802_detach,
-};
-
-static int __init driver_rti802_init_module(void)
-{
-	return comedi_driver_register(&driver_rti802);
-}
-
-static void __exit driver_rti802_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_rti802);
-}
-
-module_init(driver_rti802_init_module);
-module_exit(driver_rti802_cleanup_module);
-
 struct rti802_private {
 	enum {
 		dac_2comp, dac_straight
@@ -162,6 +139,25 @@ static int rti802_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_rti802 = {
+	.driver_name	= "rti802",
+	.module		= THIS_MODULE,
+	.attach		= rti802_attach,
+	.detach		= rti802_detach,
+};
+
+static int __init driver_rti802_init_module(void)
+{
+	return comedi_driver_register(&driver_rti802);
+}
+module_init(driver_rti802_init_module);
+
+static void __exit driver_rti802_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_rti802);
+}
+module_exit(driver_rti802_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
