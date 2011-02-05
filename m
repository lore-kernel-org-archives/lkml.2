Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1BEOX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1BEOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QtXoIYqNyARhMP8ZxcGPPCITq9uHdTiaDJKjSo1NFoUNCQ2QNyExV7j95JY9FhYFSk
         FviH26+ZsWYGaOEm5Rmns9NZgs9Ix6MQsv2yt50YgFzpxiMdx8l6RV5hKUd/tiru1Jpa
         ciMMqMsPbDy8uLC0Ou7R8kAF1154XNL1IbFuA=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 48/52] kstrtox: convert powerpc
Date: Sat,  5 Feb 2011 16:20:51 +0200
Message-Id: <1296915654-7458-48-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/powerpc/kernel/setup_64.c            |    6 +++---
 arch/powerpc/kernel/vio.c                 |    4 ++--
 arch/powerpc/platforms/pseries/dlpar.c    |    4 ++--
 arch/powerpc/platforms/pseries/mobility.c |    2 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c     |    8 ++++----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 5a0401f..1e05bfc 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -113,13 +113,13 @@ static void check_smt_enabled(void)
 		else if (!strcmp(smt_enabled_cmdline, "off"))
 			smt_enabled_at_boot = 0;
 		else {
-			long smt;
+			int smt;
 			int rc;
 
-			rc = strict_strtol(smt_enabled_cmdline, 10, &smt);
+			rc = kstrtoint(smt_enabled_cmdline, 10, &smt);
 			if (!rc)
 				smt_enabled_at_boot =
-					min(threads_per_core, (int)smt);
+					min(threads_per_core, smt);
 		}
 	} else {
 		dn = of_find_node_by_path("/options");
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 1b695fd..c69d76f 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -946,10 +946,10 @@ static ssize_t viodev_cmo_desired_set(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
-	size_t new_desired;
+	unsigned long new_desired;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &new_desired);
+	ret = kstrtoul(buf, 10, &new_desired);
 	if (ret)
 		return ret;
 
diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index b74a923..c8a2e9e 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -403,12 +403,12 @@ out:
 static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 {
 	struct device_node *dn;
-	unsigned long drc_index;
+	u32 drc_index;
 	char *cpu_name;
 	int rc;
 
 	cpu_hotplug_driver_lock();
-	rc = strict_strtoul(buf, 0, &drc_index);
+	rc = kstrtou32(buf, 0, &drc_index);
 	if (rc) {
 		rc = -EINVAL;
 		goto out;
diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 3e7f651..5baeb2f 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -316,7 +316,7 @@ static ssize_t migrate_store(struct class *class, struct class_attribute *attr,
 	u64 streamid;
 	int rc;
 
-	rc = strict_strtoull(buf, 0, &streamid);
+	rc = kstrtou64(buf, 0, &streamid);
 	if (rc)
 		return rc;
 
diff --git a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
index cc8d655..d9b8b68 100644
--- a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
+++ b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
@@ -32,9 +32,9 @@ struct mpc85xx_l2ctlr __iomem *l2ctlr;
 
 static long get_cache_sram_size(void)
 {
-	unsigned long val;
+	unsigned int val;
 
-	if (!sram_size || (strict_strtoul(sram_size, 0, &val) < 0))
+	if (!sram_size || kstrtouint(sram_size, 0, &val) < 0)
 		return -EINVAL;
 
 	return val;
@@ -42,9 +42,9 @@ static long get_cache_sram_size(void)
 
 static long get_cache_sram_offset(void)
 {
-	unsigned long val;
+	unsigned int val;
 
-	if (!sram_offset || (strict_strtoul(sram_offset, 0, &val) < 0))
+	if (!sram_offset || kstrtouint(sram_offset, 0, &val) < 0)
 		return -EINVAL;
 
 	return val;
-- 
1.7.3.4

