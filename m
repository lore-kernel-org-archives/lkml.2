Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2FYWSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:18:39 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:56770 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2FYWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:18:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1340662716!20864701!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/33] staging: comedi: cb_das16_cs: add module_{init,exit} declarations
Date: Mon, 25 Jun 2012 15:18:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251518.18027.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init and exit functions for this module were being declared
as global symbols. Add the module_{init,exit} declarations and
make the functions static. Also, rename the functions so they
have namespace associated with the module.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 76833d0..bca4cbe 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -792,7 +792,7 @@ static void __exit exit_das16cs_pcmcia_cs(void)
 	pcmcia_unregister_driver(&das16cs_driver);
 }
 
-int __init init_module(void)
+static int __init das16cs_init(void)
 {
 	int ret;
 
@@ -802,12 +802,14 @@ int __init init_module(void)
 
 	return comedi_driver_register(&driver_das16cs);
 }
+module_init(das16cs_init);
 
-void __exit cleanup_module(void)
+static void __exit das16cs_exit(void)
 {
 	exit_das16cs_pcmcia_cs();
 	comedi_driver_unregister(&driver_das16cs);
 }
+module_exit(das16cs_exit);
 
 MODULE_AUTHOR("David A. Schleef <ds@schleef.org>");
 MODULE_DESCRIPTION("Comedi driver for Computer Boards PC-CARD DAS16/16");
-- 
1.7.11

