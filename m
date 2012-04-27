Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2D0XcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:32:06 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:42805 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab2D0XcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:32:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1335569521!4205866!10
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl724 driver to remove the forward declarations
Date: Fri, 27 Apr 2012 16:31:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271631.58895.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 20715d1..7d0a306 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -56,10 +56,6 @@ See the source for configuration details.
 
 /* #define PCL724_IRQ   1  no IRQ support now */
 
-static int pcl724_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl724_detach(struct comedi_device *dev);
-
 struct pcl724_board {
 
 	const char *name;	/*  board name */
@@ -71,40 +67,8 @@ struct pcl724_board {
 	char is_pet48;
 };
 
-static const struct pcl724_board boardtypes[] = {
-	{"pcl724", 24, 1, 0x00fc, PCL724_SIZE, 0, 0,},
-	{"pcl722", 144, 6, 0x00fc, PCL722_SIZE, 1, 0,},
-	{"pcl731", 48, 2, 0x9cfc, PCL731_SIZE, 0, 0,},
-	{"acl7122", 144, 6, 0x9ee8, PCL722_SIZE, 1, 0,},
-	{"acl7124", 24, 1, 0x00fc, PCL724_SIZE, 0, 0,},
-	{"pet48dio", 48, 2, 0x9eb8, PET48_SIZE, 0, 1,},
-};
-
 #define this_board ((const struct pcl724_board *)dev->board_ptr)
 
-static struct comedi_driver driver_pcl724 = {
-	.driver_name = "pcl724",
-	.module = THIS_MODULE,
-	.attach = pcl724_attach,
-	.detach = pcl724_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl724_board),
-};
-
-static int __init driver_pcl724_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl724);
-}
-
-static void __exit driver_pcl724_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl724);
-}
-
-module_init(driver_pcl724_init_module);
-module_exit(driver_pcl724_cleanup_module);
-
 static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
 {
 	unsigned long iobase = arg;
@@ -232,6 +196,37 @@ static int pcl724_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcl724_board boardtypes[] = {
+	{ "pcl724", 24, 1, 0x00fc, PCL724_SIZE, 0, 0, },
+	{ "pcl722", 144, 6, 0x00fc, PCL722_SIZE, 1, 0, },
+	{ "pcl731", 48, 2, 0x9cfc, PCL731_SIZE, 0, 0, },
+	{ "acl7122", 144, 6, 0x9ee8, PCL722_SIZE, 1, 0, },
+	{ "acl7124", 24, 1, 0x00fc, PCL724_SIZE, 0, 0, },
+	{ "pet48dio", 48, 2, 0x9eb8, PET48_SIZE, 0, 1, },
+};
+
+static struct comedi_driver driver_pcl724 = {
+	.driver_name	= "pcl724",
+	.module		= THIS_MODULE,
+	.attach		= pcl724_attach,
+	.detach		= pcl724_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl724_board),
+};
+
+static int __init driver_pcl724_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl724);
+}
+module_init(driver_pcl724_init_module);
+
+static void __exit driver_pcl724_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl724);
+}
+module_exit(driver_pcl724_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
