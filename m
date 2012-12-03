Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2LCPCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:02:01 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50498 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2LCPB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:01:58 -0500
Subject: [PATCH 1/9] goldfish: definitions for Goldfish on x86 platforms
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 03 Dec 2012 15:04:19 +0000
Message-ID: <20121203150417.16826.70816.stgit@bob.linux.org.uk>
In-Reply-To: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
References: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jun Nakajima <jnakajim@gmail.com>

Based on code by Jun Nakajima but stripped of all the old x86 mach-foo
stuff and turned into a single include file for the Goldfish virtual bus
layer

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[Ported to 3.7 and reorganised so that we can keep most of the code
 shared properly]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                |   12 ++++++++++++
 arch/x86/include/asm/goldfish.h |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 arch/x86/include/asm/goldfish.h


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cd98a44..dbe8baa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -326,6 +326,10 @@ config X86_BIGSMP
 	---help---
 	  This option is needed for the systems that have more than 8 CPUs
 
+config GOLDFISH
+       def_bool y
+       depends on X86_GOLDFISH
+
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
@@ -407,6 +411,14 @@ config X86_UV
 # Following is an alphabetically sorted list of 32 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
+config X86_GOLDFISH
+       bool "Goldfish (Virtual Platform)"
+       depends on X86_32
+       ---help---
+	 Enable support for the Goldfish virtual platform used primarily
+	 for Android development. Unless you are building for the Android
+	 Goldfish emulator say N here.
+
 config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
diff --git a/arch/x86/include/asm/goldfish.h b/arch/x86/include/asm/goldfish.h
new file mode 100644
index 0000000..d5fcf6d
--- /dev/null
+++ b/arch/x86/include/asm/goldfish.h
@@ -0,0 +1,36 @@
+/*
+ *
+ * arch/x86/include/asm/mach-goldfish/hardware.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2012 Intel, Corp.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __X86_ARCH_HARDWARE_H
+#define __X86_ARCH_HARDWARE_H
+
+/*
+ * Where in virtual memory the IO devices (timers, system controllers
+ * and so on)
+ */
+
+#define GOLDFISH_IO_SIZE	0x00800000	/* How much? */
+#define GOLDFISH_IO_START	0xff000000	/* PA of IO */
+
+#define GOLDFISH_PDEV_BUS_BASE	(0x1000)
+#define GOLDFISH_PDEV_BUS_END	(0x100)
+#define GOLDFISH_PDEV_BUS_IRQ	(4)
+
+#define GOLDFISH_TTY_BASE	(0x2000)
+
+#endif

