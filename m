Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2JMCcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2JMC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:57 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=X2qMRDd4S58A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=E4Qdb5qFiocA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Sy0NQmMnAAAA:8 a=Ktwz03RSV3lDjNdTj70A:9 a=jEp0ucaQiEUA:10 a=ZJmIAeVxK1QA:10 a=jeBq3FmKZ4MA:10 a=XeBp8yvGpUVkhicP:21 a=VtZgmHbaZ_-0XrwS:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.007326965@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 11/25] m32r: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0011-m32r-Use-Kbuild-infrastructure-to-handle-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-m32r@ml.linux-m32r.org
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/m32r/include/asm/Kbuild              |   28 ++++++++++++++++++++++++++++
 arch/m32r/include/asm/bitsperlong.h       |    1 -
 arch/m32r/include/asm/bug.h               |    4 ----
 arch/m32r/include/asm/cputime.h           |    6 ------
 arch/m32r/include/asm/delay.h             |    1 -
 arch/m32r/include/asm/device.h            |    7 -------
 arch/m32r/include/asm/div64.h             |    1 -
 arch/m32r/include/asm/emergency-restart.h |    6 ------
 arch/m32r/include/asm/errno.h             |    6 ------
 arch/m32r/include/asm/fcntl.h             |    1 -
 arch/m32r/include/asm/futex.h             |    6 ------
 arch/m32r/include/asm/ioctl.h             |    1 -
 arch/m32r/include/asm/ioctls.h            |    6 ------
 arch/m32r/include/asm/irq_regs.h          |    1 -
 arch/m32r/include/asm/kdebug.h            |    1 -
 arch/m32r/include/asm/local64.h           |    1 -
 arch/m32r/include/asm/mman.h              |    1 -
 arch/m32r/include/asm/param.h             |    7 -------
 arch/m32r/include/asm/pci.h               |    6 ------
 arch/m32r/include/asm/percpu.h            |    6 ------
 arch/m32r/include/asm/poll.h              |    1 -
 arch/m32r/include/asm/resource.h          |    6 ------
 arch/m32r/include/asm/scatterlist.h       |    6 ------
 arch/m32r/include/asm/sections.h          |    7 -------
 arch/m32r/include/asm/siginfo.h           |    6 ------
 arch/m32r/include/asm/statfs.h            |    6 ------
 arch/m32r/include/asm/topology.h          |    6 ------
 arch/m32r/include/asm/xor.h               |    6 ------
 arch/microblaze/include/asm/ipcbuf.h      |    1 -
 29 files changed, 28 insertions(+), 114 deletions(-)
 delete mode 100644 arch/m32r/include/asm/bitsperlong.h
 delete mode 100644 arch/m32r/include/asm/bug.h
 delete mode 100644 arch/m32r/include/asm/cputime.h
 delete mode 100644 arch/m32r/include/asm/delay.h
 delete mode 100644 arch/m32r/include/asm/device.h
 delete mode 100644 arch/m32r/include/asm/div64.h
 delete mode 100644 arch/m32r/include/asm/emergency-restart.h
 delete mode 100644 arch/m32r/include/asm/errno.h
 delete mode 100644 arch/m32r/include/asm/fcntl.h
 delete mode 100644 arch/m32r/include/asm/futex.h
 delete mode 100644 arch/m32r/include/asm/ioctl.h
 delete mode 100644 arch/m32r/include/asm/ioctls.h
 delete mode 100644 arch/m32r/include/asm/irq_regs.h
 delete mode 100644 arch/m32r/include/asm/kdebug.h
 delete mode 100644 arch/m32r/include/asm/local64.h
 delete mode 100644 arch/m32r/include/asm/mman.h
 delete mode 100644 arch/m32r/include/asm/param.h
 delete mode 100644 arch/m32r/include/asm/pci.h
 delete mode 100644 arch/m32r/include/asm/percpu.h
 delete mode 100644 arch/m32r/include/asm/poll.h
 delete mode 100644 arch/m32r/include/asm/resource.h
 delete mode 100644 arch/m32r/include/asm/scatterlist.h
 delete mode 100644 arch/m32r/include/asm/sections.h
 delete mode 100644 arch/m32r/include/asm/siginfo.h
 delete mode 100644 arch/m32r/include/asm/statfs.h
 delete mode 100644 arch/m32r/include/asm/topology.h
 delete mode 100644 arch/m32r/include/asm/xor.h
 delete mode 100644 arch/microblaze/include/asm/ipcbuf.h

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index fccd81e..2cde298 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,4 +1,32 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += delay.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fcntl.h
+generic-y += futex.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += local64.h
+generic-y += mman.h
+generic-y += param.h
+generic-y += pci.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
+generic-y += xor.h
diff --git a/arch/m32r/include/asm/bitsperlong.h b/arch/m32r/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/m32r/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/m32r/include/asm/bug.h b/arch/m32r/include/asm/bug.h
deleted file mode 100644
index 4cc0462..0000000
--- a/arch/m32r/include/asm/bug.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _M32R_BUG_H
-#define _M32R_BUG_H
-#include <asm-generic/bug.h>
-#endif
diff --git a/arch/m32r/include/asm/cputime.h b/arch/m32r/include/asm/cputime.h
deleted file mode 100644
index 0a47550..0000000
--- a/arch/m32r/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __M32R_CPUTIME_H
-#define __M32R_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __M32R_CPUTIME_H */
diff --git a/arch/m32r/include/asm/delay.h b/arch/m32r/include/asm/delay.h
deleted file mode 100644
index 9670e12..0000000
--- a/arch/m32r/include/asm/delay.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/delay.h>
diff --git a/arch/m32r/include/asm/device.h b/arch/m32r/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/m32r/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/m32r/include/asm/div64.h b/arch/m32r/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/m32r/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/m32r/include/asm/emergency-restart.h b/arch/m32r/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/m32r/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/m32r/include/asm/errno.h b/arch/m32r/include/asm/errno.h
deleted file mode 100644
index 7771492..0000000
--- a/arch/m32r/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_ERRNO_H
-#define _ASM_M32R_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _ASM_M32R_ERRNO_H */
diff --git a/arch/m32r/include/asm/fcntl.h b/arch/m32r/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/m32r/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/m32r/include/asm/futex.h b/arch/m32r/include/asm/futex.h
deleted file mode 100644
index 6a332a9..0000000
--- a/arch/m32r/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif
diff --git a/arch/m32r/include/asm/ioctl.h b/arch/m32r/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/m32r/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/m32r/include/asm/ioctls.h b/arch/m32r/include/asm/ioctls.h
deleted file mode 100644
index 349bf87..0000000
--- a/arch/m32r/include/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_M32R_IOCTLS_H__
-#define __ARCH_M32R_IOCTLS_H__
-
-#include <asm-generic/ioctls.h>
-
-#endif /* __ARCH_M32R_IOCTLS_H__ */
diff --git a/arch/m32r/include/asm/irq_regs.h b/arch/m32r/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/m32r/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/m32r/include/asm/kdebug.h b/arch/m32r/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/m32r/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/m32r/include/asm/local64.h b/arch/m32r/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/m32r/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/m32r/include/asm/mman.h b/arch/m32r/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/m32r/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/m32r/include/asm/param.h b/arch/m32r/include/asm/param.h
deleted file mode 100644
index fa207bd..0000000
--- a/arch/m32r/include/asm/param.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_M32R_PARAM_H
-#define _ASM_M32R_PARAM_H
-
-#include <asm-generic/param.h>
-
-#endif /* _ASM_M32R_PARAM_H */
-
diff --git a/arch/m32r/include/asm/pci.h b/arch/m32r/include/asm/pci.h
deleted file mode 100644
index 07d3834..0000000
--- a/arch/m32r/include/asm/pci.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_PCI_H
-#define _ASM_M32R_PCI_H
-
-#include <asm-generic/pci.h>
-
-#endif /* _ASM_M32R_PCI_H */
diff --git a/arch/m32r/include/asm/percpu.h b/arch/m32r/include/asm/percpu.h
deleted file mode 100644
index e316930..0000000
--- a/arch/m32r/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_M32R_PERCPU__
-#define __ARCH_M32R_PERCPU__
-
-#include <asm-generic/percpu.h>
-
-#endif /* __ARCH_M32R_PERCPU__ */
diff --git a/arch/m32r/include/asm/poll.h b/arch/m32r/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/m32r/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/m32r/include/asm/resource.h b/arch/m32r/include/asm/resource.h
deleted file mode 100644
index b1ce766..0000000
--- a/arch/m32r/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_RESOURCE_H
-#define _ASM_M32R_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif  /* _ASM_M32R_RESOURCE_H */
diff --git a/arch/m32r/include/asm/scatterlist.h b/arch/m32r/include/asm/scatterlist.h
deleted file mode 100644
index 7370b8b..0000000
--- a/arch/m32r/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_SCATTERLIST_H
-#define _ASM_M32R_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_M32R_SCATTERLIST_H */
diff --git a/arch/m32r/include/asm/sections.h b/arch/m32r/include/asm/sections.h
deleted file mode 100644
index 5e5d21c..0000000
--- a/arch/m32r/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _M32R_SECTIONS_H
-#define _M32R_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif	/* _M32R_SECTIONS_H */
diff --git a/arch/m32r/include/asm/siginfo.h b/arch/m32r/include/asm/siginfo.h
deleted file mode 100644
index 7d9cd9e..0000000
--- a/arch/m32r/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M32R_SIGINFO_H
-#define _M32R_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif /* _M32R_SIGINFO_H */
diff --git a/arch/m32r/include/asm/statfs.h b/arch/m32r/include/asm/statfs.h
deleted file mode 100644
index 6eb4c60..0000000
--- a/arch/m32r/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_STATFS_H
-#define _ASM_M32R_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif  /* _ASM_M32R_STATFS_H */
diff --git a/arch/m32r/include/asm/topology.h b/arch/m32r/include/asm/topology.h
deleted file mode 100644
index d607eb3..0000000
--- a/arch/m32r/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_TOPOLOGY_H
-#define _ASM_M32R_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_M32R_TOPOLOGY_H */
diff --git a/arch/m32r/include/asm/xor.h b/arch/m32r/include/asm/xor.h
deleted file mode 100644
index 6d52525..0000000
--- a/arch/m32r/include/asm/xor.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_XOR_H
-#define _ASM_M32R_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif  /* _ASM_M32R_XOR_H */
diff --git a/arch/microblaze/include/asm/ipcbuf.h b/arch/microblaze/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/microblaze/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


