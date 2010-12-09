Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0LIJcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:32:48 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53615 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab0LIJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:32:46 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 003/211] unicore32: new file arch/unicore32/Kconfig.debug
Date: Thu, 9 Dec 2010 17:32:42 +0800
Message-ID: <01d001cb9784$07a80440$16f80cc0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhAEse5745+s5QGeI2V6WOsq7kw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	Kconfig file for debugger

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig.debug |   86
++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
new file mode 100644
index 0000000..e59ab3c
--- /dev/null
+++ b/arch/unicore32/Kconfig.debug
@@ -0,0 +1,86 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
+	depends on MMU
+	---help---
+	  If this option is disabled, you allow userspace (root) access to
all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to memory mapped peripherals.
+
+          If in doubt, say Y.
+
+config EARLY_PRINTK
+	bool "Early printk"
+	default DEBUG_OCD
+	help
+	  Write kernel log output directly into the ocd or to a serial port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash.
+
+config DEBUG_USER
+	bool "Verbose user fault messages"
+	help
+	  When a user program crashes due to an exception, the kernel can
+	  print a brief message explaining what the problem was. This is
+	  sometimes helpful for debugging but serves no purpose on a
+	  production system. Most people should say N here.
+
+	  In addition, you need to pass user_debug=N on the kernel command
+	  line to enable this feature.  N consists of the sum of:
+
+	      1 - undefined instruction events
+	      2 - system calls
+	      4 - invalid data aborts
+	      8 - SIGSEGV faults
+	     16 - SIGBUS faults
+
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T output.
+
+# These options are only for real kernel hackers who want to get their
hands dirty.
+config DEBUG_LL
+	bool "Kernel low-level debugging functions"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to include definitions of printascii, printch, printhex
+	  in the kernel.  This is helpful if you are debugging code that
+	  executes before the console is initialized.
+
+config DEBUG_OCD
+	bool "Kernel low-level debugging via On-Chip-Debugger"
+	depends on DEBUG_LL
+	default y
+	help
+	  Say Y here if you want the debug print routines to direct their
+	  output to the UniCore On-Chip-Debugger channel using CP #1.
+
+config DEBUG_OCD_BREAKPOINT
+	bool "Breakpoint support via On-Chip-Debugger"
+	depends on DEBUG_OCD
+
+config DEBUG_UART
+	int "Kernel low-level debugging messages via serial port"
+	depends on DEBUG_LL
+	range 0 1
+	default "0"
+	help
+	  Choice for UART for kernel low-level using PKUnity UARTS,
+	  should be between zero and one. The port must have been
+	  initialised by the boot-loader before use.
+
+endmenu

