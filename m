Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2JMCfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:35:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2JMC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:55 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=CW572ksCrCcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=74UVcvrWSCkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=9dunAn7g30oAOLFmIZIA:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022953.870388530@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 10/25] ia64: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0010-ia64-Use-Kbuild-infrastructure-to-handle-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-ia64@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/ia64/include/asm/Kbuild              |   10 ++++++++++
 arch/ia64/include/asm/div64.h             |    1 -
 arch/ia64/include/asm/emergency-restart.h |    6 ------
 arch/ia64/include/asm/errno.h             |    1 -
 arch/ia64/include/asm/ioctl.h             |    1 -
 arch/ia64/include/asm/ioctls.h            |    6 ------
 arch/ia64/include/asm/irq_regs.h          |    1 -
 arch/ia64/include/asm/local.h             |    1 -
 arch/ia64/include/asm/local64.h           |    1 -
 arch/ia64/include/asm/poll.h              |    1 -
 arch/m32r/include/asm/ipcbuf.h            |    1 -
 11 files changed, 10 insertions(+), 20 deletions(-)
 delete mode 100644 arch/ia64/include/asm/div64.h
 delete mode 100644 arch/ia64/include/asm/emergency-restart.h
 delete mode 100644 arch/ia64/include/asm/errno.h
 delete mode 100644 arch/ia64/include/asm/ioctl.h
 delete mode 100644 arch/ia64/include/asm/ioctls.h
 delete mode 100644 arch/ia64/include/asm/irq_regs.h
 delete mode 100644 arch/ia64/include/asm/local.h
 delete mode 100644 arch/ia64/include/asm/local64.h
 delete mode 100644 arch/ia64/include/asm/poll.h
 delete mode 100644 arch/m32r/include/asm/ipcbuf.h

diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 562f593..379f35d 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -14,4 +14,14 @@ header-y += rse.h
 header-y += ucontext.h
 header-y += ustack.h
 generic-y += clkdev.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += poll.h
diff --git a/arch/ia64/include/asm/div64.h b/arch/ia64/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/ia64/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/ia64/include/asm/emergency-restart.h b/arch/ia64/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/ia64/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/ia64/include/asm/errno.h b/arch/ia64/include/asm/errno.h
deleted file mode 100644
index 4c82b50..0000000
--- a/arch/ia64/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/errno.h>
diff --git a/arch/ia64/include/asm/ioctl.h b/arch/ia64/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/ia64/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/ia64/include/asm/ioctls.h b/arch/ia64/include/asm/ioctls.h
deleted file mode 100644
index f3aab55..0000000
--- a/arch/ia64/include/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_IA64_IOCTLS_H
-#define _ASM_IA64_IOCTLS_H
-
-#include <asm-generic/ioctls.h>
-
-#endif /* _ASM_IA64_IOCTLS_H */
diff --git a/arch/ia64/include/asm/irq_regs.h b/arch/ia64/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/ia64/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/ia64/include/asm/local.h b/arch/ia64/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/ia64/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/ia64/include/asm/local64.h b/arch/ia64/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/ia64/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/ia64/include/asm/poll.h b/arch/ia64/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/ia64/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/m32r/include/asm/ipcbuf.h b/arch/m32r/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/m32r/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


