Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2JMCcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2JMC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:57 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lE5PCzwO-R4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Hf1TiuWfIdkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3-RhneuVAAAA:8 a=F76KFZQujwd9Sgm3upkA:9 a=jEp0ucaQiEUA:10 a=GuvPbblSkfQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022953.277065855@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 06/25] cris: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0006-cris-Use-Kbuild-infrastructure-to-handle-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/cris/include/asm/Kbuild              |   24 ++++++++++++++++++++++++
 arch/cris/include/asm/bitsperlong.h       |    1 -
 arch/cris/include/asm/cputime.h           |    6 ------
 arch/cris/include/asm/device.h            |    7 -------
 arch/cris/include/asm/div64.h             |    1 -
 arch/cris/include/asm/emergency-restart.h |    6 ------
 arch/cris/include/asm/errno.h             |    6 ------
 arch/cris/include/asm/fcntl.h             |    1 -
 arch/cris/include/asm/futex.h             |    6 ------
 arch/cris/include/asm/ioctl.h             |    1 -
 arch/cris/include/asm/irq_regs.h          |    1 -
 arch/cris/include/asm/kdebug.h            |    1 -
 arch/cris/include/asm/kmap_types.h        |   10 ----------
 arch/cris/include/asm/local.h             |    1 -
 arch/cris/include/asm/local64.h           |    1 -
 arch/cris/include/asm/mman.h              |    1 -
 arch/cris/include/asm/percpu.h            |    6 ------
 arch/cris/include/asm/poll.h              |    1 -
 arch/cris/include/asm/resource.h          |    6 ------
 arch/cris/include/asm/scatterlist.h       |    6 ------
 arch/cris/include/asm/sections.h          |    7 -------
 arch/cris/include/asm/siginfo.h           |    6 ------
 arch/cris/include/asm/statfs.h            |    6 ------
 arch/cris/include/asm/topology.h          |    6 ------
 arch/frv/include/asm/ipcbuf.h             |    1 -
 25 files changed, 24 insertions(+), 95 deletions(-)
 delete mode 100644 arch/cris/include/asm/bitsperlong.h
 delete mode 100644 arch/cris/include/asm/cputime.h
 delete mode 100644 arch/cris/include/asm/device.h
 delete mode 100644 arch/cris/include/asm/div64.h
 delete mode 100644 arch/cris/include/asm/emergency-restart.h
 delete mode 100644 arch/cris/include/asm/errno.h
 delete mode 100644 arch/cris/include/asm/fcntl.h
 delete mode 100644 arch/cris/include/asm/futex.h
 delete mode 100644 arch/cris/include/asm/ioctl.h
 delete mode 100644 arch/cris/include/asm/irq_regs.h
 delete mode 100644 arch/cris/include/asm/kdebug.h
 delete mode 100644 arch/cris/include/asm/kmap_types.h
 delete mode 100644 arch/cris/include/asm/local.h
 delete mode 100644 arch/cris/include/asm/local64.h
 delete mode 100644 arch/cris/include/asm/mman.h
 delete mode 100644 arch/cris/include/asm/percpu.h
 delete mode 100644 arch/cris/include/asm/poll.h
 delete mode 100644 arch/cris/include/asm/resource.h
 delete mode 100644 arch/cris/include/asm/scatterlist.h
 delete mode 100644 arch/cris/include/asm/sections.h
 delete mode 100644 arch/cris/include/asm/siginfo.h
 delete mode 100644 arch/cris/include/asm/statfs.h
 delete mode 100644 arch/cris/include/asm/topology.h
 delete mode 100644 arch/frv/include/asm/ipcbuf.h

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index ff1bf7f..502409a 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -8,5 +8,29 @@ header-y += etraxgpio.h
 header-y += rs485.h
 header-y += sync_serial.h
 
+generic-y += bitsperlong.h
 generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fcntl.h
+generic-y += futex.h
+generic-y += ioctl.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
diff --git a/arch/cris/include/asm/bitsperlong.h b/arch/cris/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/cris/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/cris/include/asm/cputime.h b/arch/cris/include/asm/cputime.h
deleted file mode 100644
index 4446a65..0000000
--- a/arch/cris/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __CRIS_CPUTIME_H
-#define __CRIS_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __CRIS_CPUTIME_H */
diff --git a/arch/cris/include/asm/device.h b/arch/cris/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/cris/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/cris/include/asm/div64.h b/arch/cris/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/cris/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/cris/include/asm/emergency-restart.h b/arch/cris/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/cris/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/cris/include/asm/errno.h b/arch/cris/include/asm/errno.h
deleted file mode 100644
index 2bf5eb5..0000000
--- a/arch/cris/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_ERRNO_H
-#define _CRIS_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/arch/cris/include/asm/fcntl.h b/arch/cris/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/cris/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/cris/include/asm/futex.h b/arch/cris/include/asm/futex.h
deleted file mode 100644
index 6a332a9..0000000
--- a/arch/cris/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif
diff --git a/arch/cris/include/asm/ioctl.h b/arch/cris/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/cris/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/cris/include/asm/irq_regs.h b/arch/cris/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/cris/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/cris/include/asm/kdebug.h b/arch/cris/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/cris/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/cris/include/asm/kmap_types.h b/arch/cris/include/asm/kmap_types.h
deleted file mode 100644
index d2d643c..0000000
--- a/arch/cris/include/asm/kmap_types.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _ASM_KMAP_TYPES_H
-#define _ASM_KMAP_TYPES_H
-
-/* Dummy header just to define km_type.  None of this
- * is actually used on cris. 
- */
-
-#include <asm-generic/kmap_types.h>
-
-#endif
diff --git a/arch/cris/include/asm/local.h b/arch/cris/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/cris/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/cris/include/asm/local64.h b/arch/cris/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/cris/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/cris/include/asm/mman.h b/arch/cris/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/cris/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/cris/include/asm/percpu.h b/arch/cris/include/asm/percpu.h
deleted file mode 100644
index 6db9b43..0000000
--- a/arch/cris/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_PERCPU_H
-#define _CRIS_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif /* _CRIS_PERCPU_H */
diff --git a/arch/cris/include/asm/poll.h b/arch/cris/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/cris/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/cris/include/asm/resource.h b/arch/cris/include/asm/resource.h
deleted file mode 100644
index b5d2944..0000000
--- a/arch/cris/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_RESOURCE_H
-#define _CRIS_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/arch/cris/include/asm/scatterlist.h b/arch/cris/include/asm/scatterlist.h
deleted file mode 100644
index f11f8f4..0000000
--- a/arch/cris/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_CRIS_SCATTERLIST_H
-#define __ASM_CRIS_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(__ASM_CRIS_SCATTERLIST_H) */
diff --git a/arch/cris/include/asm/sections.h b/arch/cris/include/asm/sections.h
deleted file mode 100644
index 2c998ce..0000000
--- a/arch/cris/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _CRIS_SECTIONS_H
-#define _CRIS_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
diff --git a/arch/cris/include/asm/siginfo.h b/arch/cris/include/asm/siginfo.h
deleted file mode 100644
index c1cd6d1..0000000
--- a/arch/cris/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_SIGINFO_H
-#define _CRIS_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/cris/include/asm/statfs.h b/arch/cris/include/asm/statfs.h
deleted file mode 100644
index fdaf921..0000000
--- a/arch/cris/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_STATFS_H
-#define _CRIS_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif
diff --git a/arch/cris/include/asm/topology.h b/arch/cris/include/asm/topology.h
deleted file mode 100644
index 2ac613d..0000000
--- a/arch/cris/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CRIS_TOPOLOGY_H
-#define _ASM_CRIS_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_CRIS_TOPOLOGY_H */
diff --git a/arch/frv/include/asm/ipcbuf.h b/arch/frv/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/frv/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


