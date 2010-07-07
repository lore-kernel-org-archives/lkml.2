Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0GGVku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0GGVkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH 08/18] selinux: use generic_file_llseek
Date: Wed,  7 Jul 2010 23:40:10 +0200
Message-Id: <1278538820-1392-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Qaftm4QPGi/ofXcbdKia5trwXrI72MxCq9sW+8KQ1xG
 9gB0PgmvxBHHxZiNbCACnElN2qUe4nhgfu1tq6A8uaZF9m8Mcg
 5ajmOcu1h3xBBJoKX2Z484Y7lec4B2IfyqvkHi7nbAaJKzm3p3
 GFpKvey1zBXLFpd4RetimjzC9zrB/be9wUyYpN9XV9ibK1ZNUH
 /AvwAoMfR50LJ+jRsMvpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default for llseek will change to no_llseek,
so selinuxfs needs to add explicit .llseek
assignments. Since we're dealing with regular
files from a VFS perspective, use generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: linux-security-module@vger.kernel.org
---
 security/selinux/selinuxfs.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 0293843..79a1bb6 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -184,6 +184,7 @@ out:
 static const struct file_operations sel_enforce_ops = {
 	.read		= sel_read_enforce,
 	.write		= sel_write_enforce,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_read_handle_unknown(struct file *filp, char __user *buf,
@@ -201,6 +202,7 @@ static ssize_t sel_read_handle_unknown(struct file *filp, char __user *buf,
 
 static const struct file_operations sel_handle_unknown_ops = {
 	.read		= sel_read_handle_unknown,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
@@ -251,6 +253,7 @@ out:
 
 static const struct file_operations sel_disable_ops = {
 	.write		= sel_write_disable,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_read_policyvers(struct file *filp, char __user *buf,
@@ -265,6 +268,7 @@ static ssize_t sel_read_policyvers(struct file *filp, char __user *buf,
 
 static const struct file_operations sel_policyvers_ops = {
 	.read		= sel_read_policyvers,
+	.llseek		= generic_file_llseek,
 };
 
 /* declaration for sel_write_load */
@@ -289,6 +293,7 @@ static ssize_t sel_read_mls(struct file *filp, char __user *buf,
 
 static const struct file_operations sel_mls_ops = {
 	.read		= sel_read_mls,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_write_load(struct file *file, const char __user *buf,
@@ -356,6 +361,7 @@ out:
 
 static const struct file_operations sel_load_ops = {
 	.write		= sel_write_load,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_write_context(struct file *file, char *buf, size_t size)
@@ -437,6 +443,7 @@ out:
 static const struct file_operations sel_checkreqprot_ops = {
 	.read		= sel_read_checkreqprot,
 	.write		= sel_write_checkreqprot,
+	.llseek		= generic_file_llseek,
 };
 
 /*
@@ -482,6 +489,7 @@ static const struct file_operations transaction_ops = {
 	.write		= selinux_transaction_write,
 	.read		= simple_transaction_read,
 	.release	= simple_transaction_release,
+	.llseek		= generic_file_llseek,
 };
 
 /*
@@ -883,6 +891,7 @@ out:
 static const struct file_operations sel_bool_ops = {
 	.read		= sel_read_bool,
 	.write		= sel_write_bool,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_commit_bools_write(struct file *filep,
@@ -935,6 +944,7 @@ out:
 
 static const struct file_operations sel_commit_bools_ops = {
 	.write		= sel_commit_bools_write,
+	.llseek		= generic_file_llseek,
 };
 
 static void sel_remove_entries(struct dentry *de)
@@ -1127,10 +1137,12 @@ out:
 static const struct file_operations sel_avc_cache_threshold_ops = {
 	.read		= sel_read_avc_cache_threshold,
 	.write		= sel_write_avc_cache_threshold,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations sel_avc_hash_stats_ops = {
 	.read		= sel_read_avc_hash_stats,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_SECURITY_SELINUX_AVC_STATS
@@ -1255,6 +1267,7 @@ static ssize_t sel_read_initcon(struct file *file, char __user *buf,
 
 static const struct file_operations sel_initcon_ops = {
 	.read		= sel_read_initcon,
+	.llseek		= generic_file_llseek,
 };
 
 static int sel_make_initcon_files(struct dentry *dir)
@@ -1330,6 +1343,7 @@ out:
 
 static const struct file_operations sel_class_ops = {
 	.read		= sel_read_class,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_read_perm(struct file *file, char __user *buf,
@@ -1354,6 +1368,7 @@ out:
 
 static const struct file_operations sel_perm_ops = {
 	.read		= sel_read_perm,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t sel_read_policycap(struct file *file, char __user *buf,
@@ -1372,6 +1387,7 @@ static ssize_t sel_read_policycap(struct file *file, char __user *buf,
 
 static const struct file_operations sel_policycap_ops = {
 	.read		= sel_read_policycap,
+	.llseek		= generic_file_llseek,
 };
 
 static int sel_make_perm_files(char *objclass, int classvalue,
-- 
1.7.1

