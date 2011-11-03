Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1KCVsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:48:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57651 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1KCVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:48:50 -0400
From: Robert Lee <rob.lee@linaro.org>
To: rjw@sisk.pl
Cc: len.brown@intel.com, hpa@linux.intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH] pm: remove useless array definition in cpuidle_structure
Date: Thu,  3 Nov 2011 17:44:53 -0400
Message-Id: <1320356693-18982-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

All the modules name are ro-data, it is never copied to the array.

eg.

static struct cpuidle_driver intel_idle_driver = {
        .name = "intel_idle",
        .owner = THIS_MODULE,
};

It safe to assign the pointer of this ro-data to a const char *.
By this way we save 12 bytes.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 include/linux/cpuidle.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index b51629e..16f9dce 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -117,8 +117,8 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
  ****************************/
 
 struct cpuidle_driver {
-	char			name[CPUIDLE_NAME_LEN];
-	struct module 		*owner;
+	const char    *name;
+	struct module *owner;
 };
 
 #ifdef CONFIG_CPU_IDLE
-- 
1.7.4.1

