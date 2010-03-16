Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938201Ab0CPRsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938084Ab0CPRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:02 -0400
Date: Tue, 16 Mar 2010 13:46:21 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <fbdd4e2137bb5c2e42a237e71e9e1ddfd4a33465.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 03/14] compat: have generic is_compat_task for !CONFIG_COMPAT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

add generic is_compat_task()

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/compat.h  |    7 -------
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/mm/mmap.c             |    2 +-
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 include/linux/compat.h          |    7 +++++++
 11 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 01a0802..442795c 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -171,13 +171,6 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_31BIT);
 }
 
-#else
-
-static inline int is_compat_task(void)
-{
-	return 0;
-}
-
 #endif
 
 static inline void __user *compat_alloc_user_space(long len)
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 7cf4642..f69079f 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -36,8 +36,8 @@
 #include <linux/regset.h>
 #include <linux/tracehook.h>
 #include <linux/seccomp.h>
+#include <linux/compat.h>
 #include <trace/syscall.h>
-#include <asm/compat.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 8d8957b..b30d9ff 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -43,7 +43,7 @@
 #include <linux/reboot.h>
 #include <linux/topology.h>
 #include <linux/ftrace.h>
-
+#include <linux/compat.h>
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 869efba..b7669c5 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,8 +27,8 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <asm/pgalloc.h>
-#include <asm/compat.h>
 
 /*
  * Top of mmap area (just below the process stack).
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 1cca21a..9b9b444 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -14,6 +14,7 @@
 
 #include <linux/stddef.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/hdreg.h>	/* HDIO_GETGEO			    */
 #include <linux/bio.h>
@@ -23,7 +24,6 @@
 #include <asm/debug.h>
 #include <asm/idals.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/cio.h>
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 7039d9c..407726a 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/blkpg.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include <asm/cmb.h>
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 31c59b0..83a353a 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 921dcda..c29e3ad 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index c84ac94..93536eb 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index 0eb6eef..274140f 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include "zfcp_def.h"
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ef68119..2fca741 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -353,5 +353,12 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+#else /* CONFIG_COMPAT */
+
+static inline int is_compat_task(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
-- 
1.6.5.1

