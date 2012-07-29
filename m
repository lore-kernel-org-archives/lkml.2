Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2G2LYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 07:24:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2G2LXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 07:23:52 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/2] pch_phub: use module_pci_driver
Date: Sun, 29 Jul 2012 17:08:30 +0545
Message-Id: <1343561010-15800-2-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343561010-15800-1-git-send-email-develkernel412222@gmail.com>
References: <1343561010-15800-1-git-send-email-develkernel412222@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this driver's pch_phub_pci_init, and pch_phub_pci_exit functions with
the module_init and module_exit calls can be replaced with
module_pci_driver

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/misc/pch_phub.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index e2c066e..c9f20da 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -893,18 +893,7 @@ static struct pci_driver pch_phub_driver = {
 	.resume = pch_phub_resume
 };
 
-static int __init pch_phub_pci_init(void)
-{
-	return pci_register_driver(&pch_phub_driver);
-}
-
-static void __exit pch_phub_pci_exit(void)
-{
-	pci_unregister_driver(&pch_phub_driver);
-}
-
-module_init(pch_phub_pci_init);
-module_exit(pch_phub_pci_exit);
+module_pci_driver(pch_phub_driver);
 
 MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7223) PHUB");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

