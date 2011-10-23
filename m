Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1JWTF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:05:27 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36426 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1JWTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:05:25 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 00:34:59 +0530
Message-Id: <20111023190459.16364.98151.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V2 2/5] debugfs: Renaming of xen functions and change unsigned to u32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming of xen functions and change unsigned to u32.
    
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index fc506e6..14a8961 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -286,7 +286,7 @@ static int __init xen_spinlock_debugfs(void)
 	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
 			   &spinlock_stats.time_blocked);
 
-	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
 
 	return 0;
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 9aa12e3..68af40d 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -529,7 +529,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
 
 struct array_data {
 	void *array;
-	unsigned elements;
+	u32 elements;
 };
 
 static int u32_array_open(struct inode *inode, struct file *file)
@@ -539,10 +539,10 @@ static int u32_array_open(struct inode *inode, struct file *file)
 }
 
 static size_t format_array(char *buf, size_t bufsize, const char *fmt,
-			   u32 *array, unsigned array_size)
+			   u32 *array, u32 array_size)
 {
 	size_t ret = 0;
-	unsigned i;
+	u32 i;
 
 	for (i = 0; i < array_size; i++) {
 		size_t len;
@@ -566,7 +566,7 @@ static size_t format_array(char *buf, size_t bufsize, const char *fmt,
 }
 
 static char *format_array_alloc(const char *fmt, u32 *array,
-						unsigned array_size)
+						u32 array_size)
 {
 	size_t len = format_array(NULL, 0, fmt, array, array_size);
 	char *ret;
@@ -604,7 +604,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
 					file->private_data, size);
 }
 
-static int xen_array_release(struct inode *inode, struct file *file)
+static int u32_array_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
 
@@ -614,14 +614,14 @@ static int xen_array_release(struct inode *inode, struct file *file)
 static const struct file_operations u32_array_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = u32_array_open,
-	.release = xen_array_release,
+	.release = u32_array_release,
 	.read	 = u32_array_read,
 	.llseek  = no_llseek,
 };
 
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
 					    struct dentry *parent,
-					    u32 *array, unsigned elements)
+					    u32 *array, u32 elements)
 {
 	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 8c08636..253e2fb 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -74,9 +74,9 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
 
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
-					    struct dentry *parent,
-					    u32 *array, unsigned elements);
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					struct dentry *parent,
+					u32 *array, u32 elements);
 
 bool debugfs_initialized(void);
 
@@ -197,9 +197,9 @@ static inline bool debugfs_initialized(void)
 	return false;
 }
 
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
-					    struct dentry *parent,
-					    u32 *array, unsigned elements)
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					struct dentry *parent,
+					u32 *array, u32 elements)
 {
 	return ERR_PTR(-ENODEV);
 }
