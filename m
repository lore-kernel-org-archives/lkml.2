Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KUJ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:28:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43264 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2KUJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:28:22 -0500
X-AuditID: 9c930179-b7c9dae000000e53-91-50ac9eb48356
From: Bongkyu Kim <bongkyu.kim@lge.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bongkyu Kim <bongkyu.kim@lge.com>
Subject: [PATCH] of/i2c: support more interrupt specifiers
Date: Wed, 21 Nov 2012 17:58:42 +0900
Message-Id: <1353488322-14764-1-git-send-email-bongkyu.kim@lge.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports more interrupt specifiers for i2c client.

Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
---
 drivers/of/of_i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 3550f3b..c6d9b7e 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -34,6 +34,7 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 		struct dev_archdata dev_ad = {};
 		const __be32 *addr;
 		int len;
+		int nr = 0;
 
 		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
 
@@ -57,7 +58,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 			continue;
 		}
 
-		info.irq = irq_of_parse_and_map(node, 0);
+		info.irq = irq_of_parse_and_map(node, nr++);
+		while (irq_of_parse_and_map(node, nr))
+			nr++;
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
-- 
1.8.0

