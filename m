Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab0IZF57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 01:57:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:45140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0IZF5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 01:57:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,237,1283756400"; 
   d="scan'208";a="328788748"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 2/2] hwmon: cleanup some hotplug related macro definition
Date: Sun, 26 Sep 2010 14:00:00 +0800
Message-Id: <1285480800-14558-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
In-Reply-To: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
References: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG_CPU is used too much in some drivers.
This patch clean them up and add some proper __cpuinit definitons.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/hwmon/coretemp.c    |    5 ++---
 drivers/hwmon/pkgtemp.c     |    7 ++-----
 drivers/hwmon/via-cputemp.c |    9 ++-------
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index baa842a..887ab93 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -489,7 +489,7 @@ exit:
 	return err;
 }
 
-static void coretemp_device_remove(unsigned int cpu)
+static void __cpuinit coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p;
 	unsigned int i;
@@ -568,9 +568,8 @@ exit:
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
index 6186041..0516d52 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -339,8 +339,7 @@ exit:
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void pkgtemp_device_remove(unsigned int cpu)
+static void __cpuinit pkgtemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p;
 	unsigned int i;
@@ -387,7 +386,6 @@ static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
 static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 	.notifier_call = pkgtemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
 
 static int __init pkgtemp_init(void)
 {
@@ -425,9 +423,8 @@ exit:
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

