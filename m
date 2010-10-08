Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0JHFvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:51:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:3282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0JHFvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,301,1283756400"; 
   d="scan'208";a="614564574"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, guenter.roeck@ericsson.com,
        linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH V2 2/2] hwmon: cleanup some hotplug related macro definition
Date: Fri,  8 Oct 2010 13:53:36 +0800
Message-Id: <1286517216-15640-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
In-Reply-To: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
References: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG_CPU is used too much in some drivers.
This patch clean them up and add some proper __cpuinit definitons.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/hwmon/coretemp.c    |    5 ++---
 drivers/hwmon/pkgtemp.c     |    9 ++-------
 drivers/hwmon/via-cputemp.c |    9 ++-------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index a23b17a..2ec3cc3 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -490,7 +490,7 @@ exit:
 	return err;
 }
 
-static void coretemp_device_remove(unsigned int cpu)
+static void __cpuinit coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p;
 	unsigned int i;
@@ -569,9 +569,8 @@ exit:
 static void __exit coretemp_exit(void)
 {
 	struct pdev_entry *p, *n;
-#ifdef CONFIG_HOTPLUG_CPU
+
 	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
-#endif
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		platform_device_unregister(p->pdev);
diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index 29fef42..ee22313 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -340,8 +340,7 @@ exit:
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void pkgtemp_device_remove(unsigned int cpu)
+static void __cpuinit pkgtemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p;
 	unsigned int i;
@@ -388,7 +387,6 @@ static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
 static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 	.notifier_call = pkgtemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
 
 static int __init pkgtemp_init(void)
 {
@@ -412,9 +410,7 @@ static int __init pkgtemp_init(void)
 	}
 #endif
 
-#ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
-#endif
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
@@ -428,9 +424,8 @@ exit:
 static void __exit pkgtemp_exit(void)
 {
 	struct pdev_entry *p, *n;
-#ifdef CONFIG_HOTPLUG_CPU
+
 	unregister_hotcpu_notifier(&pkgtemp_cpu_notifier);
-#endif
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		platform_device_unregister(p->pdev);
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index ffb793a..ebbdc25 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -237,8 +237,7 @@ exit:
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void via_cputemp_device_remove(unsigned int cpu)
+static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	mutex_lock(&pdev_list_mutex);
@@ -272,7 +271,6 @@ static int __cpuinit via_cputemp_cpu_callback(struct notifier_block *nfb,
 static struct notifier_block via_cputemp_cpu_notifier __refdata = {
 	.notifier_call = via_cputemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
 
 static int __init via_cputemp_init(void)
 {
@@ -313,9 +311,7 @@ static int __init via_cputemp_init(void)
 		goto exit_driver_unreg;
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
-#endif
 	return 0;
 
 exit_devices_unreg:
@@ -335,9 +331,8 @@ exit:
 static void __exit via_cputemp_exit(void)
 {
 	struct pdev_entry *p, *n;
-#ifdef CONFIG_HOTPLUG_CPU
+
 	unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
-#endif
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		platform_device_unregister(p->pdev);
-- 
1.7.2.2.173.g515cc

