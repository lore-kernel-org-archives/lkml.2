Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0EMCJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:09:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:51202 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0EMCJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:09:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,218,1272870000"; 
   d="scan'208";a="276508039"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -v2 1/2] Add x64 support to debugfs
Date: Thu, 13 May 2010 10:09:22 +0800
Message-Id: <1273716563-23573-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273716563-23573-1-git-send-email-ying.huang@intel.com>
References: <1273716563-23573-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs_create_x64. This is needed by ACPI APEI EINJ parameters support.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c       |   21 ++++++++++++++++++++-
 include/linux/debugfs.h |    2 ++
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -277,8 +277,10 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugf
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32_ro, debugfs_u32_get, NULL, "0x%08llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32_wo, NULL, debugfs_u32_set, "0x%08llx\n");
 
+DEFINE_SIMPLE_ATTRIBUTE(fops_x64, debugfs_u64_get, debugfs_u64_set, "0x%016llx\n");
+
 /*
- * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
+ * debugfs_create_x{8,16,32,64} - create a debugfs file that is used to read and write an unsigned {8,16,32,64}-bit value
  *
  * These functions are exactly the same as the above functions (but use a hex
  * output for the decimal challenged). For details look at the above unsigned
@@ -357,6 +359,23 @@ struct dentry *debugfs_create_x32(const
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x32);
 
+/**
+ * debugfs_create_x64 - create a debugfs file that is used to read and write an unsigned 64-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				 struct dentry *parent, u64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x64);
+
 
 static int debugfs_size_t_set(void *data, u64 val)
 {
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -63,6 +63,8 @@ struct dentry *debugfs_create_x16(const
 				  struct dentry *parent, u16 *value);
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				  struct dentry *parent, u64 *value);
 struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
 				     struct dentry *parent, size_t *value);
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
