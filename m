Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0JRFdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:33:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0JRFdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:33:22 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, jaxboe@fusionio.com, hch@infradead.org,
        smaclennan@pikatech.com, michal.simek@petalogix.com,
        john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] of: xsysace: Fix OF probing on little-endian systems
Date: Mon, 18 Oct 2010 15:33:09 +1000
Message-Id: <1287379989-10772-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert big-endian DTB to little-endian if necessary.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/block/xsysace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 057413b..66911d3 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1224,7 +1224,8 @@ ace_of_probe(struct platform_device *op, const struct of_device_id *match)
 		bus_width = ACE_BUS_WIDTH_8;
 
 	/* Call the bus-independant setup code */
-	return ace_alloc(&op->dev, id ? *id : 0, physaddr, irq, bus_width);
+	return ace_alloc(&op->dev, id ? be32_to_cpup(id) : 0,
+						physaddr, irq, bus_width);
 }
 
 static int __devexit ace_of_remove(struct platform_device *op)
-- 
1.6.4.182.g9ebfd

