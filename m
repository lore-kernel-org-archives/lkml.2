Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2DEGDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:03:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57841 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2DEGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:03:36 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 2/2] Agp: Use u32 __iomem  annotation to silence sparse warning.
Date: Thu,  5 Apr 2012 11:31:44 +0530
Message-Id: <1333605704-18658-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Replace "void *" by "u32 __iomem *" to silence sparse warning.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/char/agp/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 38022ea..a0df182 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -958,7 +958,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 	if (set_memory_uc((unsigned long)table, 1 << page_order))
 		printk(KERN_WARNING "Could not set GATT table memory to UC!\n");
 
-	bridge->gatt_table = (void *)table;
+	bridge->gatt_table = (u32 __iomem *)table;
 #else
 	bridge->gatt_table = ioremap_nocache(virt_to_phys(table),
 					(PAGE_SIZE * (1 << page_order)));
-- 
1.7.4.4

