Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966204Ab2EOWYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:24:17 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:24834 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:24:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1337120651!6537108!14
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor comedi_parport driver and use module_comedi_driver
Date: Tue, 15 May 2012 15:23:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151523.53261.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/comedi_parport.c |   31 ++++++-----------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 21d834d..1172114 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -91,29 +91,6 @@ pin, which can be used to wake up tasks.
 #define PARPORT_B 1
 #define PARPORT_C 2
 
-static int parport_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int parport_detach(struct comedi_device *dev);
-static struct comedi_driver driver_parport = {
-	.driver_name = "comedi_parport",
-	.module = THIS_MODULE,
-	.attach = parport_attach,
-	.detach = parport_detach,
-};
-
-static int __init driver_parport_init_module(void)
-{
-	return comedi_driver_register(&driver_parport);
-}
-
-static void __exit driver_parport_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_parport);
-}
-
-module_init(driver_parport_init_module);
-module_exit(driver_parport_cleanup_module);
-
 struct parport_private {
 	unsigned int a_data;
 	unsigned int c_data;
@@ -408,6 +385,14 @@ static int parport_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver parport_driver = {
+	.driver_name	= "comedi_parport",
+	.module		= THIS_MODULE,
+	.attach		= parport_attach,
+	.detach		= parport_detach,
+};
+module_comedi_driver(parport_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
