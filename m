Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2KFIVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:21:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:61484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab2KFIVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:21:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="243046463"
Subject: [PATCH 3/7] OMAPDSS: APPLY: Fix the usage of
 wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352222480.15558.1587.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:22:35 +0800
Message-ID: <1352222555.15558.1589.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of wait_for_completion_timeout() is always
>= 0 with unsigned int type.

So the condition "ret < 0" or "ret >= 0" is pointless.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/video/omap2/dss/apply.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap2/dss/apply.c b/drivers/video/omap2/dss/apply.c
index 19d66f4..ec42a6a 100644
--- a/drivers/video/omap2/dss/apply.c
+++ b/drivers/video/omap2/dss/apply.c
@@ -414,8 +414,6 @@ static void wait_pending_extra_info_updates(void)
 	r = wait_for_completion_timeout(&extra_updated_completion, t);
 	if (r == 0)
 		DSSWARN("timeout in wait_pending_extra_info_updates\n");
-	else if (r < 0)
-		DSSERR("wait_pending_extra_info_updates failed: %d\n", r);
 }
 
 int dss_mgr_wait_for_go(struct omap_overlay_manager *mgr)
-- 
1.7.0.4



