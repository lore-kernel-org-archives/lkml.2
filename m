Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2JMCag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:30:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2JMCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:30:00 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GGNz90GdZy0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Ukw84xJZ174A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=u3DotqyyAAAA:8 a=F-1i3n2SAAAA:8 a=pGLkceISAAAA:8 a=RCQYDNg8AAAA:8 a=lJjz8N4HAAAA:8 a=tD9FsEHkjXHeAaPFyoQA:9 a=jEp0ucaQiEUA:10 a=UjV2Q63jdB0A:10 a=BiFZEZowcwMA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022956.036433758@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 25/25] xtensa: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0025-xtensa-Use-Kbuild-infrastructure-to-handle-asm-gener.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/xtensa/include/asm/Kbuild              |   25 +++++++++++++++++++++++++
 arch/xtensa/include/asm/bitsperlong.h       |    1 -
 arch/xtensa/include/asm/bug.h               |   18 ------------------
 arch/xtensa/include/asm/cputime.h           |    6 ------
 arch/xtensa/include/asm/device.h            |    7 -------
 arch/xtensa/include/asm/div64.h             |   16 ----------------
 arch/xtensa/include/asm/emergency-restart.h |    6 ------
 arch/xtensa/include/asm/errno.h             |   16 ----------------
 arch/xtensa/include/asm/fcntl.h             |    1 -
 arch/xtensa/include/asm/futex.h             |    1 -
 arch/xtensa/include/asm/hardirq.h           |   16 ----------------
 arch/xtensa/include/asm/ioctl.h             |    1 -
 arch/xtensa/include/asm/irq_regs.h          |    1 -
 arch/xtensa/include/asm/kdebug.h            |    1 -
 arch/xtensa/include/asm/kmap_types.h        |    6 ------
 arch/xtensa/include/asm/kvm_para.h          |    1 -
 arch/xtensa/include/asm/local.h             |   16 ----------------
 arch/xtensa/include/asm/local64.h           |    1 -
 arch/xtensa/include/asm/percpu.h            |   16 ----------------
 arch/xtensa/include/asm/resource.h          |   16 ----------------
 arch/xtensa/include/asm/scatterlist.h       |   16 ----------------
 arch/xtensa/include/asm/sections.h          |   16 ----------------
 arch/xtensa/include/asm/siginfo.h           |   16 ----------------
 arch/xtensa/include/asm/statfs.h            |   17 -----------------
 arch/xtensa/include/asm/topology.h          |   16 ----------------
 arch/xtensa/include/asm/xor.h               |   16 ----------------
 26 files changed, 25 insertions(+), 244 deletions(-)
 delete mode 100644 arch/xtensa/include/asm/bitsperlong.h
 delete mode 100644 arch/xtensa/include/asm/bug.h
 delete mode 100644 arch/xtensa/include/asm/cputime.h
 delete mode 100644 arch/xtensa/include/asm/device.h
 delete mode 100644 arch/xtensa/include/asm/div64.h
 delete mode 100644 arch/xtensa/include/asm/emergency-restart.h
 delete mode 100644 arch/xtensa/include/asm/errno.h
 delete mode 100644 arch/xtensa/include/asm/fcntl.h
 delete mode 100644 arch/xtensa/include/asm/futex.h
 delete mode 100644 arch/xtensa/include/asm/hardirq.h
 delete mode 100644 arch/xtensa/include/asm/ioctl.h
 delete mode 100644 arch/xtensa/include/asm/irq_regs.h
 delete mode 100644 arch/xtensa/include/asm/kdebug.h
 delete mode 100644 arch/xtensa/include/asm/kmap_types.h
 delete mode 100644 arch/xtensa/include/asm/kvm_para.h
 delete mode 100644 arch/xtensa/include/asm/local.h
 delete mode 100644 arch/xtensa/include/asm/local64.h
 delete mode 100644 arch/xtensa/include/asm/percpu.h
 delete mode 100644 arch/xtensa/include/asm/resource.h
 delete mode 100644 arch/xtensa/include/asm/scatterlist.h
 delete mode 100644 arch/xtensa/include/asm/sections.h
 delete mode 100644 arch/xtensa/include/asm/siginfo.h
 delete mode 100644 arch/xtensa/include/asm/statfs.h
 delete mode 100644 arch/xtensa/include/asm/topology.h
 delete mode 100644 arch/xtensa/include/asm/xor.h

diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index fccd81e..db2e96a 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1,4 +1,29 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fcntl.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += ioctl.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += percpu.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
+generic-y += xor.h
diff --git a/arch/xtensa/include/asm/bitsperlong.h b/arch/xtensa/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/xtensa/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/xtensa/include/asm/bug.h b/arch/xtensa/include/asm/bug.h
deleted file mode 100644
index 3e52d72..0000000
--- a/arch/xtensa/include/asm/bug.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * include/asm-xtensa/bug.h
- *
- * Macros to cause a 'bug' message.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_BUG_H
-#define _XTENSA_BUG_H
-
-#include <asm-generic/bug.h>
-
-#endif	/* _XTENSA_BUG_H */
diff --git a/arch/xtensa/include/asm/cputime.h b/arch/xtensa/include/asm/cputime.h
deleted file mode 100644
index a7fb864..0000000
--- a/arch/xtensa/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _XTENSA_CPUTIME_H
-#define _XTENSA_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _XTENSA_CPUTIME_H */
diff --git a/arch/xtensa/include/asm/device.h b/arch/xtensa/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/xtensa/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/xtensa/include/asm/div64.h b/arch/xtensa/include/asm/div64.h
deleted file mode 100644
index f35678c..0000000
--- a/arch/xtensa/include/asm/div64.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/div64.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2007 Tensilica Inc.
- */
-
-#ifndef _XTENSA_DIV64_H
-#define _XTENSA_DIV64_H
-
-#include <asm-generic/div64.h>
-
-#endif /* _XTENSA_DIV64_H */
diff --git a/arch/xtensa/include/asm/emergency-restart.h b/arch/xtensa/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/xtensa/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/xtensa/include/asm/errno.h b/arch/xtensa/include/asm/errno.h
deleted file mode 100644
index a0f3b96..0000000
--- a/arch/xtensa/include/asm/errno.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/errno.h
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2002 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_ERRNO_H
-#define _XTENSA_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif	/* _XTENSA_ERRNO_H */
diff --git a/arch/xtensa/include/asm/fcntl.h b/arch/xtensa/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/xtensa/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/xtensa/include/asm/futex.h b/arch/xtensa/include/asm/futex.h
deleted file mode 100644
index 0b74582..0000000
--- a/arch/xtensa/include/asm/futex.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/futex.h>
diff --git a/arch/xtensa/include/asm/hardirq.h b/arch/xtensa/include/asm/hardirq.h
deleted file mode 100644
index 91695a1..0000000
--- a/arch/xtensa/include/asm/hardirq.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/hardirq.h
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2002 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_HARDIRQ_H
-#define _XTENSA_HARDIRQ_H
-
-#include <asm-generic/hardirq.h>
-
-#endif	/* _XTENSA_HARDIRQ_H */
diff --git a/arch/xtensa/include/asm/ioctl.h b/arch/xtensa/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/xtensa/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/xtensa/include/asm/irq_regs.h b/arch/xtensa/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/xtensa/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/xtensa/include/asm/kdebug.h b/arch/xtensa/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/xtensa/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/xtensa/include/asm/kmap_types.h b/arch/xtensa/include/asm/kmap_types.h
deleted file mode 100644
index 11c687e..0000000
--- a/arch/xtensa/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _XTENSA_KMAP_TYPES_H
-#define _XTENSA_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif	/* _XTENSA_KMAP_TYPES_H */
diff --git a/arch/xtensa/include/asm/kvm_para.h b/arch/xtensa/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/xtensa/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/xtensa/include/asm/local.h b/arch/xtensa/include/asm/local.h
deleted file mode 100644
index 48723e5..0000000
--- a/arch/xtensa/include/asm/local.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/local.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_LOCAL_H
-#define _XTENSA_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _XTENSA_LOCAL_H */
diff --git a/arch/xtensa/include/asm/local64.h b/arch/xtensa/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/xtensa/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/xtensa/include/asm/percpu.h b/arch/xtensa/include/asm/percpu.h
deleted file mode 100644
index 6d2bc2a..0000000
--- a/arch/xtensa/include/asm/percpu.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * linux/include/asm-xtensa/percpu.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_PERCPU__
-#define _XTENSA_PERCPU__
-
-#include <asm-generic/percpu.h>
-
-#endif /* _XTENSA_PERCPU__ */
diff --git a/arch/xtensa/include/asm/resource.h b/arch/xtensa/include/asm/resource.h
deleted file mode 100644
index 17b5ab3..0000000
--- a/arch/xtensa/include/asm/resource.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/resource.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_RESOURCE_H
-#define _XTENSA_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif	/* _XTENSA_RESOURCE_H */
diff --git a/arch/xtensa/include/asm/scatterlist.h b/arch/xtensa/include/asm/scatterlist.h
deleted file mode 100644
index a0421a6..0000000
--- a/arch/xtensa/include/asm/scatterlist.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/scatterlist.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_SCATTERLIST_H
-#define _XTENSA_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif	/* _XTENSA_SCATTERLIST_H */
diff --git a/arch/xtensa/include/asm/sections.h b/arch/xtensa/include/asm/sections.h
deleted file mode 100644
index 40b5191..0000000
--- a/arch/xtensa/include/asm/sections.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/sections.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_SECTIONS_H
-#define _XTENSA_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif	/* _XTENSA_SECTIONS_H */
diff --git a/arch/xtensa/include/asm/siginfo.h b/arch/xtensa/include/asm/siginfo.h
deleted file mode 100644
index 6916248..0000000
--- a/arch/xtensa/include/asm/siginfo.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/siginfo.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_SIGINFO_H
-#define _XTENSA_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif	/* _XTENSA_SIGINFO_H */
diff --git a/arch/xtensa/include/asm/statfs.h b/arch/xtensa/include/asm/statfs.h
deleted file mode 100644
index 9c3d1a2..0000000
--- a/arch/xtensa/include/asm/statfs.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * include/asm-xtensa/statfs.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_STATFS_H
-#define _XTENSA_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif	/* _XTENSA_STATFS_H */
-
diff --git a/arch/xtensa/include/asm/topology.h b/arch/xtensa/include/asm/topology.h
deleted file mode 100644
index 7309e38..0000000
--- a/arch/xtensa/include/asm/topology.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/topology.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_TOPOLOGY_H
-#define _XTENSA_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif	/* _XTENSA_TOPOLOGY_H */
diff --git a/arch/xtensa/include/asm/xor.h b/arch/xtensa/include/asm/xor.h
deleted file mode 100644
index e7b1f08..0000000
--- a/arch/xtensa/include/asm/xor.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/xor.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_XOR_H
-#define _XTENSA_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif
-- 
1.7.10.4


