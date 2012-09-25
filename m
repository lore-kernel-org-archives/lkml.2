Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2IYQNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48198 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2IYQNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:47 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 29/57] power: ab8500_fg: Goto INIT_RECOVERY when charger removed
Date: Tue, 25 Sep 2012 10:12:26 -0600
Message-Id: <1348589574-25655-30-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bergström <martin.bergstrom@stericsson.com>

When the charger is removed we need to go to INIT_RECOVERY
state instead of directly to RECOVERY state.

Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 861927d..e7a0e1f 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1644,7 +1644,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 
 			if (di->recovery_needed) {
 				ab8500_fg_discharge_state_to(di,
-					AB8500_FG_DISCHARGE_RECOVERY);
+					AB8500_FG_DISCHARGE_INIT_RECOVERY);
 
 				queue_delayed_work(di->fg_wq,
 					&di->fg_periodic_work, 0);
-- 
1.7.5.4

