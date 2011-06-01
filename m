Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab1FATr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:28 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59089 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759552Ab1FATr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:27 -0400
Message-Id: <20110601180610.221426078@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:04:59 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 03/14] i8253: Consolidate all kernel definitions of i8253_lock in lib/i8253-lock.c.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-add-shared-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org

 lib/Kconfig      |    6 ++++++
 lib/Makefile     |    1 +
 lib/i8253-lock.c |   11 +++++++++++
 3 files changed, 18 insertions(+)

Index: linux-i8253/lib/i8253-lock.c
===================================================================
--- /dev/null
+++ linux-i8253/lib/i8253-lock.c
@@ -0,0 +1,11 @@
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+/*
+ * Protects access to I/O ports
+ *
+ * 0040-0043 : timer0, i8253 / i8254
+ * 0061-0061 : NMI Control Register which contains two speaker control bits.
+ */
+DEFINE_RAW_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
Index: linux-i8253/lib/Makefile
===================================================================
--- linux-i8253.orig/lib/Makefile
+++ linux-i8253/lib/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o 
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
+obj-$(CONFIG_I8253_LOCK) += i8253-lock.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 
Index: linux-i8253/lib/Kconfig
===================================================================
--- linux-i8253.orig/lib/Kconfig
+++ linux-i8253/lib/Kconfig
@@ -237,6 +237,12 @@ config CPU_RMAP
 	bool
 	depends on SMP
 
+config I8253_LOCK
+	bool
+	help
+	  Enable the shared lock for the i8253 PIT.  Any system that uses
+	  the i8253 should select this.
+
 #
 # Netlink attribute parsing support is select'ed if needed
 #


