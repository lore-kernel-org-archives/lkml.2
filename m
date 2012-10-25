Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935978Ab2JYQ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:57:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61020 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935964Ab2JYQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:57:28 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC 2/3] ahci_platform: convert to module_platform_driver
Date: Thu, 25 Oct 2012 09:56:00 -0700
Message-Id: <1351184161-31433-3-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
References: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ahci_platform driver can now use the module_platform_driver() macro.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/ata/ahci_platform.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index f467ba8..d9fbd10 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -298,18 +298,7 @@ static struct platform_driver ahci_driver = {
 	},
 	.id_table	= ahci_devtype,
 };
-
-static int __init ahci_init(void)
-{
-	return platform_driver_register(&ahci_driver);
-}
-module_init(ahci_init);
-
-static void __exit ahci_exit(void)
-{
-	platform_driver_unregister(&ahci_driver);
-}
-module_exit(ahci_exit);
+module_platform_driver(ahci_driver);
 
 MODULE_DESCRIPTION("AHCI SATA platform driver");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
-- 
1.7.11.3

