Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1GFXjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:39:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45970 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1GFXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:39:35 -0400
Subject: [PATCH 2/2 RESEND] regulator: aat2870: Remove a redundant bitwise
 and operation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1309995504.2496.1.camel@phoenix>
References: <1309995504.2496.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 07:39:28 +0800
Message-ID: <1309995568.2496.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in aat2870_update() already did the bitwise and operation
against mask parameter.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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



