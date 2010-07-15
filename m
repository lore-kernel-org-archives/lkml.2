Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab0GOA3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:29:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab0GOA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:29:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Ian Munsie <imunsie@au.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Add DWARF register lookup for SH
Date: Wed, 14 Jul 2010 21:29:21 -0300
Message-Id: <1279153761-18169-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279153761-18169-1-git-send-email-acme@infradead.org>
References: <1279153761-18169-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>

Implement get_arch_regstr() for SH so that, given a DWARF register number, the
corresponding symbolic name of that register can be looked up.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Munsie <imunsie@au.ibm.com>
LKML-Reference: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
Signed-off-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.6.2.5

