Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2I1Bkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:40:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34518 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2I1Bkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:40:49 -0400
From: Josh Taylor <joshua.taylor0@gmail.com>
To: tglx@linutronix.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Josh Taylor <joshua.taylor0@gmail.com>
Subject: [PATCH 2/2] Kernel: cpu: Fixed style issues
Date: Thu, 27 Sep 2012 21:40:24 -0400
Message-Id: <1348796424-32426-1-git-send-email-joshua.taylor0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected 'pr_err' and 'pr_warn' issues

Signed-off-by: Josh Taylor <joshua.taylor0@gmail.com>
---
 kernel/cpu.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 14d3258..0c09ae1 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -225,7 +225,7 @@ static inline void check_for_tasks(int cpu)
 	for_each_process(p) {
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (p->utime || p->stime))
-			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
+			pr_warn("Task %s (pid = %d) is on cpu %d "
 				"(state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
 				p->state, p->flags);
@@ -276,8 +276,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
-				__func__, cpu);
+		pr_err("%s: attempt to take down CPU %u failed\n",
+			__func__, cpu);
 		goto out_release;
 	}
 
@@ -357,7 +357,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
+		pr_warn("%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
 		goto out_notify;
 	}
@@ -390,10 +390,10 @@ int __cpuinit cpu_up(unsigned int cpu)
 #endif
 
 	if (!cpu_possible(cpu)) {
-		printk(KERN_ERR "can't online cpu %d because it is not "
+		pr_err("can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
 #if defined(CONFIG_IA64)
-		printk(KERN_ERR "please check additional_cpus= boot "
+		pr_err("please check additional_cpus= boot "
 				"parameter\n");
 #endif
 		return -EINVAL;
@@ -409,8 +409,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 	pgdat = NODE_DATA(nid);
 	if (!pgdat) {
-		printk(KERN_ERR
-			"Can't online cpu %d due to NULL pgdat\n", cpu);
+		pr_err("Can't online cpu %d due to NULL pgdat\n", cpu);
 		return -ENOMEM;
 	}
 
@@ -460,7 +459,7 @@ int disable_nonboot_cpus(void)
 	cpumask_clear(frozen_cpus);
 	arch_disable_nonboot_cpus_begin();
 
-	printk("Disabling non-boot CPUs ...\n");
+	pr_warn("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
@@ -468,8 +467,7 @@ int disable_nonboot_cpus(void)
 		if (!error)
 			cpumask_set_cpu(cpu, frozen_cpus);
 		else {
-			printk(KERN_ERR "Error taking CPU%d down: %d\n",
-				cpu, error);
+			pr_err("Error taking CPU%d down: %d\n",	cpu, error);
 			break;
 		}
 	}
@@ -481,7 +479,7 @@ int disable_nonboot_cpus(void)
 		/* Make sure the CPUs won't be enabled by someone else */
 		cpu_hotplug_disabled = 1;
 	} else {
-		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
+		pr_err("Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
 	return error;
@@ -505,17 +503,17 @@ void __ref enable_nonboot_cpus(void)
 	if (cpumask_empty(frozen_cpus))
 		goto out;
 
-	printk(KERN_INFO "Enabling non-boot CPUs ...\n");
+	pr_warn("Enabling non-boot CPUs ...\n");
 
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
-			printk(KERN_INFO "CPU%d is up\n", cpu);
+			pr_info("CPU%d is up\n", cpu);
 			continue;
 		}
-		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
+		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
 	}
 
 	arch_enable_nonboot_cpus_end();
-- 
1.7.9.5

