Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2I0Lbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:31:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39573 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2I0Lbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:31:42 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: durgadoss.r@intel.com, rui.zhang@intel.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] thermal: user_space: Add missing static storage class specifiers
Date: Thu, 27 Sep 2012 16:57:54 +0530
Message-Id: <1348745274-15936-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
References: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
drivers/thermal/user_space.c:38:5: warning:
symbol 'notify_user_space' was not declared. Should it be static?
drivers/thermal/user_space.c:46:25: warning:
symbol 'thermal_gov_user_space' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/thermal/user_space.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/user_space.c b/drivers/thermal/user_space.c
index fb246b90..6bbb380 100644
--- a/drivers/thermal/user_space.c
+++ b/drivers/thermal/user_space.c
@@ -35,7 +35,7 @@
  *
  * This function notifies the user space through UEvents.
  */
-int notify_user_space(struct thermal_zone_device *tz, int trip)
+static int notify_user_space(struct thermal_zone_device *tz, int trip)
 {
 	mutex_lock(&tz->lock);
 	kobject_uevent(&tz->device.kobj, KOBJ_CHANGE);
@@ -43,7 +43,7 @@ int notify_user_space(struct thermal_zone_device *tz, int trip)
 	return 0;
 }
 
-struct thermal_governor thermal_gov_user_space = {
+static struct thermal_governor thermal_gov_user_space = {
 	.name		= "user_space",
 	.throttle	= notify_user_space,
 	.owner		= THIS_MODULE,
-- 
1.7.4.1

