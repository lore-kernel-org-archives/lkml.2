Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1K3NbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:31:21 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:32949 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1K3NbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:31:20 -0500
Subject: [RFC PATCH v3 4/4] cpuidle: (POWER) Handle power_save=off
To: benh@kernel.crashing.org, len.brown@intel.com
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Wed, 30 Nov 2011 18:17:03 +0530
Message-ID: <20111130124701.972.7269.stgit@deepthi-ThinkPad-T420>
In-Reply-To: <20111130124608.972.87712.stgit@deepthi-ThinkPad-T420>
References: <20111130124608.972.87712.stgit@deepthi-ThinkPad-T420>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11113012-5564-0000-0000-0000004FD862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes pseries_idle_driver not to be registered when
power_save=off kernel boot option is specified. The
cpuidle_disable variable used here is similar to
its usage on x86. If cpuidle_disable is set then
sysfs entries for cpuidle framework are not created
and the required drivers are not loaded.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
Signed-off-by: Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
---
 arch/powerpc/include/asm/processor.h            |    1 +
 arch/powerpc/platforms/pseries/processor_idle.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 811b7e7..b585bff 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -382,6 +382,7 @@ static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
 }
 #endif
 
+extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 352b78a..4f59af0 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -269,6 +269,9 @@ static int pseries_idle_probe(void)
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -ENODEV;
 
+	if (cpuidle_disable != IDLE_NO_OVERRIDE)
+		return -ENODEV;
+
 	if (max_idle_state == 0) {
 		printk(KERN_DEBUG "pseries processor idle disabled.\n");
 		return -EPERM;

