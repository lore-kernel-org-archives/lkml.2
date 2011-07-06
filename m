Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1GFDgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:36:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44965 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1GFDgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:36:09 -0400
Subject: [PATCH 2/2] regulator: aat2870: Remove a redundant bitwise and
 operation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1309923277.26847.5.camel@phoenix>
References: <1309923277.26847.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 11:36:03 +0800
Message-ID: <1309923363.26847.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in aat2870_update() already did the bitwise and operation
against mask parameter.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/aat2870-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 11d1ab4..c8ea28e 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -62,7 +62,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
 	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
 
 	return aat2870->update(aat2870, ri->voltage_addr, ri->voltage_mask,
-			(selector << ri->voltage_shift) & ri->voltage_mask);
+			selector << ri->voltage_shift);
 }
 
 static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
-- 
1.7.4.1



