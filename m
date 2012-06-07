Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2FGBwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:52:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36434 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2FGBwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:52:20 -0400
Message-ID: <1339033932.7309.1.camel@phoenix>
Subject: [PATCH] regulator: core: Properly handle the case min_uV <
 rdev->desc->min_uV in map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 07 Jun 2012 09:52:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly handle the case if the specified min_uV is less than the voltage given
by the lowest selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3cbe312..02c1940 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2075,6 +2075,9 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	if (min_uV < rdev->desc->min_uV)
+		min_uV = rdev->desc->min_uV;
+
 	ret = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
 	if (ret < 0)
 		return ret;
-- 
1.7.9.5



