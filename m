Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2HGLWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:22:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64584 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2HGLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:22:35 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: amit.kachhap@linaro.org, dg77.kim@samsung.com, guenter.roeck@ericsson.com,
        akpm@linux-foundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] thermal: Exynos: Fix build error
Date: Tue,  7 Aug 2012 16:51:03 +0530
Message-Id: <1344338465-15478-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following error:
drivers/thermal/exynos_thermal.c:393:4: error: too few arguments to function
‘thermal_zone_device_register’

Added the missing 'mask' argument.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 07736ea..f6debad 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -389,7 +389,7 @@ static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 	th_zone->cool_dev_size = count;
 
 	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
-			EXYNOS_ZONE_COUNT, NULL, &exynos_dev_ops, 0, 0, 0,
+			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, 0, 0, 0,
 			IDLE_INTERVAL);
 
 	if (IS_ERR(th_zone->therm_dev)) {
-- 
1.7.4.1

