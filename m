Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1A2UVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 15:21:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62693 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1A2UVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 15:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W/MBVvSV5FSz8w7nrBwXW6HH6TZ9jU5qZsBTmMZSrfh4IMx8vEaGHO08odIv7u/YEj
         JJvYUL6i67rifqt6t/VYcG1HZWEhKlNN+jlKSSwSB7tzhfR/2JzUdBDFZCRwUZa7EqbT
         estYFkXtNQC8ZAgMVrCSGcqT/MagG084YWMJA=
From: Michael Rodriguez <dkingston02@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Michael Rodriguez <dkingston02@gmail.com>
Subject: [PATCH] kernel/cpu.c: Fix many errors related to style.
Date: Sat, 29 Jan 2011 15:19:19 -0500
Message-Id: <1296332359-21389-1-git-send-email-dkingston02@gmail.com>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the printk() calls to have the KERN_INFO/KERN_ERROR stuff,
and fixes other coding style errors. Not _all_ of them are gone, though.

Signed-off-by: Michael Rodriguez <dkingston02@gmail.com>
---
 kernel/cpu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 156cc55..d1851a7 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -160,7 +160,6 @@ static void cpu_notify_nofail(unsigned long val, void *v)
 {
 	BUG_ON(cpu_notify(val, v));
 }
-
 EXPORT_SYMBOL(register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
@@ -201,11 +200,11 @@ static int __ref take_cpu_down(void *_param)
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
+
 	if (err < 0)
 		return err;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
-
 	return 0;
 }
 
@@ -227,7 +226,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
+
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
@@ -304,7 +305,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk("%s: attempt to bring up CPU %u failed\n",
+		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
 		goto out_notify;
 	}
@@ -450,14 +451,14 @@ void __ref enable_nonboot_cpus(void)
 	if (cpumask_empty(frozen_cpus))
 		goto out;
 
-	printk("Enabling non-boot CPUs ...\n");
+	printk(KERN_INFO "Enabling non-boot CPUs ...\n");
 
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
-			printk("CPU%d is up\n", cpu);
+			printk(KERN_INFO "CPU%d is up\n", cpu);
 			continue;
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
@@ -509,7 +510,7 @@ void __cpuinit notify_cpu_starting(unsigned int cpu)
  */
 
 /* cpu_bit_bitmap[0] is empty - so we can back into it */
-#define MASK_DECLARE_1(x)	[x+1][0] = 1UL << (x)
+#define MASK_DECLARE_1(x)	[x+1][0] = (1UL << (x))
 #define MASK_DECLARE_2(x)	MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
 #define MASK_DECLARE_4(x)	MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
 #define MASK_DECLARE_8(x)	MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
-- 
1.7.3.5

