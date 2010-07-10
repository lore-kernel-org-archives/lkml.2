Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0GJPKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:10:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33841 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab0GJPKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:10:41 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ian Munsie <imunsie@au.ibm.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] perf: Add DWARF register lookup for SH
Date: Sat, 10 Jul 2010 16:10:39 +0100
Message-Id: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement get_arch_regstr() for SH so that, given a DWARF register
number, the corresponding symbolic name of that register can be looked
up.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 tools/perf/arch/sh/Makefile          |    4 ++
 tools/perf/arch/sh/util/dwarf-regs.c |   55 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/arch/sh/Makefile
 create mode 100644 tools/perf/arch/sh/util/dwarf-regs.c

diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
new file mode 100644
index 0000000..15130b5
--- /dev/null
+++ b/tools/perf/arch/sh/Makefile
@@ -0,0 +1,4 @@
+ifndef NO_DWARF
+PERF_HAVE_DWARF_REGS := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+endif
diff --git a/tools/perf/arch/sh/util/dwarf-regs.c b/tools/perf/arch/sh/util/dwarf-regs.c
new file mode 100644
index 0000000..a11edb0
--- /dev/null
+++ b/tools/perf/arch/sh/util/dwarf-regs.c
@@ -0,0 +1,55 @@
+/*
+ * Mapping of DWARF debug register numbers into register names.
+ *
+ * Copyright (C) 2010 Matt Fleming <matt@console-pimps.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <libio.h>
+#include <dwarf-regs.h>
+
+/*
+ * Generic dwarf analysis helpers
+ */
+
+#define SH_MAX_REGS 18
+const char *sh_regs_table[SH_MAX_REGS] = {
+	"r0",
+	"r1",
+	"r2",
+	"r3",
+	"r4",
+	"r5",
+	"r6",
+	"r7",
+	"r8",
+	"r9",
+	"r10",
+	"r11",
+	"r12",
+	"r13",
+	"r14",
+	"r15",
+	"pc",
+	"pr",
+};
+
+/* Return architecture dependent register string (for kprobe-tracer) */
+const char *get_arch_regstr(unsigned int n)
+{
+	return (n <= SH_MAX_REGS) ? sh_regs_table[n] : NULL;
+}
-- 
1.6.4.rc0

