Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2ENMXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:23:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab2ENMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:23:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Don't open code _regulator_is_enabled()
Date: Mon, 14 May 2012 13:22:58 +0100
Message-Id: <1336998178-5229-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 28b9c31..56768bd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3163,8 +3163,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 			goto scrub;
 
 		/* Enable supply if rail is enabled */
-		if (rdev->desc->ops->is_enabled &&
-				rdev->desc->ops->is_enabled(rdev)) {
+		if (_regulator_is_enabled(rdev)) {
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0)
 				goto scrub;
@@ -3296,7 +3295,7 @@ int regulator_suspend_finish(void)
 				goto unlock;
 			if (!ops->disable)
 				goto unlock;
-			if (ops->is_enabled && !ops->is_enabled(rdev))
+			if (!_regulator_is_enabled(rdev))
 				goto unlock;
 
 			error = ops->disable(rdev);
-- 
1.7.10

