Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2KRTDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2KRTC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:02:59 -0500
Date: Sun, 18 Nov 2012 20:03:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM
Message-ID: <20121118190324.GA9691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118190257.GA9660@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only block_dev and uprobes use percpu_rw_semaphore,
add the config option selected by BLOCK || UPROBES.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/Kconfig  |    1 +
 block/Kconfig |    1 +
 lib/Kconfig   |    3 +++
 lib/Makefile  |    3 ++-
 4 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..cf4efe6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -80,6 +80,7 @@ config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
 	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
+	select PERCPU_RWSEM
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
 	  enable instrumentation applications (such as 'perf probe')
diff --git a/block/Kconfig b/block/Kconfig
index a7e40a7..4a85ccf 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -4,6 +4,7 @@
 menuconfig BLOCK
        bool "Enable the block layer" if EXPERT
        default y
+       select PERCPU_RWSEM
        help
 	 Provide block layer support for the kernel.
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 4b31a46..75cdb77 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_IO
 config STMP_DEVICE
 	bool
 
+config PERCPU_RWSEM
+	boolean
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 4dad4a7..20f7eda 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o percpu-rwsem.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -40,6 +40,7 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
+lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
-- 
1.5.5.1

