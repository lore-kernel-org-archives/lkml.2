Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2DWVvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:51:05 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:4136 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2DWVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:51:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1335217861!4587718!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor the acl7225b driver to remove the forward declarations
Date: Mon, 23 Apr 2012 14:50:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231450.40268.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and struct boardtype variables to the end
of the source. This is more typical of how other drivers are
written and removes the need to the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index f4a301a..ef685fc 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -22,45 +22,13 @@ Devices: [Adlink] ACL-7225b (acl7225b), [ICP] P16R16DIO (p16r16dio)
 #define ACL7225_DI_LO  2	/* Digital input low byte (DI0-DI7) */
 #define ACL7225_DI_HI  3	/* Digital input high byte (DI8-DI15) */
 
-static int acl7225b_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int acl7225b_detach(struct comedi_device *dev);
-
 struct boardtype {
 	const char *name;	/*  driver name */
 	int io_range;		/*  len of I/O space */
 };
 
-static const struct boardtype boardtypes[] = {
-	{"acl7225b", ACL7225_SIZE,},
-	{"p16r16dio", P16R16DIO_SIZE,},
-};
-
 #define this_board ((const struct boardtype *)dev->board_ptr)
 
-static struct comedi_driver driver_acl7225b = {
-	.driver_name = "acl7225b",
-	.module = THIS_MODULE,
-	.attach = acl7225b_attach,
-	.detach = acl7225b_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct boardtype),
-};
-
-static int __init driver_acl7225b_init_module(void)
-{
-	return comedi_driver_register(&driver_acl7225b);
-}
-
-static void __exit driver_acl7225b_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_acl7225b);
-}
-
-module_init(driver_acl7225b_init_module);
-module_exit(driver_acl7225b_cleanup_module);
-
 static int acl7225b_do_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -161,6 +129,33 @@ static int acl7225b_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct boardtype boardtypes[] = {
+	{ "acl7225b", ACL7225_SIZE, },
+	{ "p16r16dio", P16R16DIO_SIZE, },
+};
+
+static struct comedi_driver driver_acl7225b = {
+	.driver_name	= "acl7225b",
+	.module		= THIS_MODULE,
+	.attach		= acl7225b_attach,
+	.detach		= acl7225b_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct boardtype),
+};
+
+static int __init driver_acl7225b_init_module(void)
+{
+	return comedi_driver_register(&driver_acl7225b);
+}
+module_init(driver_acl7225b_init_module);
+
+static void __exit driver_acl7225b_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_acl7225b);
+}
+module_exit(driver_acl7225b_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
