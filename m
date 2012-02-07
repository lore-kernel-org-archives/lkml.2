Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2BGDGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:06:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62748 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2BGDGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:06:30 -0500
Message-ID: <1328583980.5528.1.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Remove pointless test for unsigned
 less than zero
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 07 Feb 2012 11:06:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'selector' is a 'unsigned int', so it can never be less than zero.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index f778ef0..e2ec730 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -191,7 +191,7 @@ static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(dev);
 
-	if ((selector < 0) || (selector >= tps->desc.n_voltages))
+	if (selector >= tps->desc.n_voltages)
 		return -EINVAL;
 	return (tps->voltage_base + selector * 10) * 1000;
 }
-- 
1.7.5.4



