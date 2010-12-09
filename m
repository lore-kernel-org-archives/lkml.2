Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0LIRao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:30:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19477 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0LIRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:30:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 09 Dec 2010 09:30:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <achew@nvidai.com>, <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] mfd: tps6586x: Remove device ID check
Date: Thu, 9 Dec 2010 10:30:11 -0700
Message-ID: <1291915811-17227-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
References: <20101209135857.GK8884@sortiz-mobl>
In-Reply-To: <20101209135857.GK8884@sortiz-mobl>
Thread-Index: AQJ4JtSh7qajS8CYuXOlrbgOGcNTwQIozUHl
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and convert it to a dev_info print at probe time.

There are many variants of this chip with different values of VERSIONCRC.
The set of values is large, and not useful to enumerate. All are SW
compatible. The difference lies in default settings of the various power
rails, and other similar differences. The driver, or clients of the
driver, shouldn't be affected by this, since all rails should be
programmed into the desired state in all cases for correct operation.

Derived-from-code-by: Andrew Chew <achew@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/mfd/tps6586x.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index b4931ab..3575739 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -46,8 +46,6 @@
 
 /* device id */
 #define TPS6586X_VERSIONCRC	0xcd
-#define TPS658621A_VERSIONCRC	0x15
-#define TPS658621C_VERSIONCRC	0x2c
 
 struct tps6586x_irq_data {
 	u8	mask_reg;
@@ -498,11 +496,7 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	if ((ret != TPS658621A_VERSIONCRC) &&
-	    (ret != TPS658621C_VERSIONCRC)) {
-		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
-		return -ENODEV;
-	}
+	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
 
 	tps6586x = kzalloc(sizeof(struct tps6586x), GFP_KERNEL);
 	if (tps6586x == NULL)
-- 
1.7.0.4

