Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2KLLw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:52:29 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:64715 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2KLLwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:52:24 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 50/55] ARC: perf support (software counters only)
Date: Mon, 12 Nov 2012 17:19:08 +0530
Message-ID: <1352720953-24321-20-git-send-email-vgupta@synopsys.com>
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
 arch/arc/Kconfig                  |    3 +++
 arch/arc/include/asm/perf_event.h |   19 +++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/perf_event.h

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index b878d3e..9882ce0c 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -23,12 +23,15 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_IRQ_WORK
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MOD_ARCH_SPECIFIC if ARC_DW2_UNWIND
 	select HAVE_OPROFILE
+	select HAVE_PERF_EVENTS
 	select HOTPLUG if !INITRAMFS_SOURCE=""
 	select MODULES_USE_ELF_RELA
+	select PERF_USE_VMALLOC
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/arc/include/asm/perf_event.h b/arch/arc/include/asm/perf_event.h
new file mode 100644
index 0000000..a10eb78
--- /dev/null
+++ b/arch/arc/include/asm/perf_event.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_PERF_EVENT_H
+#define __ASM_PERF_EVENT_H
+
+#define PERF_EVENT_INDEX_OFFSET	0
+
+static inline void set_perf_event_pending(void)
+{
+}
+
+#endif /* __ASM_PERF_EVENT_H */
-- 
1.7.4.1

