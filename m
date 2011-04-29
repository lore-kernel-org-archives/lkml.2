Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab1D2Q2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:28:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47772 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837Ab1D2Q2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ks41fUQfNbLWzKOEJQnXg2RUcs/HCrPbQkSFUoslCdElBm38zSInv5+olmmgaHG1/E
         ZlEFvcoTNDqbh7L98m2Kd+FpyR4J8VIrQvfrG9OvAN6y5j9+/TgF6h/wx5IOxubj9MT3
         3W9yULjJLAj99ZO6CkTYDFPjBk3OAeirfcX9I=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH] acpi-cpufreq.c: Fix return statements.
Date: Fri, 29 Apr 2011 13:28:02 -0300
Message-Id: <1304094482-32445-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.5.g60e19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return statement is not a function so remove superfluous use of parenthesis.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
index 22f6152..af35a9b 100644
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
+++ b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -209,7 +209,7 @@ processor_set_freq (
 
 migrate_end:
 	set_cpus_allowed_ptr(current, &saved_mask);
-	return (retval);
+	return retval;
 }
 
 
@@ -240,11 +240,11 @@ acpi_cpufreq_target (
 	result = cpufreq_frequency_table_target(policy,
 			data->freq_table, target_freq, relation, &next_state);
 	if (result)
-		return (result);
+		return result;
 
 	result = processor_set_freq(data, policy->cpu, next_state);
 
-	return (result);
+	return result;
 }
 
 
@@ -260,7 +260,7 @@ acpi_cpufreq_verify (
 	result = cpufreq_frequency_table_verify(policy,
 			data->freq_table);
 
-	return (result);
+	return result;
 }
 
 
@@ -277,7 +277,7 @@ acpi_cpufreq_cpu_init (
 
 	data = kzalloc(sizeof(struct cpufreq_acpi_io), GFP_KERNEL);
 	if (!data)
-		return (-ENOMEM);
+		return -ENOMEM;
 
 	acpi_io_data[cpu] = data;
 
@@ -363,7 +363,7 @@ acpi_cpufreq_cpu_init (
 	 * writing something to the appropriate registers. */
 	data->resume = 1;
 
-	return (result);
+	return result;
 
  err_freqfree:
 	kfree(data->freq_table);
@@ -373,7 +373,7 @@ acpi_cpufreq_cpu_init (
 	kfree(data);
 	acpi_io_data[cpu] = NULL;
 
-	return (result);
+	return result;
 }
 
 
@@ -393,7 +393,7 @@ acpi_cpufreq_cpu_exit (
 		kfree(data);
 	}
 
-	return (0);
+	return 0;
 }
 
 
@@ -430,7 +430,6 @@ acpi_cpufreq_exit (void)
 	dprintk("acpi_cpufreq_exit\n");
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
-	return;
 }
 
 
-- 
1.7.5.rc2.5.g60e19

