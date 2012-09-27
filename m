Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2I0Lbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:31:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39573 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2I0Lbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:31:39 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: durgadoss.r@intel.com, rui.zhang@intel.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] thermal: fair_share: Add missing static storage class specifiers
Date: Thu, 27 Sep 2012 16:57:53 +0530
Message-Id: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
drivers/thermal/fair_share.c:80:5: warning:
symbol 'fair_share_throttle' was not declared. Should it be static?
drivers/thermal/fair_share.c:111:25: warning:
symbol 'thermal_gov_fair_share' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/thermal/fair_share.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 5d3a7a3..792479f 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -77,7 +77,7 @@ static long get_target_state(struct thermal_zone_device *tz,
  *	(Heavily assumes the trip points are in ascending order)
  * new_state of cooling device = P3 * P2 * P1
  */
-int fair_share_throttle(struct thermal_zone_device *tz, int trip)
+static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 {
 	const struct thermal_zone_params *tzp;
 	struct thermal_cooling_device *cdev;
@@ -108,7 +108,7 @@ int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 	return 0;
 }
 
-struct thermal_governor thermal_gov_fair_share = {
+static struct thermal_governor thermal_gov_fair_share = {
 	.name		= "fair_share",
 	.throttle	= fair_share_throttle,
 	.owner		= THIS_MODULE,
-- 
1.7.4.1

