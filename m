Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0JDUp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:45:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46767 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757161Ab0JDUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:44:30 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/7] ARM: oprofile: Rename op_arm to oprofile_perf
Date: Mon,  4 Oct 2010 21:44:21 +0100
Message-Id: <094e8a33da82ce840f77fd1f7646391c08205b6e.1286222593.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the generic functions out of this file, give
the functions more general names (e.g. remove "arm" from the names).

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   68 ++++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index cb224ee..86df75f 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -38,8 +38,8 @@ struct op_counter_config {
 	struct perf_event_attr attr;
 };
 
-static int op_arm_enabled;
-static DEFINE_MUTEX(op_arm_mutex);
+static int oprofile_perf_enabled;
+static DEFINE_MUTEX(oprofile_perf_mutex);
 
 static struct op_counter_config *counter_config;
 static struct perf_event **perf_events[nr_cpumask_bits];
@@ -66,7 +66,7 @@ static void op_overflow_handler(struct perf_event *event, int unused,
 }
 
 /*
- * Called by op_arm_setup to create perf attributes to mirror the oprofile
+ * Called by oprofile_perf_setup to create perf attributes to mirror the oprofile
  * settings in counter_config. Attributes are created as `pinned' events and
  * so are permanently scheduled on the PMU.
  */
@@ -123,7 +123,7 @@ static void op_destroy_counter(int cpu, int event)
 }
 
 /*
- * Called by op_arm_start to create active perf events based on the
+ * Called by oprofile_perf_start to create active perf events based on the
  * perviously configured attributes.
  */
 static int op_perf_start(void)
@@ -143,7 +143,7 @@ out:
 }
 
 /*
- * Called by op_arm_stop at the end of a profiling run.
+ * Called by oprofile_perf_stop at the end of a profiling run.
  */
 static void op_perf_stop(void)
 {
@@ -155,7 +155,7 @@ static void op_perf_stop(void)
 }
 
 
-static int op_arm_create_files(struct super_block *sb, struct dentry *root)
+static int oprofile_perf_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
@@ -176,7 +176,7 @@ static int op_arm_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
-static int op_arm_setup(void)
+static int oprofile_perf_setup(void)
 {
 	spin_lock(&oprofilefs_lock);
 	op_perf_setup();
@@ -184,54 +184,54 @@ static int op_arm_setup(void)
 	return 0;
 }
 
-static int op_arm_start(void)
+static int oprofile_perf_start(void)
 {
 	int ret = -EBUSY;
 
-	mutex_lock(&op_arm_mutex);
-	if (!op_arm_enabled) {
+	mutex_lock(&oprofile_perf_mutex);
+	if (!oprofile_perf_enabled) {
 		ret = 0;
 		op_perf_start();
-		op_arm_enabled = 1;
+		oprofile_perf_enabled = 1;
 	}
-	mutex_unlock(&op_arm_mutex);
+	mutex_unlock(&oprofile_perf_mutex);
 	return ret;
 }
 
-static void op_arm_stop(void)
+static void oprofile_perf_stop(void)
 {
-	mutex_lock(&op_arm_mutex);
-	if (op_arm_enabled)
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled)
 		op_perf_stop();
-	op_arm_enabled = 0;
-	mutex_unlock(&op_arm_mutex);
+	oprofile_perf_enabled = 0;
+	mutex_unlock(&oprofile_perf_mutex);
 }
 
 #ifdef CONFIG_PM
-static int op_arm_suspend(struct platform_device *dev, pm_message_t state)
+static int oprofile_perf_suspend(struct platform_device *dev, pm_message_t state)
 {
-	mutex_lock(&op_arm_mutex);
-	if (op_arm_enabled)
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled)
 		op_perf_stop();
-	mutex_unlock(&op_arm_mutex);
+	mutex_unlock(&oprofile_perf_mutex);
 	return 0;
 }
 
-static int op_arm_resume(struct platform_device *dev)
+static int oprofile_perf_resume(struct platform_device *dev)
 {
-	mutex_lock(&op_arm_mutex);
-	if (op_arm_enabled && op_perf_start())
-		op_arm_enabled = 0;
-	mutex_unlock(&op_arm_mutex);
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled && op_perf_start())
+		oprofile_perf_enabled = 0;
+	mutex_unlock(&oprofile_perf_mutex);
 	return 0;
 }
 
 static struct platform_driver oprofile_driver = {
 	.driver		= {
-		.name		= "arm-oprofile",
+		.name		= "oprofile-perf",
 	},
-	.resume		= op_arm_resume,
-	.suspend	= op_arm_suspend,
+	.resume		= oprofile_perf_resume,
+	.suspend	= oprofile_perf_suspend,
 };
 
 static struct platform_device *oprofile_pdev;
@@ -366,11 +366,11 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	}
 
 	ops->backtrace		= arm_backtrace;
-	ops->create_files	= op_arm_create_files;
-	ops->setup		= op_arm_setup;
-	ops->start		= op_arm_start;
-	ops->stop		= op_arm_stop;
-	ops->shutdown		= op_arm_stop;
+	ops->create_files	= oprofile_perf_create_files;
+	ops->setup		= oprofile_perf_setup;
+	ops->start		= oprofile_perf_start;
+	ops->stop		= oprofile_perf_stop;
+	ops->shutdown		= oprofile_perf_stop;
 	ops->cpu_type		= perf_pmu_name();
 
 	if (!ops->cpu_type)
-- 
1.7.1

