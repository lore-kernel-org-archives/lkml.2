Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab2FYWUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:20:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:17053 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2FYWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:20:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1340662781!24305095!38
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/33] staging: comedi: cb_das16_cs: consolidate the init and exit functions
Date: Mon, 25 Jun 2012 15:20:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251520.14022.hartleys@visionengravers.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index bca4cbe..624e005 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -780,23 +780,11 @@ struct pcmcia_driver das16cs_driver = {
 	.name = "cb_das16_cs",
 };
 
-static int __init init_das16cs_pcmcia_cs(void)
-{
-	pcmcia_register_driver(&das16cs_driver);
-	return 0;
-}
-
-static void __exit exit_das16cs_pcmcia_cs(void)
-{
-	pr_debug("das16cs_pcmcia_cs: unloading\n");
-	pcmcia_unregister_driver(&das16cs_driver);
-}
-
 static int __init das16cs_init(void)
 {
 	int ret;
 
-	ret = init_das16cs_pcmcia_cs();
+	ret = pcmcia_register_driver(&das16cs_driver);
 	if (ret < 0)
 		return ret;
 
@@ -806,7 +794,7 @@ module_init(das16cs_init);
 
 static void __exit das16cs_exit(void)
 {
-	exit_das16cs_pcmcia_cs();
+	pcmcia_unregister_driver(&das16cs_driver);
 	comedi_driver_unregister(&driver_das16cs);
 }
 module_exit(das16cs_exit);
-- 
1.7.11

