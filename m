Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2L1JaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:30:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7893 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2L1JaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:30:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 28 Dec 2012 01:29:58 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <lrg@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] mfd: tps65090: Pass irq domain when adding mfd sub devices
Date: Fri, 28 Dec 2012 14:59:40 +0530
Message-ID: <1356686981-4152-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device is get added through DT then irq_base is 0 (zero)
and in this case regmap_irq_chip_get_base() generates warning.
The interrupt of this device get added through irq_domain_add_linear()
when irq_base is 0.

Hence pass the irq domain in place of base_irq when calling
mfd_add_devices().

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index e4cf030..3e987be 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -236,7 +236,7 @@ static int tps65090_i2c_probe(struct i2c_client *client,
 
 	ret = mfd_add_devices(tps65090->dev, -1, tps65090s,
 		ARRAY_SIZE(tps65090s), NULL,
-		regmap_irq_chip_get_base(tps65090->irq_data), NULL);
+		0, regmap_irq_get_domain(tps65090->irq_data));
 	if (ret) {
 		dev_err(&client->dev, "add mfd devices failed with err: %d\n",
 			ret);
-- 
1.7.1.1

