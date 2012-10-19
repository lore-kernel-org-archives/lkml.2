Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2JSNJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:09:04 -0400
Received: from woodbine.london.02.net ([87.194.255.145]:59450 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab2JSNJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:09:03 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 09:09:02 EDT
From: Matthew Leach <matthew@mattleach.net>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, Matthew Leach <matthew@mattleach.net>
Subject: [RFC PATCH] init: Use the stringify operator for the __define_initcall macro
Date: Fri, 19 Oct 2012 13:58:56 +0100
Message-Id: <1350651536-29834-1-git-send-email-matthew@mattleach.net>
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
 include/linux/init.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e59041e..eaa3851 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -186,16 +186,16 @@ extern bool initcall_debug;
  * can point at the same handler without causing duplicate-symbol build errors.
  */
 
-#define __define_initcall(level,fn,id) \
+#define __define_initcall(fn,id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" level ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn
 
 /*
  * Early initcalls run before initializing SMP.
  *
  * Only for built-in code, not modules.
  */
-#define early_initcall(fn)		__define_initcall("early",fn,early)
+#define early_initcall(fn)		__define_initcall(fn,early)
 
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
+#define pure_initcall(fn)		__define_initcall(fn,0)
+
+#define core_initcall(fn)		__define_initcall(fn,1)
+#define core_initcall_sync(fn)		__define_initcall(fn,1s)
+#define postcore_initcall(fn)		__define_initcall(fn,2)
+#define postcore_initcall_sync(fn)	__define_initcall(fn,2s)
+#define arch_initcall(fn)		__define_initcall(fn,3)
+#define arch_initcall_sync(fn)		__define_initcall(fn,3s)
+#define subsys_initcall(fn)		__define_initcall(fn,4)
+#define subsys_initcall_sync(fn)	__define_initcall(fn,4s)
+#define fs_initcall(fn)			__define_initcall(fn,5)
+#define fs_initcall_sync(fn)		__define_initcall(fn,5s)
+#define rootfs_initcall(fn)		__define_initcall(fn,rootfs)
+#define device_initcall(fn)		__define_initcall(fn,6)
+#define device_initcall_sync(fn)	__define_initcall(fn,6s)
+#define late_initcall(fn)		__define_initcall(fn,7)
+#define late_initcall_sync(fn)		__define_initcall(fn,7s)
 
 #define __initcall(fn) device_initcall(fn)
 
-- 
1.7.12.4

