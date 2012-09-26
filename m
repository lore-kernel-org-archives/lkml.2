Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2IZNSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:18:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10286 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2IZNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:18:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 26 Sep 2012 06:16:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [REPOST/PATCH] mfd: tps65910: remove warning during dt node parsing
Date: Wed, 26 Sep 2012 18:18:04 +0530
Message-ID: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver throw the warning message if dt node does not
have the info for VMBCH-Threshold and VMBCH2-Threshold.
These properties are optional property and hence it
is not mandatory to have these on DT node and in this case
it should not throw the warning message.
It creates noise from driver as follows:
[    0.384605] tps65910 4-002d: VMBCH-Threshold not specified
[    0.384616] tps65910 4-002d: VMBCH2-Threshold not specified

Removing the warning message from driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
It seems orginal patch has been lost. Reposting it.

 drivers/mfd/tps65910.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index ca90294..665e1b6 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -184,14 +184,10 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
 	if (!ret)
 		board_info->vmbch_threshold = prop;
-	else if (*chip_id == TPS65911)
-		dev_warn(&client->dev, "VMBCH-Threshold not specified");
 
 	ret = of_property_read_u32(np, "ti,vmbch2-threshold", &prop);
 	if (!ret)
 		board_info->vmbch2_threshold = prop;
-	else if (*chip_id == TPS65911)
-		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
 
 	prop = of_property_read_bool(np, "ti,en-ck32k-xtal");
 	board_info->en_ck32k_xtal = prop;
-- 
1.7.1.1

