Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2JMCfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:35:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JMC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:54 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=R-8zmeu_4fgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GKOmplfHLPoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=F76KFZQujwd9Sgm3upkA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022953.577290599@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 08/25] h8300: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0008-h8300-Use-Kbuild-infrastructure-to-handle-asm-generi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/h8300/include/asm/Kbuild              |   23 +++++++++++++++++++++++
 arch/h8300/include/asm/bitsperlong.h       |    1 -
 arch/h8300/include/asm/cputime.h           |    6 ------
 arch/h8300/include/asm/device.h            |    7 -------
 arch/h8300/include/asm/div64.h             |    1 -
 arch/h8300/include/asm/emergency-restart.h |    6 ------
 arch/h8300/include/asm/errno.h             |    6 ------
 arch/h8300/include/asm/futex.h             |    6 ------
 arch/h8300/include/asm/ioctl.h             |    1 -
 arch/h8300/include/asm/irq_regs.h          |    1 -
 arch/h8300/include/asm/kdebug.h            |    1 -
 arch/h8300/include/asm/kmap_types.h        |    6 ------
 arch/h8300/include/asm/kvm_para.h          |    1 -
 arch/h8300/include/asm/local.h             |    6 ------
 arch/h8300/include/asm/local64.h           |    1 -
 arch/h8300/include/asm/mman.h              |    1 -
 arch/h8300/include/asm/percpu.h            |    6 ------
 arch/h8300/include/asm/resource.h          |    6 ------
 arch/h8300/include/asm/scatterlist.h       |    6 ------
 arch/h8300/include/asm/sections.h          |    6 ------
 arch/h8300/include/asm/siginfo.h           |    6 ------
 arch/h8300/include/asm/statfs.h            |    6 ------
 arch/h8300/include/asm/topology.h          |    6 ------
 arch/ia64/include/asm/ipcbuf.h             |    1 -
 24 files changed, 23 insertions(+), 94 deletions(-)
 delete mode 100644 arch/h8300/include/asm/bitsperlong.h
 delete mode 100644 arch/h8300/include/asm/cputime.h
 delete mode 100644 arch/h8300/include/asm/device.h
 delete mode 100644 arch/h8300/include/asm/div64.h
 delete mode 100644 arch/h8300/include/asm/emergency-restart.h
 delete mode 100644 arch/h8300/include/asm/errno.h
 delete mode 100644 arch/h8300/include/asm/futex.h
 delete mode 100644 arch/h8300/include/asm/ioctl.h
 delete mode 100644 arch/h8300/include/asm/irq_regs.h
 delete mode 100644 arch/h8300/include/asm/kdebug.h
 delete mode 100644 arch/h8300/include/asm/kmap_types.h
 delete mode 100644 arch/h8300/include/asm/kvm_para.h
 delete mode 100644 arch/h8300/include/asm/local.h
 delete mode 100644 arch/h8300/include/asm/local64.h
 delete mode 100644 arch/h8300/include/asm/mman.h
 delete mode 100644 arch/h8300/include/asm/percpu.h
 delete mode 100644 arch/h8300/include/asm/resource.h
 delete mode 100644 arch/h8300/include/asm/scatterlist.h
 delete mode 100644 arch/h8300/include/asm/sections.h
 delete mode 100644 arch/h8300/include/asm/siginfo.h
 delete mode 100644 arch/h8300/include/asm/statfs.h
 delete mode 100644 arch/h8300/include/asm/topology.h
 delete mode 100644 arch/ia64/include/asm/ipcbuf.h

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index fccd81e..aa6696e 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1,4 +1,27 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += bitsperlong.h
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += futex.h
+generic-y += ioctl.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += percpu.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
diff --git a/arch/h8300/include/asm/bitsperlong.h b/arch/h8300/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/h8300/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/h8300/include/asm/cputime.h b/arch/h8300/include/asm/cputime.h
deleted file mode 100644
index 092e187..0000000
--- a/arch/h8300/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __H8300_CPUTIME_H
-#define __H8300_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __H8300_CPUTIME_H */
diff --git a/arch/h8300/include/asm/device.h b/arch/h8300/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/h8300/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/h8300/include/asm/div64.h b/arch/h8300/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/h8300/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/h8300/include/asm/emergency-restart.h b/arch/h8300/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/h8300/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/h8300/include/asm/errno.h b/arch/h8300/include/asm/errno.h
deleted file mode 100644
index 0c2f564..0000000
--- a/arch/h8300/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_ERRNO_H
-#define _H8300_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _H8300_ERRNO_H */
diff --git a/arch/h8300/include/asm/futex.h b/arch/h8300/include/asm/futex.h
deleted file mode 100644
index 6a332a9..0000000
--- a/arch/h8300/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif
diff --git a/arch/h8300/include/asm/ioctl.h b/arch/h8300/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/h8300/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/h8300/include/asm/irq_regs.h b/arch/h8300/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/h8300/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/h8300/include/asm/kdebug.h b/arch/h8300/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/h8300/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/h8300/include/asm/kmap_types.h b/arch/h8300/include/asm/kmap_types.h
deleted file mode 100644
index be12a71..0000000
--- a/arch/h8300/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_H8300_KMAP_TYPES_H
-#define _ASM_H8300_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif
diff --git a/arch/h8300/include/asm/kvm_para.h b/arch/h8300/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/h8300/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/h8300/include/asm/local.h b/arch/h8300/include/asm/local.h
deleted file mode 100644
index fdd4efe..0000000
--- a/arch/h8300/include/asm/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_LOCAL_H_
-#define _H8300_LOCAL_H_
-
-#include <asm-generic/local.h>
-
-#endif
diff --git a/arch/h8300/include/asm/local64.h b/arch/h8300/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/h8300/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/h8300/include/asm/mman.h b/arch/h8300/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/h8300/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/h8300/include/asm/percpu.h b/arch/h8300/include/asm/percpu.h
deleted file mode 100644
index 72c03e3..0000000
--- a/arch/h8300/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_H8300_PERCPU__
-#define __ARCH_H8300_PERCPU__
-
-#include <asm-generic/percpu.h>
-
-#endif /* __ARCH_H8300_PERCPU__ */
diff --git a/arch/h8300/include/asm/resource.h b/arch/h8300/include/asm/resource.h
deleted file mode 100644
index 46c5f43..0000000
--- a/arch/h8300/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_RESOURCE_H
-#define _H8300_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* _H8300_RESOURCE_H */
diff --git a/arch/h8300/include/asm/scatterlist.h b/arch/h8300/include/asm/scatterlist.h
deleted file mode 100644
index 82130ed..0000000
--- a/arch/h8300/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_SCATTERLIST_H
-#define _H8300_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(_H8300_SCATTERLIST_H) */
diff --git a/arch/h8300/include/asm/sections.h b/arch/h8300/include/asm/sections.h
deleted file mode 100644
index a81743e..0000000
--- a/arch/h8300/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_SECTIONS_H_
-#define _H8300_SECTIONS_H_
-
-#include <asm-generic/sections.h>
-
-#endif
diff --git a/arch/h8300/include/asm/siginfo.h b/arch/h8300/include/asm/siginfo.h
deleted file mode 100644
index bc8fbea..0000000
--- a/arch/h8300/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_SIGINFO_H
-#define _H8300_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/h8300/include/asm/statfs.h b/arch/h8300/include/asm/statfs.h
deleted file mode 100644
index b96efa7..0000000
--- a/arch/h8300/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _H8300_STATFS_H
-#define _H8300_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* _H8300_STATFS_H */
diff --git a/arch/h8300/include/asm/topology.h b/arch/h8300/include/asm/topology.h
deleted file mode 100644
index fdc1219..0000000
--- a/arch/h8300/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_H8300_TOPOLOGY_H
-#define _ASM_H8300_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_H8300_TOPOLOGY_H */
diff --git a/arch/ia64/include/asm/ipcbuf.h b/arch/ia64/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/ia64/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


