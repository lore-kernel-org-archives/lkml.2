Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2LKMgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:36:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32921 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:36:48 -0500
Message-ID: <1355229397.6766.2.camel@phoenix>
Subject: [PATCH] regulator: core: Fix logic to determinate if regulator can
 change voltage
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 20:36:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a linear_min_sel setting means the first linear_min_sel selectors are
invalid. We need to subtract linear_min_sel when use n_voltages to determinate
if regulator can change voltage.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd1b201..0f65b24 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1886,7 +1886,7 @@ int regulator_can_change_voltage(struct regulator *regulator)
 
 	if (rdev->constraints &&
 	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
-	    rdev->desc->n_voltages > 1)
+	    (rdev->desc->n_voltages - rdev->desc->linear_min_sel) > 1)
 		return 1;
 
 	return 0;
-- 
1.7.9.5



