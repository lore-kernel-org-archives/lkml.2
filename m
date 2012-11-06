Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2KFIUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:20:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:25951 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab2KFIUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:20:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="244681395"
Subject: [PATCH 2/7] OMAPDSS: DISPC: Fix the usage of
 wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352222317.15558.1584.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:21:20 +0800
Message-ID: <1352222480.15558.1587.camel@cliu38-desktop-build>
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
 drivers/video/omap2/dss/dispc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
index b43477a..9858869 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -3893,9 +3893,6 @@ int omap_dispc_wait_for_irq_timeout(u32 irqmask, unsigned long timeout)
 	if (timeout == 0)
 		return -ETIMEDOUT;
 
-	if (timeout == -ERESTARTSYS)
-		return -ERESTARTSYS;
-
 	return 0;
 }
 
-- 
1.7.0.4



