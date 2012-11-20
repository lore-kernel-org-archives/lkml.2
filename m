Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2KTDPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:15:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11780 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2KTDPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:15:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Nov 2012 19:15:16 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 2/5] mfd: tps65090: add error prints when mem alloc failed
Date: Tue, 20 Nov 2012 08:44:46 +0530
Message-ID: <1353381289-11643-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
References: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error prints when memory allocation failed for
tps65090 data. Also cleanups the melloc arguments.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 9b79d68..f95f7f6 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -263,10 +263,11 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	tps65090 = devm_kzalloc(&client->dev, sizeof(struct tps65090),
-		GFP_KERNEL);
-	if (tps65090 == NULL)
+	tps65090 = devm_kzalloc(&client->dev, sizeof(*tps65090), GFP_KERNEL);
+	if (!tps65090) {
+		dev_err(&client->dev, "mem alloc for tps65090 failed\n");
 		return -ENOMEM;
+	}
 
 	tps65090->client = client;
 	tps65090->dev = &client->dev;
-- 
1.7.1.1

