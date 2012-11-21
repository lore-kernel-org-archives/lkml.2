Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2KUJ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:27:35 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56382 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2KUJ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:27:33 -0500
X-AuditID: 9c930179-b7c9dae000000e53-dc-50ac9e81b791
From: Bongkyu Kim <bongkyu.kim@lge.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bongkyu Kim <bongkyu.kim@lge.com>
Subject: [PATCH] of/i2c: check status property for i2c client
Date: Wed, 21 Nov 2012 17:57:50 +0900
Message-Id: <1353488270-14723-1-git-send-email-bongkyu.kim@lge.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of_i2c_register_devices() do not check status property,
all i2c clients are registered.

This patch add checking status property for i2c client.
After this patch, if status property is absent or "okay" or "ok",
i2c client will be registered.

Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
---
 drivers/of/of_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 3550f3b..2552fc5 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -37,6 +37,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 
 		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
 
+		if (!of_device_is_available(node))
+			continue;
+
 		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
 			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
 				node->full_name);
-- 
1.8.0

