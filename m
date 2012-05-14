Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2ENCeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:34:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2ENCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:33:47 -0400
Message-ID: <1336962817.24732.1.camel@phoenix>
Subject: [PATCH] regulator: core: Ensure simple linear voltage mappings
 falls within the specified range
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 14 May 2012 10:33:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate the result.
Use DIV_ROUND_UP to ensure simple linear voltage mappings falls within the
specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5751f5e..8918271 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2047,7 +2047,7 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	ret = (min_uV - rdev->desc->min_uV) / rdev->desc->uV_step;
+	ret = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.5.4



