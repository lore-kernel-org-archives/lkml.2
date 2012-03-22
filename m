Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2CVJOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:14:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2CVJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:14:31 -0400
Message-ID: <1332407659.3870.1.camel@phoenix>
Subject: [PATCH] mfd: Remove unused mutex from struct tps65090
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 22 Mar 2012 17:14:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex lock is not used after converting to use regmap, remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65090.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index a66d4df..9a84bda 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -79,7 +79,6 @@ static struct mfd_cell tps65090s[] = {
 };
 
 struct tps65090 {
-	struct mutex		lock;
 	struct device		*dev;
 	struct i2c_client	*client;
 	struct regmap		*rmap;
@@ -283,8 +282,6 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 	tps65090->dev = &client->dev;
 	i2c_set_clientdata(client, tps65090);
 
-	mutex_init(&tps65090->lock);
-
 	if (client->irq) {
 		ret = tps65090_irq_init(tps65090, client->irq, pdata->irq_base);
 		if (ret) {
-- 
1.7.5.4



