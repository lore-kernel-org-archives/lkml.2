Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2KLLuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:50:17 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51530 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2KLLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:50:12 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 35/55] ARC: oprofile support
Date: Mon, 12 Nov 2012 17:18:53 +0530
Message-ID: <1352720953-24321-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig           |    1 +
 arch/arc/Makefile          |    2 ++
 arch/arc/oprofile/Makefile |    9 +++++++++
 arch/arc/oprofile/common.c |   22 ++++++++++++++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/oprofile/Makefile
 create mode 100644 arch/arc/oprofile/common.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 198c7d0..4557c8d 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -22,6 +22,7 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_OPROFILE
 	select HOTPLUG if !INITRAMFS_SOURCE=""
 	select MODULES_USE_ELF_RELA
 
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index eeb64dd..7ef6767 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -97,6 +97,8 @@ ifneq ($(platform-y),)
 core-y		+= arch/arc/plat-$(PLATFORM)/
 endif
 
+drivers-$(CONFIG_OPROFILE)	+= arch/arc/oprofile/
+
 libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 #default target for make without any arguements.
diff --git a/arch/arc/oprofile/Makefile b/arch/arc/oprofile/Makefile
new file mode 100644
index 0000000..ce417a6
--- /dev/null
+++ b/arch/arc/oprofile/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_OPROFILE) += oprofile.o
+
+DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
+		oprof.o cpu_buffer.o buffer_sync.o \
+		event_buffer.o oprofile_files.o \
+		oprofilefs.o oprofile_stats.o \
+		timer_int.o )
+
+oprofile-y	:= $(DRIVER_OBJS) common.o
diff --git a/arch/arc/oprofile/common.c b/arch/arc/oprofile/common.c
new file mode 100644
index 0000000..917ae16
--- /dev/null
+++ b/arch/arc/oprofile/common.c
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on orig code from @author John Levon <levon@movementarian.org>
+ */
+
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	return oprofile_perf_init(ops);
+}
+
+void oprofile_arch_exit(void)
+{
+	oprofile_perf_exit();
+}
-- 
1.7.4.1

