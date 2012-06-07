Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab2FGCFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:05:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49281 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2FGCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:05:20 -0400
Message-ID: <1339034714.7309.3.camel@phoenix>
Subject: [PATCH RFC 1/2] regulator: core: Allow uV_step to be 0 for linear
 mapping if fixed voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 07 Jun 2012 10:05:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed voltage is a kind of linear mapping where n_voltages is 1 and uV_step is
0. This change allows [list|map]_voltage_linear to be used for fixed voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02c1940..876f5fc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2070,6 +2070,14 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 {
 	int ret, voltage;
 
+	/* Allow uV_step to be 0 for fixed voltage */
+	if (rdev->desc->n_voltages == 1 && rdev->desc->uV_step == 0) {
+		if (min_uV <= rdev->desc->min_uV && rdev->desc->min_uV <= max_uV)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
 	if (!rdev->desc->uV_step) {
 		BUG_ON(!rdev->desc->uV_step);
 		return -EINVAL;
-- 
1.7.9.5



