Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2FTIN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:13:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33099 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2FTINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:13:24 -0400
Message-ID: <1340179995.18879.1.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Return -EINVAL if pdata is NULL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 20 Jun 2012 16:13:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL if pdata is NULL, otherwise we have NULL dereference bug.
This patch also moves the code checking pdata earlier in lp872x_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp872x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index d51d098..e8f54ef 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -785,11 +785,6 @@ static int lp872x_config(struct lp872x *lp)
 	struct lp872x_platform_data *pdata = lp->pdata;
 	int ret;
 
-	if (!pdata) {
-		dev_warn(lp->dev, "no platform data\n");
-		return 0;
-	}
-
 	if (!pdata->update_config)
 		return 0;
 
@@ -889,6 +884,11 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		[LP8725] = LP8725_NUM_REGULATORS,
 	};
 
+	if (!pdata) {
+		dev_warn(&cl->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
 	if (!lp)
 		goto err_mem;
-- 
1.7.9.5



