Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2GJGpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:45:36 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54084 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2GJGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:45:34 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Ben Collins <bcollins@bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Miller <amiller@amilx.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 5/6] staging/media/solo6x10: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:15:26 +0530
Message-Id: <1341902726-22580-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the driver duplicates the module_pci_driver code,
how?
	module_pci_driver is used for those drivers whose
	init and exit paths does only register and unregister
	to pci API and nothing else.

so use the module_pci_driver macro instead

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/media/solo6x10/core.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index d2fd842..3ee9b12 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -318,15 +318,4 @@ static struct pci_driver solo_pci_driver = {
 	.remove = solo_pci_remove,
 };
 
-static int __init solo_module_init(void)
-{
-	return pci_register_driver(&solo_pci_driver);
-}
-
-static void __exit solo_module_exit(void)
-{
-	pci_unregister_driver(&solo_pci_driver);
-}
-
-module_init(solo_module_init);
-module_exit(solo_module_exit);
+module_pci_driver(solo_pci_driver);
-- 
1.7.9.5

