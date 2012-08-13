Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2HMNLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:11:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10474 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2HMNLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:11:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 13 Aug 2012 06:11:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] mfd: tps65910: remove warning during dt node parsing
Date: Mon, 13 Aug 2012 18:24:21 +0530
Message-ID: <1344862461-6297-1-git-send-email-ldewangan@nvidia.com>
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
 drivers/mfd/tps65910.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 1c56379..64514b0 100644
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

