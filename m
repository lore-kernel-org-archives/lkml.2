Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2ETQY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:24:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1265 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2ETQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:24:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 20 May 2012 09:24:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] regulator: tps65910: dt: support when "regulators" node found
Date: Sun, 20 May 2012 21:48:49 +0530
Message-ID: <1337530730-16605-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
References: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree binding for the tps65910 is described as:
	tps65911 {
		reg = <0x2d>
		:::::::::
		regulators {
			compatible = "ti,tps65911";
			ldo1_reg: ldo1 {
				/** regulator entry */
			};

			ldo2_reg: ldo2 {
				/** regulator entry */
			};
			::::::::::
		};
	};

Support the regulators functionality only when there is "regulators"
child node available for tps65910.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 94c1801..0190f29 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1090,6 +1090,10 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	}
 
 	regulators = of_find_node_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return NULL;
+	}
 
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
-- 
1.7.1.1

