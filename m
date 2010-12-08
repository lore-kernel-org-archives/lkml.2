Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0LHILS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:11:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:53504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0LHILR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:11:17 -0500
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH] Show file_caps_enabled in /sys/kernel/fscaps
Date: Wed,  8 Dec 2010 09:11:15 +0100
Message-Id: <1291795875-22996-1-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace may need to decide whether it makes sense to install
fscaps on binaries and parsing /proc/cmdline is fragile.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 Documentation/ABI/testing/sysfs-kernel-fscaps |    8 ++++++++
 kernel/ksysfs.c                               |   10 ++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-fscaps

diff --git a/Documentation/ABI/testing/sysfs-kernel-fscaps b/Documentation/ABI/testing/sysfs-kernel-fscaps
new file mode 100644
index 0000000..b2ace0b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-fscaps
@@ -0,0 +1,8 @@
+What:		/sys/kernel/fscaps
+Date:		November 2010
+KernelVersion:	2.6.38
+Contact:	Ludwig Nussel <ludwig.nussel@suse.de>
+Description
+		Shows whether file system capabilities are honored
+		when executing a binary
+
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 0b624e7..3b053c0 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -16,6 +16,7 @@
 #include <linux/kexec.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/capability.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -131,6 +132,14 @@ KERNEL_ATTR_RO(vmcoreinfo);
 
 #endif /* CONFIG_KEXEC */
 
+/* whether file capabilities are enabled */
+static ssize_t fscaps_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", file_caps_enabled);
+}
+KERNEL_ATTR_RO(fscaps);
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -158,6 +167,7 @@ struct kobject *kernel_kobj;
 EXPORT_SYMBOL_GPL(kernel_kobj);
 
 static struct attribute * kernel_attrs[] = {
+	&fscaps_attr.attr,
 #if defined(CONFIG_HOTPLUG)
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
-- 
1.7.1

