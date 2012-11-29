Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2K2RtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:49:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56004 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab2K2RtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:49:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Treat future revisions as revision B
Date: Thu, 29 Nov 2012 17:49:17 +0000
Message-Id: <1354211357-13736-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expectation is that future revisions will behave as revision B.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 447b00b..b82a003 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -76,12 +76,10 @@ int wm5102_patch(struct arizona *arizona)
 		return regmap_register_patch(arizona->regmap,
 					     wm5102_reva_patch,
 					     ARRAY_SIZE(wm5102_reva_patch));
-	case 1:
+	default:
 		return regmap_register_patch(arizona->regmap,
 					     wm5102_revb_patch,
 					     ARRAY_SIZE(wm5102_revb_patch));
-	default:
-		return 0;
 	}
 }
 
-- 
1.7.10.4

