Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2HSDAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:64945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2HSC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422051"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/74] sections: Add __visible to kernel/* sections
Date: Sat, 18 Aug 2012 19:56:10 -0700
Message-Id: <1345345030-22211-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/extable.c  |    4 ++--
 kernel/ksysfs.c   |    4 ++--
 kernel/module.c   |   30 +++++++++++++++---------------
 kernel/params.c   |    6 +++---
 kernel/spinlock.c |    2 +-
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index fe35a63..2328718 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -32,8 +32,8 @@
  */
 DEFINE_MUTEX(text_mutex);
 
-extern struct exception_table_entry __start___ex_table[];
-extern struct exception_table_entry __stop___ex_table[];
+extern __visible struct exception_table_entry __start___ex_table[];
+extern __visible struct exception_table_entry __stop___ex_table[];
 
 /* Cleared by build time tools if the table is already sorted. */
 u32 __initdata main_extable_sort_needed = 1;
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..627314f 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -144,8 +144,8 @@ KERNEL_ATTR_RO(fscaps);
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
-extern const void __start_notes __attribute__((weak));
-extern const void __stop_notes __attribute__((weak));
+extern __visible const void __start_notes __attribute__((weak));
+extern __visible const void __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
 static ssize_t notes_read(struct file *filp, struct kobject *kobj,
diff --git a/kernel/module.c b/kernel/module.c
index 4edbd9c..c00565a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -206,22 +206,22 @@ static void *section_objs(const struct load_info *info,
 }
 
 /* Provided by the linker */
-extern const struct kernel_symbol __start___ksymtab[];
-extern const struct kernel_symbol __stop___ksymtab[];
-extern const struct kernel_symbol __start___ksymtab_gpl[];
-extern const struct kernel_symbol __stop___ksymtab_gpl[];
-extern const struct kernel_symbol __start___ksymtab_gpl_future[];
-extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
-extern const unsigned long __start___kcrctab[];
-extern const unsigned long __start___kcrctab_gpl[];
-extern const unsigned long __start___kcrctab_gpl_future[];
+extern __visible const struct kernel_symbol __start___ksymtab[];
+extern __visible const struct kernel_symbol __stop___ksymtab[];
+extern __visible const struct kernel_symbol __start___ksymtab_gpl[];
+extern __visible const struct kernel_symbol __stop___ksymtab_gpl[];
+extern __visible const struct kernel_symbol __start___ksymtab_gpl_future[];
+extern __visible const struct kernel_symbol __stop___ksymtab_gpl_future[];
+extern __visible const unsigned long __start___kcrctab[];
+extern __visible const unsigned long __start___kcrctab_gpl[];
+extern __visible const unsigned long __start___kcrctab_gpl_future[];
 #ifdef CONFIG_UNUSED_SYMBOLS
-extern const struct kernel_symbol __start___ksymtab_unused[];
-extern const struct kernel_symbol __stop___ksymtab_unused[];
-extern const struct kernel_symbol __start___ksymtab_unused_gpl[];
-extern const struct kernel_symbol __stop___ksymtab_unused_gpl[];
-extern const unsigned long __start___kcrctab_unused[];
-extern const unsigned long __start___kcrctab_unused_gpl[];
+extern __visible const struct kernel_symbol __start___ksymtab_unused[];
+extern __visible const struct kernel_symbol __stop___ksymtab_unused[];
+extern __visible const struct kernel_symbol __start___ksymtab_unused_gpl[];
+extern __visible const struct kernel_symbol __stop___ksymtab_unused_gpl[];
+extern __visible const unsigned long __start___kcrctab_unused[];
+extern __visible const unsigned long __start___kcrctab_unused_gpl[];
 #endif
 
 #ifndef CONFIG_MODVERSIONS
diff --git a/kernel/params.c b/kernel/params.c
index ed35345..c3e61dc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -503,7 +503,7 @@ EXPORT_SYMBOL(param_ops_string);
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
-extern struct kernel_param __start___param[], __stop___param[];
+extern __visible struct kernel_param __start___param[], __stop___param[];
 
 struct param_attribute
 {
@@ -827,8 +827,8 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
 	return sprintf(buf, "%s\n", vattr->version);
 }
 
-extern const struct module_version_attribute *__start___modver[];
-extern const struct module_version_attribute *__stop___modver[];
+extern __visible const struct module_version_attribute *__start___modver[];
+extern __visible const struct module_version_attribute *__stop___modver[];
 
 static void __init version_sysfs_builtin(void)
 {
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 5cdd806..75439be 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -377,7 +377,7 @@ EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
 notrace int in_lock_functions(unsigned long addr)
 {
 	/* Linker adds these: start and end of __lockfunc functions */
-	extern char __lock_text_start[], __lock_text_end[];
+	extern __visible char __lock_text_start[], __lock_text_end[];
 
 	return addr >= (unsigned long)__lock_text_start
 	&& addr < (unsigned long)__lock_text_end;
-- 
1.7.7.6

