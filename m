Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2I0Ky3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:54:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50045 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2I0Ky1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:54:27 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: amit.kachhap@linaro.org, rui.zhang@intel.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] thermal: Exynos: Fix NULL pointer dereference in exynos_unregister_thermal()
Date: Thu, 27 Sep 2012 16:20:38 +0530
Message-Id: <1348743038-26168-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_unregister_thermal() is functional only when 'th_zone' is not
NULL (ensured by the NULL checks). However, in the event it is NULL, it
gets dereferenced in the for loop. This patch fixes this issue.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/thermal/exynos_thermal.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 4b203b6..4997a3a 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -475,11 +475,14 @@ static void exynos_unregister_thermal(void)
 {
 	int i;
 
-	if (th_zone && th_zone->therm_dev)
+	if (!th_zone)
+		return;
+
+	if (th_zone->therm_dev)
 		thermal_zone_device_unregister(th_zone->therm_dev);
 
 	for (i = 0; i < th_zone->cool_dev_size; i++) {
-		if (th_zone && th_zone->cool_dev[i])
+		if (th_zone->cool_dev[i])
 			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
 	}
 
-- 
1.7.4.1

