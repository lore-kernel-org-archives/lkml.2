Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab2EaUPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:15:45 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:55277 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2EaUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:15:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Use Kbuild logic to import asm-generic headers
Date: Thu, 31 May 2012 22:15:37 +0200
Message-Id: <1338495338-1962-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all headers files that just include their asm-generic version by
Kbuild logic

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild              |   23 +++++++++++++++++++++++
 arch/m68k/include/asm/bitsperlong.h       |    1 -
 arch/m68k/include/asm/cputime.h           |    6 ------
 arch/m68k/include/asm/device.h            |    7 -------
 arch/m68k/include/asm/emergency-restart.h |    6 ------
 arch/m68k/include/asm/errno.h             |    6 ------
 arch/m68k/include/asm/futex.h             |    6 ------
 arch/m68k/include/asm/ioctl.h             |    1 -
 arch/m68k/include/asm/ipcbuf.h            |    1 -
 arch/m68k/include/asm/irq_regs.h          |    1 -
 arch/m68k/include/asm/kdebug.h            |    1 -
 arch/m68k/include/asm/kmap_types.h        |    6 ------
 arch/m68k/include/asm/kvm_para.h          |    1 -
 arch/m68k/include/asm/local.h             |    6 ------
 arch/m68k/include/asm/local64.h           |    1 -
 arch/m68k/include/asm/mman.h              |    1 -
 arch/m68k/include/asm/mutex.h             |    9 ---------
 arch/m68k/include/asm/percpu.h            |    6 ------
 arch/m68k/include/asm/resource.h          |    6 ------
 arch/m68k/include/asm/scatterlist.h       |    6 ------
 arch/m68k/include/asm/siginfo.h           |    6 ------
 arch/m68k/include/asm/statfs.h            |    6 ------
 arch/m68k/include/asm/topology.h          |    6 ------
 arch/m68k/include/asm/xor.h               |    1 -
 24 files changed, 23 insertions(+), 97 deletions(-)
 delete mode 100644 arch/m68k/include/asm/bitsperlong.h
 delete mode 100644 arch/m68k/include/asm/cputime.h
 delete mode 100644 arch/m68k/include/asm/device.h
 delete mode 100644 arch/m68k/include/asm/emergency-restart.h
 delete mode 100644 arch/m68k/include/asm/errno.h
 delete mode 100644 arch/m68k/include/asm/futex.h
 delete mode 100644 arch/m68k/include/asm/ioctl.h
 delete mode 100644 arch/m68k/include/asm/ipcbuf.h
 delete mode 100644 arch/m68k/include/asm/irq_regs.h
 delete mode 100644 arch/m68k/include/asm/kdebug.h
 delete mode 100644 arch/m68k/include/asm/kmap_types.h
 delete mode 100644 arch/m68k/include/asm/kvm_para.h
 delete mode 100644 arch/m68k/include/asm/local.h
 delete mode 100644 arch/m68k/include/asm/local64.h
 delete mode 100644 arch/m68k/include/asm/mman.h
 delete mode 100644 arch/m68k/include/asm/mutex.h
 delete mode 100644 arch/m68k/include/asm/percpu.h
 delete mode 100644 arch/m68k/include/asm/resource.h
 delete mode 100644 arch/m68k/include/asm/scatterlist.h
 delete mode 100644 arch/m68k/include/asm/siginfo.h
 delete mode 100644 arch/m68k/include/asm/statfs.h
 delete mode 100644 arch/m68k/include/asm/topology.h
 delete mode 100644 arch/m68k/include/asm/xor.h

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index eafa253..4d1f8fa 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,4 +1,27 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
 
+generic-y += bitsperlong.h
+generic-y += cputime.h
+generic-y += device.h
+generic-y += emergency-restart.h
+generic-y += errno.h
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
+generic-y += mutex.h
+generic-y += percpu.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
 generic-y += word-at-a-time.h
+generic-y += xor.h
diff --git a/arch/m68k/include/asm/bitsperlong.h b/arch/m68k/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/m68k/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/m68k/include/asm/cputime.h b/arch/m68k/include/asm/cputime.h
deleted file mode 100644
index c79c5e8..0000000
--- a/arch/m68k/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __M68K_CPUTIME_H
-#define __M68K_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __M68K_CPUTIME_H */
diff --git a/arch/m68k/include/asm/device.h b/arch/m68k/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/m68k/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/m68k/include/asm/emergency-restart.h b/arch/m68k/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/m68k/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/m68k/include/asm/errno.h b/arch/m68k/include/asm/errno.h
deleted file mode 100644
index 0d4e188..0000000
--- a/arch/m68k/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_ERRNO_H
-#define _M68K_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _M68K_ERRNO_H */
diff --git a/arch/m68k/include/asm/futex.h b/arch/m68k/include/asm/futex.h
deleted file mode 100644
index 6a332a9..0000000
--- a/arch/m68k/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif
diff --git a/arch/m68k/include/asm/ioctl.h b/arch/m68k/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/m68k/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/m68k/include/asm/ipcbuf.h b/arch/m68k/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/m68k/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/m68k/include/asm/irq_regs.h b/arch/m68k/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/m68k/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/m68k/include/asm/kdebug.h b/arch/m68k/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/m68k/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/m68k/include/asm/kmap_types.h b/arch/m68k/include/asm/kmap_types.h
deleted file mode 100644
index 3413cc1..0000000
--- a/arch/m68k/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_M68K_KMAP_TYPES_H
-#define __ASM_M68K_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif	/* __ASM_M68K_KMAP_TYPES_H */
diff --git a/arch/m68k/include/asm/kvm_para.h b/arch/m68k/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/m68k/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/m68k/include/asm/local.h b/arch/m68k/include/asm/local.h
deleted file mode 100644
index 6c25926..0000000
--- a/arch/m68k/include/asm/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M68K_LOCAL_H
-#define _ASM_M68K_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_M68K_LOCAL_H */
diff --git a/arch/m68k/include/asm/local64.h b/arch/m68k/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/m68k/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/m68k/include/asm/mman.h b/arch/m68k/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/m68k/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/m68k/include/asm/mutex.h b/arch/m68k/include/asm/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/arch/m68k/include/asm/mutex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * Pull in the generic implementation for the mutex fastpath.
- *
- * TODO: implement optimized primitives instead, or leave the generic
- * implementation in place, or pick the atomic_xchg() based generic
- * implementation. (see asm-generic/mutex-xchg.h for details)
- */
-
-#include <asm-generic/mutex-dec.h>
diff --git a/arch/m68k/include/asm/percpu.h b/arch/m68k/include/asm/percpu.h
deleted file mode 100644
index 0859d04..0000000
--- a/arch/m68k/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_M68K_PERCPU_H
-#define __ASM_M68K_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif	/* __ASM_M68K_PERCPU_H */
diff --git a/arch/m68k/include/asm/resource.h b/arch/m68k/include/asm/resource.h
deleted file mode 100644
index e7d3501..0000000
--- a/arch/m68k/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_RESOURCE_H
-#define _M68K_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* _M68K_RESOURCE_H */
diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
deleted file mode 100644
index 3125054..0000000
--- a/arch/m68k/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_SCATTERLIST_H
-#define _M68K_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(_M68K_SCATTERLIST_H) */
diff --git a/arch/m68k/include/asm/siginfo.h b/arch/m68k/include/asm/siginfo.h
deleted file mode 100644
index 851d3d7..0000000
--- a/arch/m68k/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_SIGINFO_H
-#define _M68K_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/m68k/include/asm/statfs.h b/arch/m68k/include/asm/statfs.h
deleted file mode 100644
index 08d93f1..0000000
--- a/arch/m68k/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_STATFS_H
-#define _M68K_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* _M68K_STATFS_H */
diff --git a/arch/m68k/include/asm/topology.h b/arch/m68k/include/asm/topology.h
deleted file mode 100644
index ca173e9..0000000
--- a/arch/m68k/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M68K_TOPOLOGY_H
-#define _ASM_M68K_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_M68K_TOPOLOGY_H */
diff --git a/arch/m68k/include/asm/xor.h b/arch/m68k/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/m68k/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
-- 
1.7.0.4

