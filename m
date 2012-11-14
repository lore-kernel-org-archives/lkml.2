Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874Ab2KNQ1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:27:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57538 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab2KNQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:27:48 -0500
From: Gernot Vormayr <gvormayr@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Gernot Vormayr <gvormayr@gmail.com>
Subject: [PATCH 1/1] block: Fix id of xsysace with missing port-number
Date: Wed, 14 Nov 2012 17:27:28 +0100
Message-Id: <1352910448-14866-1-git-send-email-gvormayr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since id is u32 the comparsion < 0 will fail. The right way
would be to check the return value of of_property_read_u32

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
---
 drivers/block/xsysace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 1a17e33..b115e1f 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1162,8 +1162,7 @@ static int __devinit ace_probe(struct platform_device *dev)
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
 
 	/* device id and bus width */
-	of_property_read_u32(dev->dev.of_node, "port-number", &id);
-	if (id < 0)
+	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
 		id = 0;
 	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
-- 
1.7.9.5

