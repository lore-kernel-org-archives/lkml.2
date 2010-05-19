Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0ERRst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:48:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:17036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab0ERRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="278573822"
Subject: [RFC][PATCH v2 08/11] sysfs: introduce new interface
 sysfs_get_kobject
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:48:43 +0000
Message-Id: <1274233723.3036.87.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need this interface in the later sysfs pmu lookup.

struct kobject *sysfs_get_kobject(struct file *file);
Return the relative kobject of the sysfs file.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 fs/sysfs/file.c       |   15 +++++++++++++++
 include/linux/sysfs.h |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e222b25..0c5d6fe 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -748,6 +748,21 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 }
 EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
 
+struct kobject *sysfs_get_kobject(struct file *file)
+{
+	struct sysfs_dirent *attr_sd;
+	struct kobject *kobj;
+
+	if (!file)
+		return NULL;
+	if (file->f_op != &sysfs_file_operations)
+		return NULL;
+
+	attr_sd = file->f_path.dentry->d_fsdata;
+	kobj = attr_sd->s_parent->s_dir.kobj;
+
+	return kobj;
+}
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f0496b3..5954234 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -121,6 +121,8 @@ struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
 
+struct kobject *sysfs_get_kobject(struct file *file);
+
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 			    void *data, struct module *owner);
 




