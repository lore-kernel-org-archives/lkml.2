Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2JGP5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:57:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8872 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2JGPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:55:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 07 Oct 2012 08:55:52 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <vbyravarasu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] mfd: tps65090: add error prints when mem alloc failed
Date: Sun, 7 Oct 2012 20:52:17 +0530
Message-ID: <1349623340-21807-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
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

