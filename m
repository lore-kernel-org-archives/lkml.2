Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2GJFtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:49:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2GJFtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:49:22 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/sm7xxfb: use module_pci_driver macro
Date: Tue, 10 Jul 2012 11:19:14 +0530
Message-Id: <1341899355-17387-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as the manual of module_pci_driver says that
it can be used when the init and exit functions of
the module does nothing but the pci_register_driver
and pci_unregister_driver.

use it for the sm7xxfb driver, as the driver does nothing in
its _init and _exit functions but the register and unregister.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index e3511ec..0c0b603 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -1058,18 +1058,7 @@ static struct pci_driver smtcfb_driver = {
 	.driver.pm  = SM7XX_PM_OPS,
 };
 
-static int __init smtcfb_init(void)
-{
-	return pci_register_driver(&smtcfb_driver);
-}
-
-static void __exit smtcfb_exit(void)
-{
-	pci_unregister_driver(&smtcfb_driver);
-}
-
-module_init(smtcfb_init);
-module_exit(smtcfb_exit);
+module_pci_driver(smtcfb_driver);
 
 MODULE_AUTHOR("Siliconmotion ");
 MODULE_DESCRIPTION("Framebuffer driver for SMI Graphic Cards");
-- 
1.7.9.5

