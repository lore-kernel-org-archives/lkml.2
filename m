Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030556Ab2JSQ5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030533Ab2JSQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] x86: UAPI Disintegrate asm/perf_regs.h
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:56:41 +0100
Message-ID: <20121019165641.23037.59790.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate x86's asm/perf_regs.h for UAPI.  This just entails moving it to
the uapi directory.

With this, the #inclusion in perf's perf_regs.h can use <asm/perf_regs.h>.

If this actually wants posting to userspace, then it will need a headers-y
line adding to the Kbuild file.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/perf_regs.h        |   33 -------------------------------
 arch/x86/include/uapi/asm/perf_regs.h   |   33 +++++++++++++++++++++++++++++++
 tools/perf/arch/x86/include/perf_regs.h |    2 +-
 3 files changed, 34 insertions(+), 34 deletions(-)
 delete mode 100644 arch/x86/include/asm/perf_regs.h
 create mode 100644 arch/x86/include/uapi/asm/perf_regs.h

diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
deleted file mode 100644
index 3f2207b..0000000
--- a/arch/x86/include/asm/perf_regs.h
+++ /dev/null
@@ -1,33 +0,0 @@
-#ifndef _ASM_X86_PERF_REGS_H
-#define _ASM_X86_PERF_REGS_H
-
-enum perf_event_x86_regs {
-	PERF_REG_X86_AX,
-	PERF_REG_X86_BX,
-	PERF_REG_X86_CX,
-	PERF_REG_X86_DX,
-	PERF_REG_X86_SI,
-	PERF_REG_X86_DI,
-	PERF_REG_X86_BP,
-	PERF_REG_X86_SP,
-	PERF_REG_X86_IP,
-	PERF_REG_X86_FLAGS,
-	PERF_REG_X86_CS,
-	PERF_REG_X86_SS,
-	PERF_REG_X86_DS,
-	PERF_REG_X86_ES,
-	PERF_REG_X86_FS,
-	PERF_REG_X86_GS,
-	PERF_REG_X86_R8,
-	PERF_REG_X86_R9,
-	PERF_REG_X86_R10,
-	PERF_REG_X86_R11,
-	PERF_REG_X86_R12,
-	PERF_REG_X86_R13,
-	PERF_REG_X86_R14,
-	PERF_REG_X86_R15,
-
-	PERF_REG_X86_32_MAX = PERF_REG_X86_GS + 1,
-	PERF_REG_X86_64_MAX = PERF_REG_X86_R15 + 1,
-};
-#endif /* _ASM_X86_PERF_REGS_H */
diff --git a/arch/x86/include/uapi/asm/perf_regs.h b/arch/x86/include/uapi/asm/perf_regs.h
new file mode 100644
index 0000000..3f2207b
--- /dev/null
+++ b/arch/x86/include/uapi/asm/perf_regs.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_PERF_REGS_H
+#define _ASM_X86_PERF_REGS_H
+
+enum perf_event_x86_regs {
+	PERF_REG_X86_AX,
+	PERF_REG_X86_BX,
+	PERF_REG_X86_CX,
+	PERF_REG_X86_DX,
+	PERF_REG_X86_SI,
+	PERF_REG_X86_DI,
+	PERF_REG_X86_BP,
+	PERF_REG_X86_SP,
+	PERF_REG_X86_IP,
+	PERF_REG_X86_FLAGS,
+	PERF_REG_X86_CS,
+	PERF_REG_X86_SS,
+	PERF_REG_X86_DS,
+	PERF_REG_X86_ES,
+	PERF_REG_X86_FS,
+	PERF_REG_X86_GS,
+	PERF_REG_X86_R8,
+	PERF_REG_X86_R9,
+	PERF_REG_X86_R10,
+	PERF_REG_X86_R11,
+	PERF_REG_X86_R12,
+	PERF_REG_X86_R13,
+	PERF_REG_X86_R14,
+	PERF_REG_X86_R15,
+
+	PERF_REG_X86_32_MAX = PERF_REG_X86_GS + 1,
+	PERF_REG_X86_64_MAX = PERF_REG_X86_R15 + 1,
+};
+#endif /* _ASM_X86_PERF_REGS_H */
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index 46fc9f1..7fcdcdb 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -3,7 +3,7 @@
 
 #include <stdlib.h>
 #include "../../util/types.h"
-#include "../../../../../arch/x86/include/asm/perf_regs.h"
+#include <asm/perf_regs.h>
 
 #ifndef ARCH_X86_64
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)

