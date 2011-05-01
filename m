Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab1EABrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:47:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab1EABhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YdqA8qgHkz0vM8XUl3zZSxYC8ycaBbciFLEFIz1TZ0ngVnk3uZ5+Nul6aw2+lo3etD
         Asvt/seM9oqQsNKlH/f4aGGFnuPEMQexhf9kflRhnmJvN12cL0Wcrfv3ejtZtBs5/0BN
         UNzxcDuOGSEfxgKBbhl4KyzXocnuC9DamETtk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 49/69] sysctl: delete unused register_sysctl_table function
Date: Sun,  1 May 2011 03:36:19 +0200
Message-Id: <1304213799-10257-50-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h |    3 +--
 kernel/sysctl.c        |   26 ++------------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..470e06a 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -985,7 +985,7 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
 
 /*
- * Register a set of sysctl names by calling register_sysctl_table
+ * Register a set of sysctl names by calling __register_sysctl_paths
  * with an initialised array of struct ctl_table's.  An entry with 
  * NULL procname terminates the table.  table->de will be
  * set up by the registration and need not be initialised in advance.
@@ -1065,7 +1065,6 @@ void register_sysctl_root(struct ctl_table_root *root);
 struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table_root *root, struct nsproxy *namespaces,
 	const struct ctl_path *path, struct ctl_table *table);
-struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..b813724 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1905,7 +1905,7 @@ struct ctl_table_header *__register_sysctl_paths(
 }
 
 /**
- * register_sysctl_table_path - register a sysctl table hierarchy
+ * register_sysctl_paths - register a sysctl table hierarchy
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
@@ -1922,24 +1922,8 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 }
 
 /**
- * register_sysctl_table - register a sysctl table hierarchy
- * @table: the top-level table structure
- *
- * Register a sysctl table hierarchy. @table should be a filled in ctl_table
- * array. A completely 0 filled entry terminates the table.
- *
- * See register_sysctl_paths for more details.
- */
-struct ctl_table_header *register_sysctl_table(struct ctl_table *table)
-{
-	static const struct ctl_path null_path[] = { {} };
-
-	return register_sysctl_paths(null_path, table);
-}
-
-/**
  * unregister_sysctl_table - unregister a sysctl table hierarchy
- * @header: the header returned from register_sysctl_table
+ * @header: the header returned from __register_sysctl_paths
  *
  * Unregisters the sysctl table and all children. proc entries may not
  * actually be removed until they are no longer used by anyone.
@@ -1987,11 +1971,6 @@ void setup_sysctl_set(struct ctl_table_set *p,
 }
 
 #else /* !CONFIG_SYSCTL */
-struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
-{
-	return NULL;
-}
-
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						    struct ctl_table *table)
 {
@@ -2977,6 +2956,5 @@ EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
-EXPORT_SYMBOL(register_sysctl_table);
 EXPORT_SYMBOL(register_sysctl_paths);
 EXPORT_SYMBOL(unregister_sysctl_table);
-- 
1.7.5.134.g1c08b

