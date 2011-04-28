Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab1D1XnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:43:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1D1Xm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ktJYcQ8h6rfxs9Q+r8bi2n2TM+c+AF7zEtwew78tlBgy5S3pnAMzfG+WGPh5zmVtYp
         6uLHfSUYfnY6ZrdcFV7cbVhCsZdVAYH4nUjZNrRsiqLDFXEw4ZKMtZqWjTV2yv76lCeu
         jOxNLmETF4Eg/WNXQOm3msbxlQoEnd+9XGlmw=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq.h: Fix some checkpatch.pl coding style issues.
Date: Thu, 28 Apr 2011 20:42:53 -0300
Message-Id: <1304034173-5379-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.5.g60e19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
$ scripts/checkpatch.pl --file --terse include/linux/cpufreq.h
total: 14 errors, 11 warnings, 419 lines checked

After:
$ scripts/checkpatch.pl --file --terse include/linux/cpufreq.h
total: 2 errors, 4 warnings, 422 lines checked

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 include/linux/cpufreq.h |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 9343dd3..d0d35df 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2001 Russell King
  *            (C) 2002 - 2003 Dominik Brodowski <linux@brodo.de>
- *            
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -56,9 +56,9 @@ static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
 #define CPUFREQ_POLICY_POWERSAVE	(1)
 #define CPUFREQ_POLICY_PERFORMANCE	(2)
 
-/* Frequency values here are CPU kHz so that hardware which doesn't run 
- * with some frequencies can complain without having to guess what per 
- * cent / per mille means. 
+/* Frequency values here are CPU kHz so that hardware which doesn't run
+ * with some frequencies can complain without having to guess what per
+ * cent / per mille means.
  * Maximum transition latency is in nanoseconds - if it's unknown,
  * CPUFREQ_ETERNAL shall be used.
  */
@@ -72,13 +72,15 @@ extern struct kobject *cpufreq_global_kobject;
 struct cpufreq_cpuinfo {
 	unsigned int		max_freq;
 	unsigned int		min_freq;
-	unsigned int		transition_latency; /* in 10^(-9) s = nanoseconds */
+
+	/* in 10^(-9) s = nanoseconds */
+	unsigned int		transition_latency;
 };
 
 struct cpufreq_real_policy {
 	unsigned int		min;    /* in kHz */
 	unsigned int		max;    /* in kHz */
-        unsigned int		policy; /* see above */
+	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 };
 
@@ -94,7 +96,7 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
-        unsigned int		policy; /* see above */
+	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 
 	struct work_struct	update; /* if update_policy() needs to be
@@ -167,11 +169,11 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
 
 struct cpufreq_governor {
 	char	name[CPUFREQ_NAME_LEN];
-	int 	(*governor)	(struct cpufreq_policy *policy,
+	int	(*governor)	(struct cpufreq_policy *policy,
 				 unsigned int event);
 	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
 					 char *buf);
-	int 	(*store_setspeed)	(struct cpufreq_policy *policy,
+	int	(*store_setspeed)	(struct cpufreq_policy *policy,
 					 unsigned int freq);
 	unsigned int max_transition_latency; /* HW must be able to switch to
 			next freq faster than this value in nano secs or we
@@ -180,7 +182,8 @@ struct cpufreq_governor {
 	struct module		*owner;
 };
 
-/* pass a target to the cpufreq driver 
+/*
+ * Pass a target to the cpufreq driver.
  */
 extern int cpufreq_driver_target(struct cpufreq_policy *policy,
 				 unsigned int target_freq,
@@ -237,9 +240,9 @@ struct cpufreq_driver {
 
 /* flags */
 
-#define CPUFREQ_STICKY		0x01	/* the driver isn't removed even if 
+#define CPUFREQ_STICKY		0x01	/* the driver isn't removed even if
 					 * all ->init() calls failed */
-#define CPUFREQ_CONST_LOOPS 	0x02	/* loops_per_jiffy or other kernel
+#define CPUFREQ_CONST_LOOPS	0x02	/* loops_per_jiffy or other kernel
 					 * "constants" aren't affected by
 					 * frequency transitions */
 #define CPUFREQ_PM_NO_WARN	0x04	/* don't warn on suspend/resume speed
@@ -252,7 +255,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state);
 
 
-static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy, unsigned int min, unsigned int max) 
+static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy, unsigned int min, unsigned int max)
 {
 	if (policy->min < min)
 		policy->min = min;
@@ -386,12 +389,12 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
-void   cpufreq_cpu_put (struct cpufreq_policy *data);
+void   cpufreq_cpu_put(struct cpufreq_policy *data);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
 
-void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table, 
+void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
@@ -407,12 +410,12 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 
 #ifdef CONFIG_CPU_FREQ_DEBUG
 
-extern void cpufreq_debug_printk(unsigned int type, const char *prefix, 
+extern void cpufreq_debug_printk(unsigned int type, const char *prefix,
 				 const char *fmt, ...);
 
 #else
 
-#define cpufreq_debug_printk(msg...) do { } while(0)
+#define cpufreq_debug_printk(msg...) do { } while (0)
 
 #endif /* CONFIG_CPU_FREQ_DEBUG */
 
-- 
1.7.5.rc2.5.g60e19

