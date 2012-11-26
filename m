Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2KZNrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:47:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56433 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2KZNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:47:49 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, jonghwa3.lee@samsung.com
Subject: [PATCH V2 3/3] thermal: exynos: Use the new thermal trend type for quick cooling action.
Date: Mon, 26 Nov 2012 19:17:20 +0530
Message-Id: <1353937640-9939-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
References: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the quick thermal cooling trend type macros. This is needed
as exynos5 and other thermal sensors now supports only interrupt method for
thresold temperature check.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/exynos_thermal.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 54b3fea..2490901 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -295,7 +295,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 		case MONITOR_ZONE:
 		case WARN_ZONE:
 			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
-								level, level)) {
+								level, 0)) {
 				pr_err("error binding cdev inst %d\n", i);
 				ret = -EINVAL;
 			}
@@ -381,9 +381,9 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
 		return ret;
 
 	if (thermal->temperature >= trip_temp)
-		*trend = THERMAL_TREND_RAISING;
+		*trend = THERMAL_TREND_RAISE_FULL;
 	else
-		*trend = THERMAL_TREND_DROPPING;
+		*trend = THERMAL_TREND_DROP_FULL;
 
 	return ret;
 }
-- 
1.7.1

