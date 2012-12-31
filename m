Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2LaSh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 13:37:59 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45928 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2LaShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 13:37:55 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: John Ogness <john.ogness@linutronix.de>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] uio: uio_sercos3: use module_pci_driver macro
Date: Mon, 31 Dec 2012 13:37:48 -0500
Message-Id: <1356979068-15915-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_pci_driver macro and simplify the module init and exit code

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/uio/uio_sercos3.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 81a10a5..5419832 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -226,19 +226,7 @@ static struct pci_driver sercos3_pci_driver = {
 	.remove = sercos3_pci_remove,
 };
 
-static int __init sercos3_init_module(void)
-{
-	return pci_register_driver(&sercos3_pci_driver);
-}
-
-static void __exit sercos3_exit_module(void)
-{
-	pci_unregister_driver(&sercos3_pci_driver);
-}
-
-module_init(sercos3_init_module);
-module_exit(sercos3_exit_module);
-
+module_pci_driver(sercos3_pci_driver);
 MODULE_DESCRIPTION("UIO driver for the Automata Sercos III PCI card");
 MODULE_AUTHOR("John Ogness <john.ogness@linutronix.de>");
 MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

