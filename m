Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2KFI10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:27:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:40758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab2KFI1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:27:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="213976434"
Subject: [PATCH 4/7] wlcore: Fix the usage of wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: luca@coelho.fi, eliad@wizery.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352222555.15558.1589.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
	 <1352222555.15558.1589.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:28:14 +0800
Message-ID: <1352222894.15558.1595.camel@cliu38-desktop-build>
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
 drivers/net/wireless/ti/wlcore/ps.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 4d1414a..ffcd843 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -151,9 +151,6 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 			wl12xx_queue_recovery_work(wl);
 			ret = -ETIMEDOUT;
 			goto err;
-		} else if (ret < 0) {
-			wl1271_error("ELP wakeup completion error.");
-			goto err;
 		}
 	}
 
-- 
1.7.0.4



