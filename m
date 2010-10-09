Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab0JIArq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:47:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44544 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760034Ab0JIAq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:27 -0400
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
Subject: [PATCH 4/7] ARM: oprofile: Rename op_arm to oprofile_perf
Date: Sat,  9 Oct 2010 01:46:19 +0100
Message-Id: <f4da40c1bd8417534c07532cdfdbca0b9cde262d.1286584677.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the generic functions out of this file, give
the functions more general names (e.g. remove "arm" from the names).

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   58 ++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 4f67cfa..fd6e323 100644
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
@@ -177,7 +177,7 @@ char *op_name_from_perf_id(void)
 	}
 }
 
-static int op_arm_create_files(struct super_block *sb, struct dentry *root)
+static int oprofile_perf_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
@@ -198,7 +198,7 @@ static int op_arm_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
-static int op_arm_setup(void)
+static int oprofile_perf_setup(void)
 {
 	spin_lock(&oprofilefs_lock);
 	op_perf_setup();
@@ -206,54 +206,54 @@ static int op_arm_setup(void)
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
-- 
1.7.1

