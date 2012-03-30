Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab2C3KTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:19:46 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52238 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2C3KSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 12/76] SH: shmobile: Consolidate time keeping and irq enable
Date: Fri, 30 Mar 2012 06:13:15 -0400
Message-id: <5c48c873baf1a67b93d26770c8fe4d41f26f48af.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Lee <rob.lee@linaro.org>

Enable core cpuidle timekeeping and irq enabling and remove that
handling from this code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/sh/kernel/cpu/shmobile/cpuidle.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
index 6d62eb4..1ddc876 100644
--- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
+++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
@@ -29,7 +29,6 @@ static int cpuidle_sleep_enter(struct cpuidle_device *dev,
 				int index)
 {
 	unsigned long allowed_mode = SUSP_SH_SLEEP;
-	ktime_t before, after;
 	int requested_state = index;
 	int allowed_state;
 	int k;
@@ -47,19 +46,16 @@ static int cpuidle_sleep_enter(struct cpuidle_device *dev,
 	 */
 	k = min_t(int, allowed_state, requested_state);
 
-	before = ktime_get();
 	sh_mobile_call_standby(cpuidle_mode[k]);
-	after = ktime_get();
-
-	dev->last_residency = (int)ktime_to_ns(ktime_sub(after, before)) >> 10;
 
 	return k;
 }
 
 static struct cpuidle_device cpuidle_dev;
 static struct cpuidle_driver cpuidle_driver = {
-	.name =		"sh_idle",
-	.owner =	THIS_MODULE,
+	.name			= "sh_idle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
 };
 
 void sh_mobile_setup_cpuidle(void)
-- 
1.7.10.rc2.19.gfae9d

