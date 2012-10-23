Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab2JWUAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:00:55 -0400
Received: from woodbine.london.02.net ([87.194.255.145]:35257 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470Ab2JWUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:00:52 -0400
From: Matthew Leach <matthew@mattleach.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Matthew Leach <matthew@mattleach.net>
Subject: [PATCH v2] init: Use the stringify operator for the __define_initcall macro
Date: Tue, 23 Oct 2012 21:00:29 +0100
Message-Id: <1351022429-3242-1-git-send-email-matthew@mattleach.net>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the __define_initcall macro takes three arguments, fn, id
and level. The level argument is exactly the same as the id argument
but wrapped in quotes. To overcome this need to specify three
arguments to the __define_initcall macro, where one argument is the
stringification of another, we can just use the stringification macro
instead.

Signed-off-by: Matthew Leach <matthew@mattleach.net>
---
v2: Fix a build error where the ppc arch also uses the
__define_initcall macro. Also fix some styling issues.

 arch/powerpc/include/asm/machdep.h | 36 +++++++++++++++++-----------------
 include/linux/init.h               | 40 +++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index c423197..3c82daf 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -320,28 +320,28 @@ static inline void log_error(char *buf, unsigned int err_type, int fatal)
 		ppc_md.log_error(buf, err_type, fatal);
 }
 
-#define __define_machine_initcall(mach,level,fn,id) \
+#define __define_machine_initcall(mach, fn, id) \
 	static int __init __machine_initcall_##mach##_##fn(void) { \
 		if (machine_is(mach)) return fn(); \
 		return 0; \
 	} \
-	__define_initcall(level,__machine_initcall_##mach##_##fn,id);
-
-#define machine_core_initcall(mach,fn)		__define_machine_initcall(mach,"1",fn,1)
-#define machine_core_initcall_sync(mach,fn)	__define_machine_initcall(mach,"1s",fn,1s)
-#define machine_postcore_initcall(mach,fn)	__define_machine_initcall(mach,"2",fn,2)
-#define machine_postcore_initcall_sync(mach,fn)	__define_machine_initcall(mach,"2s",fn,2s)
-#define machine_arch_initcall(mach,fn)		__define_machine_initcall(mach,"3",fn,3)
-#define machine_arch_initcall_sync(mach,fn)	__define_machine_initcall(mach,"3s",fn,3s)
-#define machine_subsys_initcall(mach,fn)	__define_machine_initcall(mach,"4",fn,4)
-#define machine_subsys_initcall_sync(mach,fn)	__define_machine_initcall(mach,"4s",fn,4s)
-#define machine_fs_initcall(mach,fn)		__define_machine_initcall(mach,"5",fn,5)
-#define machine_fs_initcall_sync(mach,fn)	__define_machine_initcall(mach,"5s",fn,5s)
-#define machine_rootfs_initcall(mach,fn)	__define_machine_initcall(mach,"rootfs",fn,rootfs)
-#define machine_device_initcall(mach,fn)	__define_machine_initcall(mach,"6",fn,6)
-#define machine_device_initcall_sync(mach,fn)	__define_machine_initcall(mach,"6s",fn,6s)
-#define machine_late_initcall(mach,fn)		__define_machine_initcall(mach,"7",fn,7)
-#define machine_late_initcall_sync(mach,fn)	__define_machine_initcall(mach,"7s",fn,7s)
+	__define_initcall(__machine_initcall_##mach##_##fn, id);
+
+#define machine_core_initcall(mach, fn)		__define_machine_initcall(mach, fn, 1)
+#define machine_core_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 1s)
+#define machine_postcore_initcall(mach, fn)	__define_machine_initcall(mach, fn, 2)
+#define machine_postcore_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 2s)
+#define machine_arch_initcall(mach, fn)		__define_machine_initcall(mach, fn, 3)
+#define machine_arch_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 3s)
+#define machine_subsys_initcall(mach, fn)	__define_machine_initcall(mach, fn, 4)
+#define machine_subsys_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 4s)
+#define machine_fs_initcall(mach, fn)		__define_machine_initcall(mach, fn, 5)
+#define machine_fs_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 5s)
+#define machine_rootfs_initcall(mach, fn)	__define_machine_initcall(mach, fn, rootfs)
+#define machine_device_initcall(mach, fn)	__define_machine_initcall(mach, fn, 6)
+#define machine_device_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 6s)
+#define machine_late_initcall(mach, fn)		__define_machine_initcall(mach, fn, 7)
+#define machine_late_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 7s)
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_MACHDEP_H */
diff --git a/include/linux/init.h b/include/linux/init.h
index e59041e..1c2746f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -186,16 +186,16 @@ extern bool initcall_debug;
  * can point at the same handler without causing duplicate-symbol build errors.
  */
 
-#define __define_initcall(level,fn,id) \
+#define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" level ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn
 
 /*
  * Early initcalls run before initializing SMP.
  *
  * Only for built-in code, not modules.
  */
-#define early_initcall(fn)		__define_initcall("early",fn,early)
+#define early_initcall(fn)		__define_initcall(fn, early)
 
 /*
  * A "pure" initcall has no dependencies on anything else, and purely
@@ -204,23 +204,23 @@ extern bool initcall_debug;
  * This only exists for built-in code, not for modules.
  * Keep main.c:initcall_level_names[] in sync.
  */
-#define pure_initcall(fn)		__define_initcall("0",fn,0)
-
-#define core_initcall(fn)		__define_initcall("1",fn,1)
-#define core_initcall_sync(fn)		__define_initcall("1s",fn,1s)
-#define postcore_initcall(fn)		__define_initcall("2",fn,2)
-#define postcore_initcall_sync(fn)	__define_initcall("2s",fn,2s)
-#define arch_initcall(fn)		__define_initcall("3",fn,3)
-#define arch_initcall_sync(fn)		__define_initcall("3s",fn,3s)
-#define subsys_initcall(fn)		__define_initcall("4",fn,4)
-#define subsys_initcall_sync(fn)	__define_initcall("4s",fn,4s)
-#define fs_initcall(fn)			__define_initcall("5",fn,5)
-#define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
-#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
-#define device_initcall(fn)		__define_initcall("6",fn,6)
-#define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
-#define late_initcall(fn)		__define_initcall("7",fn,7)
-#define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
+#define pure_initcall(fn)		__define_initcall(fn, 0)
+
+#define core_initcall(fn)		__define_initcall(fn, 1)
+#define core_initcall_sync(fn)		__define_initcall(fn, 1s)
+#define postcore_initcall(fn)		__define_initcall(fn, 2)
+#define postcore_initcall_sync(fn)	__define_initcall(fn, 2s)
+#define arch_initcall(fn)		__define_initcall(fn, 3)
+#define arch_initcall_sync(fn)		__define_initcall(fn, 3s)
+#define subsys_initcall(fn)		__define_initcall(fn, 4)
+#define subsys_initcall_sync(fn)	__define_initcall(fn, 4s)
+#define fs_initcall(fn)			__define_initcall(fn, 5)
+#define fs_initcall_sync(fn)		__define_initcall(fn, 5s)
+#define rootfs_initcall(fn)		__define_initcall(fn, rootfs)
+#define device_initcall(fn)		__define_initcall(fn, 6)
+#define device_initcall_sync(fn)	__define_initcall(fn, 6s)
+#define late_initcall(fn)		__define_initcall(fn, 7)
+#define late_initcall_sync(fn)		__define_initcall(fn, 7s)
 
 #define __initcall(fn) device_initcall(fn)
 
-- 
1.7.12.4

