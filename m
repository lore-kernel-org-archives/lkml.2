Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0JEWdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:33:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17717 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0JEWdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:33:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 05 Oct 2010 15:32:54 -0700
From: achew@nvidia.com
To: mike@compulab.co.il, axel.lin@gmail.com, gking@nvidia.com
Cc: linux-kernel@vger.kernel.org, Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/1] mfd: Add TPS658621C device ID
Date: Tue,  5 Oct 2010 15:32:26 -0700
Message-Id: <1286317946-11170-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 05 Oct 2010 22:32:54.0370 (UTC) FILETIME=[408CA420:01CB64DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

The interface for this device should be identical to that of the
TPS658521A.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/mfd/tps6586x.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 117eb7c..b4931ab 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -47,6 +47,7 @@
 /* device id */
 #define TPS6586X_VERSIONCRC	0xcd
 #define TPS658621A_VERSIONCRC	0x15
+#define TPS658621C_VERSIONCRC	0x2c
 
 struct tps6586x_irq_data {
 	u8	mask_reg;
@@ -497,7 +498,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	if (ret != TPS658621A_VERSIONCRC) {
+	if ((ret != TPS658621A_VERSIONCRC) &&
+	    (ret != TPS658621C_VERSIONCRC)) {
 		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
 		return -ENODEV;
 	}
-- 
1.7.0.4

