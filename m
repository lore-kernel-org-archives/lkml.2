Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1K1GHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:07:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50637 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1GHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:07:54 -0500
Message-ID: <1322460468.4954.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: aat2870: Remove a redundant bitwise and
 operation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 28 Nov 2011 14:07:48 +0800
In-Reply-To: <1322460391.4954.1.camel@phoenix>
References: <1322460391.4954.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in aat2870_update() already did the bitwise and operation
against mask parameter.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
It was sent on https://lkml.org/lkml/2011/7/5/560
and resent on https://lkml.org/lkml/2011/8/29/210.

Seems the patch is lost so I resend it again.
Axel
 drivers/regulator/aat2870-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 43b25cc..685ad43 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -63,7 +63,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
 	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
 
 	return aat2870->update(aat2870, ri->voltage_addr, ri->voltage_mask,
-			(selector << ri->voltage_shift) & ri->voltage_mask);
+			       selector << ri->voltage_shift);
 }
 
 static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
-- 
1.7.5.4



