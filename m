Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2EMRhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:37:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59892 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab2EMRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:37:09 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Release regulator-regulator supplies on error
Date: Sun, 13 May 2012 18:37:03 +0100
Message-Id: <1336930623-15921-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail while registering a regulator make sure we release the supply
for the regulator if there is one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3cfaea..28b9c31 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3196,6 +3196,8 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
 
 scrub:
+	if (rdev->supply)
+		regulator_put(rdev->supply);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */
-- 
1.7.10

