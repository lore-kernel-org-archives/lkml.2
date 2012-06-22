Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2FVXOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:14:42 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:16902 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FVXOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:14:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1340406877!12252875!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/31] staging: comedi: ni_daq_700: consolidate the init and exit functions
Date: Fri, 22 Jun 2012 16:14:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221614.30744.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register/unregister of the pcmcia driver is done is separate
functions that are called by the module_{init,exit} routines.
Simplify the code a bit by moving the register/unregister into
the module_{init,exit} routines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 052a051..b06792b 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -439,23 +439,11 @@ static struct pcmcia_driver dio700_cs_driver = {
 	.name = "ni_daq_700",
 };
 
-static int __init init_dio700_cs(void)
-{
-	pcmcia_register_driver(&dio700_cs_driver);
-	return 0;
-}
-
-static void __exit exit_dio700_cs(void)
-{
-	pr_debug("ni_daq_700: unloading\n");
-	pcmcia_unregister_driver(&dio700_cs_driver);
-}
-
 static int __init dio700_cs_init(void)
 {
 	int ret;
 
-	ret = init_dio700_cs();
+	ret = pcmcia_register_driver(&dio700_cs_driver);
 	if (ret < 0)
 		return ret;
 
@@ -465,7 +453,7 @@ module_init(dio700_cs_init);
 
 static void __exit dio700_cs_exit(void)
 {
-	exit_dio700_cs();
+	pcmcia_unregister_driver(&dio700_cs_driver);
 	comedi_driver_unregister(&driver_dio700);
 }
 module_exit(dio700_cs_exit);
-- 
1.7.11

