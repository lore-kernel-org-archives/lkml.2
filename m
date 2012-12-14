Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2LNSmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:42:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51776 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab2LNSmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:42:20 -0500
Subject: [RFC][PATCH 5/7] consolidate runtime testing configs
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:06 -0500
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
Message-Id: <20121214184206.FC11422F@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-9360-0000-0000-00000DF53965
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These runtime tests are great, except that there are a lot of them,
and they are very rarely needed.  Give them their own menu so that
only the folks who need them will have to go looking for them.

Note that there are some other runtime tests that are not in here,
like for RCU or locking.  This menu should only be used for tests
that do not have a more appropriate home.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/Kconfig.debug |  151 ++++++++++++++++++-----------------
 1 file changed, 78 insertions(+), 73 deletions(-)

diff -puN lib/Kconfig.debug~consolidat-runtime-testing-configs lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~consolidat-runtime-testing-configs	2012-12-10 11:27:45.267963463 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-10 11:28:38.316437234 -0500
@@ -1012,15 +1012,6 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
-config TEST_LIST_SORT
-	bool "Linked list sorting test"
-	depends on DEBUG_KERNEL
-	help
-	  Enable this to turn on 'list_sort()' function test. This test is
-	  executed only once during system boot, so affects only boot time.
-
-	  If unsure, say N.
-
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
@@ -1095,33 +1086,6 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
-config KPROBES_SANITY_TEST
-	bool "Kprobes sanity tests"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
-	default n
-	help
-	  This option provides for testing basic kprobes functionality on
-	  boot. A sample kprobe, jprobe and kretprobe are inserted and
-	  verified for functionality.
-
-	  Say N if you are unsure.
-
-config BACKTRACE_SELF_TEST
-	tristate "Self test for the backtrace code"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that can be used to test
-	  the kernel stack backtrace code. This option is not useful
-	  for distributions or general kernels, but only for kernel
-	  developers working on architecture code.
-
-	  Note that if you want to also test saved backtraces, you will
-	  have to enable STACKTRACE as well.
-
-	  Say N if you are unsure.
-
 config DEBUG_BLOCK_EXT_DEVT
         bool "Force extended block device numbers and spread them"
 	depends on DEBUG_KERNEL
@@ -1164,21 +1128,6 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
-config LKDTM
-	tristate "Linux Kernel Dump Test Tool Module"
-	depends on DEBUG_FS
-	depends on BLOCK
-	default n
-	help
-	This module enables testing of the different dumping mechanisms by
-	inducing system failures at predefined crash points.
-	If you don't need it: say N
-	Choose M here to compile this code as a module. The module will be
-	called lkdtm.
-
-	Documentation on how to use the module can be found in
-	Documentation/fault-injection/provoke-crashes.txt
-
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
 	depends on DEBUG_KERNEL
@@ -1336,6 +1285,59 @@ config LATENCYTOP
 
 source kernel/trace/Kconfig
 
+menu "Runtime Testing"
+
+config LKDTM
+	tristate "Linux Kernel Dump Test Tool Module"
+	depends on DEBUG_FS
+	depends on BLOCK
+	default n
+	help
+	This module enables testing of the different dumping mechanisms by
+	inducing system failures at predefined crash points.
+	If you don't need it: say N
+	Choose M here to compile this code as a module. The module will be
+	called lkdtm.
+
+	Documentation on how to use the module can be found in
+	Documentation/fault-injection/provoke-crashes.txt
+
+config TEST_LIST_SORT
+	bool "Linked list sorting test"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on 'list_sort()' function test. This test is
+	  executed only once during system boot, so affects only boot time.
+
+	  If unsure, say N.
+
+config KPROBES_SANITY_TEST
+	bool "Kprobes sanity tests"
+	depends on DEBUG_KERNEL
+	depends on KPROBES
+	default n
+	help
+	  This option provides for testing basic kprobes functionality on
+	  boot. A sample kprobe, jprobe and kretprobe are inserted and
+	  verified for functionality.
+
+	  Say N if you are unsure.
+
+config BACKTRACE_SELF_TEST
+	tristate "Self test for the backtrace code"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that can be used to test
+	  the kernel stack backtrace code. This option is not useful
+	  for distributions or general kernels, but only for kernel
+	  developers working on architecture code.
+
+	  Note that if you want to also test saved backtraces, you will
+	  have to enable STACKTRACE as well.
+
+	  Say N if you are unsure.
+
 config RBTREE_TEST
 	tristate "Red-Black tree test"
 	depends on m && DEBUG_KERNEL
@@ -1349,6 +1351,31 @@ config INTERVAL_TREE_TEST
 	help
 	  A benchmark measuring the performance of the interval tree library
 
+config ATOMIC64_SELFTEST
+	bool "Perform an atomic64_t self-test at boot"
+	help
+	  Enable this option to test the atomic64_t functions at boot.
+
+	  If unsure, say N.
+
+config ASYNC_RAID6_TEST
+	tristate "Self test for hardware accelerated raid6 recovery"
+	depends on ASYNC_RAID6_RECOV
+	select ASYNC_MEMCPY
+	---help---
+	  This is a one-shot self test that permutes through the
+	  recovery of all the possible two disk failure scenarios for a
+	  N-disk array.  Recovery is performed with the asynchronous
+	  raid6 recovery routines, and will optionally use an offload
+	  engine if one is available.
+
+	  If unsure, say N.
+
+config TEST_KSTRTOX
+	tristate "Test kstrto*() family of functions at runtime"
+
+endmenu # runtime tests
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
@@ -1478,26 +1505,6 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
-config ATOMIC64_SELFTEST
-	bool "Perform an atomic64_t self-test at boot"
-	help
-	  Enable this option to test the atomic64_t functions at boot.
-
-	  If unsure, say N.
-
-config ASYNC_RAID6_TEST
-	tristate "Self test for hardware accelerated raid6 recovery"
-	depends on ASYNC_RAID6_RECOV
-	select ASYNC_MEMCPY
-	---help---
-	  This is a one-shot self test that permutes through the
-	  recovery of all the possible two disk failure scenarios for a
-	  N-disk array.  Recovery is performed with the asynchronous
-	  raid6 recovery routines, and will optionally use an offload
-	  engine if one is available.
-
-	  If unsure, say N.
-
 config HAVE_DEBUG_STACKOVERFLOW
 	bool
 
@@ -1505,5 +1512,3 @@ source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
 
-config TEST_KSTRTOX
-	tristate "Test kstrto*() family of functions at runtime"
_

