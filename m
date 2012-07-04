Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab2GDHfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:35:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:31527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2GDHfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163887398"
From: Jouni Hogander <jouni.hogander@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jouni.hogander@intel.com, illyas.mansoor@intel.com,
        ilkka.koskinen@intel.com
Subject: [PATCH] init: Fix erroneous printed check in calibrate_delay
Date: Wed,  4 Jul 2012 10:32:23 +0300
Message-Id: <1341387143-3338-1-git-send-email-jouni.hogander@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calibration is skipped only on first calibrate_delay when it's done
using timer. This is causing unnecessary delay when CPU is hotplugged
in.

Signed-off-by: Jouni Hogander <jouni.hogander@intel.com>
Reviewed-by: Ilkka Koskinen <ilkka.koskinen@intel.com>
Reviewed-by: Illyas Mansoor <illyas.mansoor@intel.com>
---
 init/calibrate.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index fda0a7b..b7dcaf9 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -275,10 +275,11 @@ void __cpuinit calibrate_delay(void)
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
-	} else if ((!printed) && lpj_fine) {
+	} else if (lpj_fine) {
 		lpj = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		if (!printed)
+			pr_info("Calibrating delay loop (skipped), "
+				"value calculated using timer frequency.. ");
 	} else if ((lpj = calibrate_delay_is_known())) {
 		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
-- 
1.7.4.1
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki
Business Identity Code: 0357606 - 4
Domiciled in Helsinki
