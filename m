Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2JMCaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:30:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2JMC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:54 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qgfTjJxC29oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ww5mSr8c1JUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=CvUdTiy4tJQUHe-TyDwA:9 a=xfgwSJ47VNUA:10 a=sFH2PsMc908A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022952.855483404@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 03/25] avr32: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0003-avr32-Use-Kbuild-infrastructure-to-handle-asm-generi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/avr32/include/asm/Kbuild              |   27 +++++++++++++++++++++++++++
 arch/avr32/include/asm/bitsperlong.h       |    1 -
 arch/avr32/include/asm/cputime.h           |    6 ------
 arch/avr32/include/asm/delay.h             |    1 -
 arch/avr32/include/asm/device.h            |    7 -------
 arch/avr32/include/asm/div64.h             |    6 ------
 arch/avr32/include/asm/emergency-restart.h |    6 ------
 arch/avr32/include/asm/errno.h             |    6 ------
 arch/avr32/include/asm/fcntl.h             |    6 ------
 arch/avr32/include/asm/futex.h             |    6 ------
 arch/avr32/include/asm/ioctl.h             |    6 ------
 arch/avr32/include/asm/ioctls.h            |    6 ------
 arch/avr32/include/asm/irq_regs.h          |    1 -
 arch/avr32/include/asm/kvm_para.h          |    1 -
 arch/avr32/include/asm/local.h             |    6 ------
 arch/avr32/include/asm/local64.h           |    1 -
 arch/avr32/include/asm/mman.h              |    1 -
 arch/avr32/include/asm/percpu.h            |    6 ------
 arch/avr32/include/asm/poll.h              |    1 -
 arch/avr32/include/asm/resource.h          |    6 ------
 arch/avr32/include/asm/scatterlist.h       |    6 ------
 arch/avr32/include/asm/sections.h          |    6 ------
 arch/avr32/include/asm/siginfo.h           |    6 ------
 arch/avr32/include/asm/statfs.h            |    6 ------
 arch/avr32/include/asm/topology.h          |    6 ------
 arch/avr32/include/asm/xor.h               |    6 ------
 arch/cris/include/asm/ipcbuf.h             |    1 -
 27 files changed, 27 insertions(+), 117 deletions(-)
 delete mode 100644 arch/avr32/include/asm/bitsperlong.h
 delete mode 100644 arch/avr32/include/asm/cputime.h
 delete mode 100644 arch/avr32/include/asm/delay.h
 delete mode 100644 arch/avr32/include/asm/device.h
 delete mode 100644 arch/avr32/include/asm/div64.h
 delete mode 100644 arch/avr32/include/asm/emergency-restart.h
 delete mode 100644 arch/avr32/include/asm/errno.h
 delete mode 100644 arch/avr32/include/asm/fcntl.h
 delete mode 100644 arch/avr32/include/asm/futex.h
 delete mode 100644 arch/avr32/include/asm/ioctl.h
 delete mode 100644 arch/avr32/include/asm/ioctls.h
 delete mode 100644 arch/avr32/include/asm/irq_regs.h
 delete mode 100644 arch/avr32/include/asm/kvm_para.h
 delete mode 100644 arch/avr32/include/asm/local.h
 delete mode 100644 arch/avr32/include/asm/local64.h
 delete mode 100644 arch/avr32/include/asm/mman.h
 delete mode 100644 arch/avr32/include/asm/percpu.h
 delete mode 100644 arch/avr32/include/asm/poll.h
 delete mode 100644 arch/avr32/include/asm/resource.h
 delete mode 100644 arch/avr32/include/asm/scatterlist.h
 delete mode 100644 arch/avr32/include/asm/sections.h
 delete mode 100644 arch/avr32/include/asm/siginfo.h
 delete mode 100644 arch/avr32/include/asm/statfs.h
 delete mode 100644 arch/avr32/include/asm/topology.h
 delete mode 100644 arch/avr32/include/asm/xor.h
 delete mode 100644 arch/cris/include/asm/ipcbuf.h

diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index be0433e..40573ee 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -4,3 +4,30 @@ generic-y	+= clkdev.h
 generic-y	+= exec.h
 
 header-y	+= cachectl.h
+
+generic-y	+= bitsperlong.h
+generic-y	+= cputime.h
+generic-y	+= delay.h
+generic-y	+= device.h
+generic-y	+= div64.h
+generic-y	+= emergency-restart.h
+generic-y	+= errno.h
+generic-y	+= fcntl.h
+generic-y	+= futex.h
+generic-y	+= ioctl.h
+generic-y	+= ioctls.h
+generic-y	+= ipcbuf.h
+generic-y	+= irq_regs.h
+generic-y	+= kvm_para.h
+generic-y	+= local64.h
+generic-y	+= local.h
+generic-y	+= mman.h
+generic-y	+= percpu.h
+generic-y	+= poll.h
+generic-y	+= resource.h
+generic-y	+= scatterlist.h
+generic-y	+= sections.h
+generic-y	+= siginfo.h
+generic-y	+= statfs.h
+generic-y	+= topology.h
+generic-y	+= xor.h
diff --git a/arch/avr32/include/asm/bitsperlong.h b/arch/avr32/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/avr32/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/avr32/include/asm/cputime.h b/arch/avr32/include/asm/cputime.h
deleted file mode 100644
index e87e0f8..0000000
--- a/arch/avr32/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_CPUTIME_H
-#define __ASM_AVR32_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __ASM_AVR32_CPUTIME_H */
diff --git a/arch/avr32/include/asm/delay.h b/arch/avr32/include/asm/delay.h
deleted file mode 100644
index 9670e12..0000000
--- a/arch/avr32/include/asm/delay.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/delay.h>
diff --git a/arch/avr32/include/asm/device.h b/arch/avr32/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/avr32/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/avr32/include/asm/div64.h b/arch/avr32/include/asm/div64.h
deleted file mode 100644
index d7ddd4f..0000000
--- a/arch/avr32/include/asm/div64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_DIV64_H
-#define __ASM_AVR32_DIV64_H
-
-#include <asm-generic/div64.h>
-
-#endif /* __ASM_AVR32_DIV64_H */
diff --git a/arch/avr32/include/asm/emergency-restart.h b/arch/avr32/include/asm/emergency-restart.h
deleted file mode 100644
index 3e7e014..0000000
--- a/arch/avr32/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_EMERGENCY_RESTART_H
-#define __ASM_AVR32_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* __ASM_AVR32_EMERGENCY_RESTART_H */
diff --git a/arch/avr32/include/asm/errno.h b/arch/avr32/include/asm/errno.h
deleted file mode 100644
index 558a724..0000000
--- a/arch/avr32/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_ERRNO_H
-#define __ASM_AVR32_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* __ASM_AVR32_ERRNO_H */
diff --git a/arch/avr32/include/asm/fcntl.h b/arch/avr32/include/asm/fcntl.h
deleted file mode 100644
index 14c0c44..0000000
--- a/arch/avr32/include/asm/fcntl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_FCNTL_H
-#define __ASM_AVR32_FCNTL_H
-
-#include <asm-generic/fcntl.h>
-
-#endif /* __ASM_AVR32_FCNTL_H */
diff --git a/arch/avr32/include/asm/futex.h b/arch/avr32/include/asm/futex.h
deleted file mode 100644
index 10419f1..0000000
--- a/arch/avr32/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_FUTEX_H
-#define __ASM_AVR32_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif /* __ASM_AVR32_FUTEX_H */
diff --git a/arch/avr32/include/asm/ioctl.h b/arch/avr32/include/asm/ioctl.h
deleted file mode 100644
index c8472c1..0000000
--- a/arch/avr32/include/asm/ioctl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_IOCTL_H
-#define __ASM_AVR32_IOCTL_H
-
-#include <asm-generic/ioctl.h>
-
-#endif /* __ASM_AVR32_IOCTL_H */
diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
deleted file mode 100644
index 909cf66..0000000
--- a/arch/avr32/include/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_IOCTLS_H
-#define __ASM_AVR32_IOCTLS_H
-
-#include <asm-generic/ioctls.h>
-
-#endif /* __ASM_AVR32_IOCTLS_H */
diff --git a/arch/avr32/include/asm/irq_regs.h b/arch/avr32/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/avr32/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/avr32/include/asm/kvm_para.h b/arch/avr32/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/avr32/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/avr32/include/asm/local.h b/arch/avr32/include/asm/local.h
deleted file mode 100644
index 1c16196..0000000
--- a/arch/avr32/include/asm/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_LOCAL_H
-#define __ASM_AVR32_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __ASM_AVR32_LOCAL_H */
diff --git a/arch/avr32/include/asm/local64.h b/arch/avr32/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/avr32/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/avr32/include/asm/mman.h b/arch/avr32/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/avr32/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/avr32/include/asm/percpu.h b/arch/avr32/include/asm/percpu.h
deleted file mode 100644
index 69227b4..0000000
--- a/arch/avr32/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_PERCPU_H
-#define __ASM_AVR32_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif /* __ASM_AVR32_PERCPU_H */
diff --git a/arch/avr32/include/asm/poll.h b/arch/avr32/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/avr32/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/avr32/include/asm/resource.h b/arch/avr32/include/asm/resource.h
deleted file mode 100644
index c6dd101..0000000
--- a/arch/avr32/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_RESOURCE_H
-#define __ASM_AVR32_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* __ASM_AVR32_RESOURCE_H */
diff --git a/arch/avr32/include/asm/scatterlist.h b/arch/avr32/include/asm/scatterlist.h
deleted file mode 100644
index a5902d9..0000000
--- a/arch/avr32/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_SCATTERLIST_H
-#define __ASM_AVR32_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* __ASM_AVR32_SCATTERLIST_H */
diff --git a/arch/avr32/include/asm/sections.h b/arch/avr32/include/asm/sections.h
deleted file mode 100644
index aa14252..0000000
--- a/arch/avr32/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_SECTIONS_H
-#define __ASM_AVR32_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* __ASM_AVR32_SECTIONS_H */
diff --git a/arch/avr32/include/asm/siginfo.h b/arch/avr32/include/asm/siginfo.h
deleted file mode 100644
index 5ee93f4..0000000
--- a/arch/avr32/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _AVR32_SIGINFO_H
-#define _AVR32_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/avr32/include/asm/statfs.h b/arch/avr32/include/asm/statfs.h
deleted file mode 100644
index 2961bd1..0000000
--- a/arch/avr32/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_STATFS_H
-#define __ASM_AVR32_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* __ASM_AVR32_STATFS_H */
diff --git a/arch/avr32/include/asm/topology.h b/arch/avr32/include/asm/topology.h
deleted file mode 100644
index 5b766cb..0000000
--- a/arch/avr32/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_TOPOLOGY_H
-#define __ASM_AVR32_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* __ASM_AVR32_TOPOLOGY_H */
diff --git a/arch/avr32/include/asm/xor.h b/arch/avr32/include/asm/xor.h
deleted file mode 100644
index 99c87aa..0000000
--- a/arch/avr32/include/asm/xor.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_XOR_H
-#define _ASM_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif
diff --git a/arch/cris/include/asm/ipcbuf.h b/arch/cris/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/cris/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


