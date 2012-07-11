Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2GKMXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:23:54 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:9942 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2GKMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:23:53 -0400
Message-Id: <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 13:10:01 +0100
Subject: [PATCH] regulator: Fix bug in regulator_mode_to_status() core function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo for case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.
For undefined mode, return REGULATOR_STATUS_ERROR (0 is not valid status).

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 09a737c..b821a9f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2909,10 +2909,10 @@ int regulator_mode_to_status(unsigned int mode)
 		return REGULATOR_STATUS_NORMAL;
 	case REGULATOR_MODE_IDLE:
 		return REGULATOR_STATUS_IDLE;
-	case REGULATOR_STATUS_STANDBY:
+	case REGULATOR_MODE_STANDBY:
 		return REGULATOR_STATUS_STANDBY;
 	default:
-		return 0;
+		return REGULATOR_STATUS_ERROR;
 	}
 }
 EXPORT_SYMBOL_GPL(regulator_mode_to_status);
-- 
1.7.0.4

