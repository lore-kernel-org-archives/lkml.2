Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0JDU3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:29:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab0JDU27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:28:59 -0400
Date: Mon, 4 Oct 2010 20:28:29 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121843.217333624@linutronix.de>
References: <20100927121843.217333624@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide Kconfig
Message-ID: <tip-d9817ebeeef16e01487549312c68540ca8f1561b@git.kernel.org>
Git-Commit-ID: d9817ebeeef16e01487549312c68540ca8f1561b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:28:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9817ebeeef16e01487549312c68540ca8f1561b
Gitweb:     http://git.kernel.org/tip/d9817ebeeef16e01487549312c68540ca8f1561b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:59 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 11:01:05 +0200

genirq: Provide Kconfig

The generic irq Kconfig options are copied around all archs. Provide a
generic Kconfig file which can be included.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121843.217333624@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig       |    2 +
 kernel/irq/Kconfig |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..1df1a87 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -332,6 +332,8 @@ config AUDIT_TREE
 	depends on AUDITSYSCALL
 	select FSNOTIFY
 
+source "kernel/irq/Kconfig"
+
 menu "RCU Subsystem"
 
 choice
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
new file mode 100644
index 0000000..e0fc6cd
--- /dev/null
+++ b/kernel/irq/Kconfig
@@ -0,0 +1,54 @@
+config HAVE_GENERIC_HARDIRQS
+	def_bool n
+
+if HAVE_GENERIC_HARDIRQS
+menu "IRQ subsystem"
+#
+# Interrupt subsystem related configuration options
+#
+config GENERIC_HARDIRQS
+       def_bool y
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+       def_bool y
+
+# Options selectable by the architecture code
+config HAVE_SPARSE_IRQ
+       def_bool n
+
+config GENERIC_IRQ_PROBE
+	def_bool n
+
+config GENERIC_PENDING_IRQ
+	def_bool n
+
+if SPARSE_IRQ && NUMA
+config NUMA_IRQ_DESC
+	def_bool n
+endif
+
+config AUTO_IRQ_AFFINITY
+       def_bool n
+
+config IRQ_PER_CPU
+       def_bool n
+
+config HARDIRQS_SW_RESEND
+       def_bool n
+
+config SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on HAVE_SPARSE_IRQ
+	---help---
+
+	  Sparse irq numbering is useful for distro kernels that want
+	  to define a high CONFIG_NR_CPUS value but still want to have
+	  low kernel memory footprint on smaller machines.
+
+	  ( Sparse irqs can also be beneficial on NUMA boxes, as they spread
+	    out the interrupt descriptors in a more NUMA-friendly way. )
+
+	  If you don't know what to do here, say N.
+
+endmenu
+endif
