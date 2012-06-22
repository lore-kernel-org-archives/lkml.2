Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab2FVXNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:13:34 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:42413 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2FVXNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:13:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1340406811!13209462!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/31] staging: comedi: ni_daq_700: add the module_{init,exit} declarations
Date: Fri, 22 Jun 2012 16:13:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221613.26785.hartleys@visionengravers.com>
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
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index e75bdd0..052a051 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -451,7 +451,7 @@ static void __exit exit_dio700_cs(void)
 	pcmcia_unregister_driver(&dio700_cs_driver);
 }
 
-int __init init_module(void)
+static int __init dio700_cs_init(void)
 {
 	int ret;
 
@@ -461,12 +461,14 @@ int __init init_module(void)
 
 	return comedi_driver_register(&driver_dio700);
 }
+module_init(dio700_cs_init);
 
-void __exit cleanup_module(void)
+static void __exit dio700_cs_exit(void)
 {
 	exit_dio700_cs();
 	comedi_driver_unregister(&driver_dio700);
 }
+module_exit(dio700_cs_exit);
 
 MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
 MODULE_DESCRIPTION(
-- 
1.7.11

