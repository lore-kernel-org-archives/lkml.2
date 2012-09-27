Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2I0LC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:02:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48419 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab2I0LCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:02:11 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: durgadoss.r@intel.com, rui.zhang@intel.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] thermal: step_wise: Add missing static storage class specifiers
Date: Thu, 27 Sep 2012 16:28:12 +0530
Message-Id: <1348743492-30852-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
drivers/thermal/step_wise.c:153:5: warning:
symbol 'step_wise_throttle' was not declared. Should it be static?
drivers/thermal/step_wise.c:172:25: warning:
symbol 'thermal_gov_step_wise' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/thermal/step_wise.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 3f9cfcf..1242cff 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -150,7 +150,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
  * step. If the zone is 'cooling down' it brings back the performance of
  * the devices by one step.
  */
-int step_wise_throttle(struct thermal_zone_device *tz, int trip)
+static int step_wise_throttle(struct thermal_zone_device *tz, int trip)
 {
 	struct thermal_instance *instance;
 
@@ -169,7 +169,7 @@ int step_wise_throttle(struct thermal_zone_device *tz, int trip)
 	return 0;
 }
 
-struct thermal_governor thermal_gov_step_wise = {
+static struct thermal_governor thermal_gov_step_wise = {
 	.name		= DEFAULT_THERMAL_GOVERNOR,
 	.throttle	= step_wise_throttle,
 	.owner		= THIS_MODULE,
-- 
1.7.4.1

