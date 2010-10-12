Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab0JLVYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:24:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1053 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0JLVYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:24:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 12 Oct 2010 14:24:40 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "mike@compulab.co.il" <mike@compulab.co.il>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        Gary King <GKing@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>, "'Greg KH'" <greg@kroah.com>
Date: Tue, 12 Oct 2010 14:24:34 -0700
Subject: [PATCH 1/1] mfd: Add TPS658621C device ID
Thread-Topic: [PATCH 1/1] mfd: Add TPS658621C device ID
Thread-Index: Actk3UDgBd5pV4gwRBKGh9ma2fPxYQFdlBpg
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BB82897A@HQMAIL03.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending again.  Can someone review for commit?

This is a really simple change that adds a new valid device ID for the existing tps6586x PMU driver.

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

