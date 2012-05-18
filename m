Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967385Ab2ERUhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:37:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7416 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966015Ab2ERUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:37:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 18 May 2012 13:36:59 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@slimlogic.co.uk>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] mfd: remove the parsing of dt info for gpio
Date: Sat, 19 May 2012 02:01:42 +0530
Message-ID: <1337373103-23933-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
References: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the parsing of device node information for sub devices
from core file.
The sub devices will parse the information as per the sub-devices
specific information.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 05d449b..be9e07b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -146,9 +146,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 	struct tps65910_board *board_info;
 	unsigned int prop;
 	const struct of_device_id *match;
-	unsigned int prop_array[TPS6591X_MAX_NUM_GPIO];
 	int ret = 0;
-	int idx;
 
 	match = of_match_device(tps65910_of_match, &client->dev);
 	if (!match) {
@@ -177,21 +175,8 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 	else if (*chip_id == TPS65911)
 		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
 
-	ret = of_property_read_u32_array(np, "ti,en-gpio-sleep",
-				   prop_array, TPS6591X_MAX_NUM_GPIO);
-	if (!ret)
-		for (idx = 0; idx < ARRAY_SIZE(prop_array); idx++)
-			board_info->en_gpio_sleep[idx] = (prop_array[idx] != 0);
-	else if (ret != -EINVAL) {
-		dev_err(&client->dev,
-			"error reading property ti,en-gpio-sleep: %d\n.", ret);
-		return NULL;
-	}
-
-
 	board_info->irq = client->irq;
 	board_info->irq_base = -1;
-	board_info->gpio_base = -1;
 
 	return board_info;
 }
-- 
1.7.1.1

