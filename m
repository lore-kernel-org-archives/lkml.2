Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab2IYQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:17:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab2IYQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:05 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 42/57] power: charging: Allow capacity to raise from 1%
Date: Tue, 25 Sep 2012 10:12:39 -0600
Message-Id: <1348589574-25655-43-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

When battery capacity was going below 1% fg in not supposed
to report 0% unless we've got the LOW_BAT IRQ, no matter
what the FG-algorithm says. This made fg get stuck at 1% if
charger is connected when capacity is 1%.
That problem is addressed with this patch.

Signed-off-by: Hakan BERG <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
---
 drivers/power/ab8500_fg.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c5732e7..cf6d2b5 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1357,9 +1357,6 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			 * algorithm says.
 			 */
 			di->bat_cap.prev_percent = 1;
-			di->bat_cap.permille = 1;
-			di->bat_cap.prev_mah = 1;
-			di->bat_cap.mah = 1;
 			percent = 1;
 
 			changed = true;
@@ -1771,9 +1768,10 @@ static void ab8500_fg_algorithm(struct ab8500_fg *di)
 			ab8500_fg_algorithm_discharging(di);
 	}
 
-	dev_dbg(di->dev, "[FG_DATA] %d %d %d %d %d %d %d %d %d "
+	dev_dbg(di->dev, "[FG_DATA] %d %d %d %d %d %d %d %d %d %d "
 		"%d %d %d %d %d %d %d\n",
 		di->bat_cap.max_mah_design,
+		di->bat_cap.max_mah,
 		di->bat_cap.mah,
 		di->bat_cap.permille,
 		di->bat_cap.level,
-- 
1.7.5.4

