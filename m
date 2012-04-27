Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2D0WyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:54:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54758 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2D0WyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:54:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1335567249!9926672!3
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcm3724 driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:54:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271554.01382.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 4601703..88a354b 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -62,10 +62,6 @@ Copy/pasted/hacked from pcm724.c
 #define CR_A_MODE(a)	((a)<<5)
 #define CR_CW		0x80
 
-static int pcm3724_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pcm3724_detach(struct comedi_device *dev);
-
 struct pcm3724_board {
 	const char *name;	/*  driver name */
 	int dio;		/*  num of DIO */
@@ -80,35 +76,8 @@ struct priv_pcm3724 {
 	int dio_2;
 };
 
-static const struct pcm3724_board boardtypes[] = {
-	{"pcm3724", 48, 2, 0x00fc, PCM3724_SIZE,},
-};
-
 #define this_board ((const struct pcm3724_board *)dev->board_ptr)
 
-static struct comedi_driver driver_pcm3724 = {
-	.driver_name = "pcm3724",
-	.module = THIS_MODULE,
-	.attach = pcm3724_attach,
-	.detach = pcm3724_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcm3724_board),
-};
-
-static int __init driver_pcm3724_init_module(void)
-{
-	return comedi_driver_register(&driver_pcm3724);
-}
-
-static void __exit driver_pcm3724_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcm3724);
-}
-
-module_init(driver_pcm3724_init_module);
-module_exit(driver_pcm3724_cleanup_module);
-
 /* (setq c-basic-offset 8) */
 
 static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
@@ -318,6 +287,32 @@ static int pcm3724_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcm3724_board boardtypes[] = {
+	{ "pcm3724", 48, 2, 0x00fc, PCM3724_SIZE, },
+};
+
+static struct comedi_driver driver_pcm3724 = {
+	.driver_name	= "pcm3724",
+	.module		= THIS_MODULE,
+	.attach		= pcm3724_attach,
+	.detach		= pcm3724_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcm3724_board),
+};
+
+static int __init driver_pcm3724_init_module(void)
+{
+	return comedi_driver_register(&driver_pcm3724);
+}
+module_init(driver_pcm3724_init_module);
+
+static void __exit driver_pcm3724_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcm3724);
+}
+module_exit(driver_pcm3724_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
