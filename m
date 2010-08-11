Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0HKNoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:44:17 -0400
Received: from mx1.spunky.mail.dreamhost.com ([208.97.132.47]:51415 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389Ab0HKNoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:44:16 -0400
Subject: [PATCH] kernel/ksysfs: use snprintf for sysfs show
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: LKML <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org, gregkh@suse.de
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:44:10 -0400
Message-ID: <1281534250.2067.14.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snprintf(buf, PAGE_SIZE, ...) instead of sprintf for sysfs show
methods.  This is suggested in Documentation/filesystems/sysfs.txt

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/ksysfs.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 0b624e7..d7cef25 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -29,7 +29,9 @@ static struct kobj_attribute _name##_attr = \
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%llu\n", (unsigned long long)uevent_seqnum);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", 
+			(unsigned long long)uevent_seqnum); 
+
 }
 KERNEL_ATTR_RO(uevent_seqnum);
 
@@ -37,7 +39,7 @@ KERNEL_ATTR_RO(uevent_seqnum);
 static ssize_t uevent_helper_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", uevent_helper);
+	return snprintf(buf, PAGE_SIZE, "%s\n", uevent_helper);
 }
 static ssize_t uevent_helper_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -58,7 +60,7 @@ KERNEL_ATTR_RW(uevent_helper);
 static ssize_t profiling_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", prof_on);
+	return snprintf(buf, PAGE_SIZE, "%d\n", prof_on);
 }
 static ssize_t profiling_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -89,21 +91,21 @@ KERNEL_ATTR_RW(profiling);
 static ssize_t kexec_loaded_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", !!kexec_image);
+	return snprintf(buf, PAGE_SIZE, "%d\n", !!kexec_image);
 }
 KERNEL_ATTR_RO(kexec_loaded);
 
 static ssize_t kexec_crash_loaded_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", !!kexec_crash_image);
+	return snprintf(buf, PAGE_SIZE, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%zu\n", crash_get_memory_size());
+	return snprintf(buf, PAGE_SIZE, "%zu\n", crash_get_memory_size());
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -123,9 +125,9 @@ KERNEL_ATTR_RW(kexec_crash_size);
 static ssize_t vmcoreinfo_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lx %x\n",
-		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+	return snprintf(buf, PAGE_SIZE, "%lx %x\n",
+			paddr_vmcoreinfo_note(),
+			(unsigned int)vmcoreinfo_max_size);
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
-- 
1.7.0.4

