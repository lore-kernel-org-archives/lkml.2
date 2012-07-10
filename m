Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GJGlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:41:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2GJGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:41:12 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/6] staging/et131x: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:11:03 +0530
Message-Id: <1341902463-22171-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove code duplicating module_pci_driver
and also the obvious comments about the _init and _exit points.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/et131x/et131x.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 8f3fc5f..ac6897b 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -5445,24 +5445,4 @@ static struct pci_driver et131x_driver = {
 	.driver.pm	= ET131X_PM_OPS,
 };
 
-/**
- * et131x_init_module - The "main" entry point called on driver initialization
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-static int __init et131x_init_module(void)
-{
-	return pci_register_driver(&et131x_driver);
-}
-
-/**
- * et131x_cleanup_module - The entry point called on driver cleanup
- */
-static void __exit et131x_cleanup_module(void)
-{
-	pci_unregister_driver(&et131x_driver);
-}
-
-module_init(et131x_init_module);
-module_exit(et131x_cleanup_module);
-
+module_pci_driver(et131x_driver);
-- 
1.7.9.5

