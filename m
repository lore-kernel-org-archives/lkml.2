Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2JMCcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2JMC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:58 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2JtMZUCRf5wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hP58i1Z_jJgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=jZMlDQDQAAAA:8 a=pGLkceISAAAA:8 a=il0GAASvb2Kd3kMr7tQA:9 a=jEp0ucaQiEUA:10 a=qjWqTI40CIwA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022955.163771484@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 19/25] score: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0019-score-Use-Kbuild-infrastructure-to-handle-asm-generi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/score/include/asm/Kbuild              |   44 ++++++++++++++++++++++++++++
 arch/score/include/asm/bitsperlong.h       |    6 ----
 arch/score/include/asm/bugs.h              |    6 ----
 arch/score/include/asm/cputime.h           |    6 ----
 arch/score/include/asm/current.h           |    6 ----
 arch/score/include/asm/device.h            |    6 ----
 arch/score/include/asm/div64.h             |    6 ----
 arch/score/include/asm/emergency-restart.h |    6 ----
 arch/score/include/asm/errno.h             |    6 ----
 arch/score/include/asm/fcntl.h             |    6 ----
 arch/score/include/asm/futex.h             |    6 ----
 arch/score/include/asm/hardirq.h           |    6 ----
 arch/score/include/asm/ioctl.h             |    6 ----
 arch/score/include/asm/ioctls.h            |    6 ----
 arch/score/include/asm/ipcbuf.h            |    6 ----
 arch/score/include/asm/kdebug.h            |    6 ----
 arch/score/include/asm/kmap_types.h        |    6 ----
 arch/score/include/asm/kvm_para.h          |    1 -
 arch/score/include/asm/local.h             |    6 ----
 arch/score/include/asm/local64.h           |    1 -
 arch/score/include/asm/mman.h              |    6 ----
 arch/score/include/asm/msgbuf.h            |    6 ----
 arch/score/include/asm/param.h             |    6 ----
 arch/score/include/asm/percpu.h            |    6 ----
 arch/score/include/asm/poll.h              |    6 ----
 arch/score/include/asm/posix_types.h       |    6 ----
 arch/score/include/asm/resource.h          |    6 ----
 arch/score/include/asm/scatterlist.h       |    6 ----
 arch/score/include/asm/sections.h          |    6 ----
 arch/score/include/asm/sembuf.h            |    6 ----
 arch/score/include/asm/shmbuf.h            |    6 ----
 arch/score/include/asm/shmparam.h          |    6 ----
 arch/score/include/asm/siginfo.h           |    6 ----
 arch/score/include/asm/signal.h            |    6 ----
 arch/score/include/asm/socket.h            |    6 ----
 arch/score/include/asm/sockios.h           |    6 ----
 arch/score/include/asm/stat.h              |    6 ----
 arch/score/include/asm/statfs.h            |    6 ----
 arch/score/include/asm/swab.h              |    6 ----
 arch/score/include/asm/termbits.h          |    6 ----
 arch/score/include/asm/termios.h           |    6 ----
 arch/score/include/asm/topology.h          |    6 ----
 arch/score/include/asm/types.h             |    6 ----
 arch/score/include/asm/ucontext.h          |    1 -
 arch/score/include/asm/unaligned.h         |    6 ----
 45 files changed, 44 insertions(+), 249 deletions(-)
 delete mode 100644 arch/score/include/asm/bitsperlong.h
 delete mode 100644 arch/score/include/asm/bugs.h
 delete mode 100644 arch/score/include/asm/cputime.h
 delete mode 100644 arch/score/include/asm/current.h
 delete mode 100644 arch/score/include/asm/device.h
 delete mode 100644 arch/score/include/asm/div64.h
 delete mode 100644 arch/score/include/asm/emergency-restart.h
 delete mode 100644 arch/score/include/asm/errno.h
 delete mode 100644 arch/score/include/asm/fcntl.h
 delete mode 100644 arch/score/include/asm/futex.h
 delete mode 100644 arch/score/include/asm/hardirq.h
 delete mode 100644 arch/score/include/asm/ioctl.h
 delete mode 100644 arch/score/include/asm/ioctls.h
 delete mode 100644 arch/score/include/asm/ipcbuf.h
 delete mode 100644 arch/score/include/asm/kdebug.h
 delete mode 100644 arch/score/include/asm/kmap_types.h
 delete mode 100644 arch/score/include/asm/kvm_para.h
 delete mode 100644 arch/score/include/asm/local.h
 delete mode 100644 arch/score/include/asm/local64.h
 delete mode 100644 arch/score/include/asm/mman.h
 delete mode 100644 arch/score/include/asm/msgbuf.h
 delete mode 100644 arch/score/include/asm/param.h
 delete mode 100644 arch/score/include/asm/percpu.h
 delete mode 100644 arch/score/include/asm/poll.h
 delete mode 100644 arch/score/include/asm/posix_types.h
 delete mode 100644 arch/score/include/asm/resource.h
 delete mode 100644 arch/score/include/asm/scatterlist.h
 delete mode 100644 arch/score/include/asm/sections.h
 delete mode 100644 arch/score/include/asm/sembuf.h
 delete mode 100644 arch/score/include/asm/shmbuf.h
 delete mode 100644 arch/score/include/asm/shmparam.h
 delete mode 100644 arch/score/include/asm/siginfo.h
 delete mode 100644 arch/score/include/asm/signal.h
 delete mode 100644 arch/score/include/asm/socket.h
 delete mode 100644 arch/score/include/asm/sockios.h
 delete mode 100644 arch/score/include/asm/stat.h
 delete mode 100644 arch/score/include/asm/statfs.h
 delete mode 100644 arch/score/include/asm/swab.h
 delete mode 100644 arch/score/include/asm/termbits.h
 delete mode 100644 arch/score/include/asm/termios.h
 delete mode 100644 arch/score/include/asm/topology.h
 delete mode 100644 arch/score/include/asm/types.h
 delete mode 100644 arch/score/include/asm/ucontext.h
 delete mode 100644 arch/score/include/asm/unaligned.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index ec697ae..05f0172 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -2,4 +2,48 @@ include include/asm-generic/Kbuild.asm
 
 header-y +=
 
+generic-y += bitsperlong.h
+generic-y += bugs.h
+generic-y += cputime.h
+generic-y += current.h
 generic-y += clkdev.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += signal.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += statfs.h
+generic-y += stat.h
+generic-y += swab.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += unaligned.h
diff --git a/arch/score/include/asm/bitsperlong.h b/arch/score/include/asm/bitsperlong.h
deleted file mode 100644
index 86ff337..0000000
--- a/arch/score/include/asm/bitsperlong.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_BITSPERLONG_H
-#define _ASM_SCORE_BITSPERLONG_H
-
-#include <asm-generic/bitsperlong.h>
-
-#endif /* _ASM_SCORE_BITSPERLONG_H */
diff --git a/arch/score/include/asm/bugs.h b/arch/score/include/asm/bugs.h
deleted file mode 100644
index a062e10..0000000
--- a/arch/score/include/asm/bugs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_BUGS_H
-#define _ASM_SCORE_BUGS_H
-
-#include <asm-generic/bugs.h>
-
-#endif /* _ASM_SCORE_BUGS_H */
diff --git a/arch/score/include/asm/cputime.h b/arch/score/include/asm/cputime.h
deleted file mode 100644
index 1fced99..0000000
--- a/arch/score/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_CPUTIME_H
-#define _ASM_SCORE_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_SCORE_CPUTIME_H */
diff --git a/arch/score/include/asm/current.h b/arch/score/include/asm/current.h
deleted file mode 100644
index 16eae9c..0000000
--- a/arch/score/include/asm/current.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_CURRENT_H
-#define _ASM_SCORE_CURRENT_H
-
-#include <asm-generic/current.h>
-
-#endif /* _ASM_SCORE_CURRENT_H */
diff --git a/arch/score/include/asm/device.h b/arch/score/include/asm/device.h
deleted file mode 100644
index 2dc7cc5..0000000
--- a/arch/score/include/asm/device.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_DEVICE_H
-#define _ASM_SCORE_DEVICE_H
-
-#include <asm-generic/device.h>
-
-#endif /* _ASM_SCORE_DEVICE_H */
diff --git a/arch/score/include/asm/div64.h b/arch/score/include/asm/div64.h
deleted file mode 100644
index 75fae19..0000000
--- a/arch/score/include/asm/div64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_DIV64_H
-#define _ASM_SCORE_DIV64_H
-
-#include <asm-generic/div64.h>
-
-#endif /* _ASM_SCORE_DIV64_H */
diff --git a/arch/score/include/asm/emergency-restart.h b/arch/score/include/asm/emergency-restart.h
deleted file mode 100644
index ca31e98..0000000
--- a/arch/score/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_EMERGENCY_RESTART_H
-#define _ASM_SCORE_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_SCORE_EMERGENCY_RESTART_H */
diff --git a/arch/score/include/asm/errno.h b/arch/score/include/asm/errno.h
deleted file mode 100644
index 29ff39d..0000000
--- a/arch/score/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_ERRNO_H
-#define _ASM_SCORE_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _ASM_SCORE_ERRNO_H */
diff --git a/arch/score/include/asm/fcntl.h b/arch/score/include/asm/fcntl.h
deleted file mode 100644
index 03968a3..0000000
--- a/arch/score/include/asm/fcntl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_FCNTL_H
-#define _ASM_SCORE_FCNTL_H
-
-#include <asm-generic/fcntl.h>
-
-#endif /* _ASM_SCORE_FCNTL_H */
diff --git a/arch/score/include/asm/futex.h b/arch/score/include/asm/futex.h
deleted file mode 100644
index 1dca242..0000000
--- a/arch/score/include/asm/futex.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_FUTEX_H
-#define _ASM_SCORE_FUTEX_H
-
-#include <asm-generic/futex.h>
-
-#endif /* _ASM_SCORE_FUTEX_H */
diff --git a/arch/score/include/asm/hardirq.h b/arch/score/include/asm/hardirq.h
deleted file mode 100644
index dc932c5..0000000
--- a/arch/score/include/asm/hardirq.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_HARDIRQ_H
-#define _ASM_SCORE_HARDIRQ_H
-
-#include <asm-generic/hardirq.h>
-
-#endif /* _ASM_SCORE_HARDIRQ_H */
diff --git a/arch/score/include/asm/ioctl.h b/arch/score/include/asm/ioctl.h
deleted file mode 100644
index a351d21..0000000
--- a/arch/score/include/asm/ioctl.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_IOCTL_H
-#define _ASM_SCORE_IOCTL_H
-
-#include <asm-generic/ioctl.h>
-
-#endif /* _ASM_SCORE_IOCTL_H */
diff --git a/arch/score/include/asm/ioctls.h b/arch/score/include/asm/ioctls.h
deleted file mode 100644
index ed01d2b..0000000
--- a/arch/score/include/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_IOCTLS_H
-#define _ASM_SCORE_IOCTLS_H
-
-#include <asm-generic/ioctls.h>
-
-#endif /* _ASM_SCORE_IOCTLS_H */
diff --git a/arch/score/include/asm/ipcbuf.h b/arch/score/include/asm/ipcbuf.h
deleted file mode 100644
index e082cef..0000000
--- a/arch/score/include/asm/ipcbuf.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_IPCBUF_H
-#define _ASM_SCORE_IPCBUF_H
-
-#include <asm-generic/ipcbuf.h>
-
-#endif /* _ASM_SCORE_IPCBUF_H */
diff --git a/arch/score/include/asm/kdebug.h b/arch/score/include/asm/kdebug.h
deleted file mode 100644
index a666e51..0000000
--- a/arch/score/include/asm/kdebug.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_KDEBUG_H
-#define _ASM_SCORE_KDEBUG_H
-
-#include <asm-generic/kdebug.h>
-
-#endif /* _ASM_SCORE_KDEBUG_H */
diff --git a/arch/score/include/asm/kmap_types.h b/arch/score/include/asm/kmap_types.h
deleted file mode 100644
index 6c46eb5..0000000
--- a/arch/score/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_KMAP_TYPES_H
-#define _ASM_SCORE_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif /* _ASM_SCORE_KMAP_TYPES_H */
diff --git a/arch/score/include/asm/kvm_para.h b/arch/score/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/score/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/score/include/asm/local.h b/arch/score/include/asm/local.h
deleted file mode 100644
index 7e02f13..0000000
--- a/arch/score/include/asm/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_LOCAL_H
-#define _ASM_SCORE_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_SCORE_LOCAL_H */
diff --git a/arch/score/include/asm/local64.h b/arch/score/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/score/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/score/include/asm/mman.h b/arch/score/include/asm/mman.h
deleted file mode 100644
index 84d85dd..0000000
--- a/arch/score/include/asm/mman.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_MMAN_H
-#define _ASM_SCORE_MMAN_H
-
-#include <asm-generic/mman.h>
-
-#endif /* _ASM_SCORE_MMAN_H */
diff --git a/arch/score/include/asm/msgbuf.h b/arch/score/include/asm/msgbuf.h
deleted file mode 100644
index 7506721..0000000
--- a/arch/score/include/asm/msgbuf.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_MSGBUF_H
-#define _ASM_SCORE_MSGBUF_H
-
-#include <asm-generic/msgbuf.h>
-
-#endif /* _ASM_SCORE_MSGBUF_H */
diff --git a/arch/score/include/asm/param.h b/arch/score/include/asm/param.h
deleted file mode 100644
index 916b869..0000000
--- a/arch/score/include/asm/param.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_PARAM_H
-#define _ASM_SCORE_PARAM_H
-
-#include <asm-generic/param.h>
-
-#endif /* _ASM_SCORE_PARAM_H */
diff --git a/arch/score/include/asm/percpu.h b/arch/score/include/asm/percpu.h
deleted file mode 100644
index e7bd4e0..0000000
--- a/arch/score/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_PERCPU_H
-#define _ASM_SCORE_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif /* _ASM_SCORE_PERCPU_H */
diff --git a/arch/score/include/asm/poll.h b/arch/score/include/asm/poll.h
deleted file mode 100644
index 18532db..0000000
--- a/arch/score/include/asm/poll.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_POLL_H
-#define _ASM_SCORE_POLL_H
-
-#include <asm-generic/poll.h>
-
-#endif /* _ASM_SCORE_POLL_H */
diff --git a/arch/score/include/asm/posix_types.h b/arch/score/include/asm/posix_types.h
deleted file mode 100644
index b88acf8..0000000
--- a/arch/score/include/asm/posix_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_POSIX_TYPES_H
-#define _ASM_SCORE_POSIX_TYPES_H
-
-#include <asm-generic/posix_types.h>
-
-#endif /* _ASM_SCORE_POSIX_TYPES_H */
diff --git a/arch/score/include/asm/resource.h b/arch/score/include/asm/resource.h
deleted file mode 100644
index 9ce22bc..0000000
--- a/arch/score/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_RESOURCE_H
-#define _ASM_SCORE_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* _ASM_SCORE_RESOURCE_H */
diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
deleted file mode 100644
index 9f533b8..0000000
--- a/arch/score/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SCATTERLIST_H
-#define _ASM_SCORE_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_SCORE_SCATTERLIST_H */
diff --git a/arch/score/include/asm/sections.h b/arch/score/include/asm/sections.h
deleted file mode 100644
index 9441d23..0000000
--- a/arch/score/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SECTIONS_H
-#define _ASM_SCORE_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* _ASM_SCORE_SECTIONS_H */
diff --git a/arch/score/include/asm/sembuf.h b/arch/score/include/asm/sembuf.h
deleted file mode 100644
index dae5e83..0000000
--- a/arch/score/include/asm/sembuf.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SEMBUF_H
-#define _ASM_SCORE_SEMBUF_H
-
-#include <asm-generic/sembuf.h>
-
-#endif /* _ASM_SCORE_SEMBUF_H */
diff --git a/arch/score/include/asm/shmbuf.h b/arch/score/include/asm/shmbuf.h
deleted file mode 100644
index c85b242..0000000
--- a/arch/score/include/asm/shmbuf.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SHMBUF_H
-#define _ASM_SCORE_SHMBUF_H
-
-#include <asm-generic/shmbuf.h>
-
-#endif /* _ASM_SCORE_SHMBUF_H */
diff --git a/arch/score/include/asm/shmparam.h b/arch/score/include/asm/shmparam.h
deleted file mode 100644
index 1d60813..0000000
--- a/arch/score/include/asm/shmparam.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SHMPARAM_H
-#define _ASM_SCORE_SHMPARAM_H
-
-#include <asm-generic/shmparam.h>
-
-#endif /* _ASM_SCORE_SHMPARAM_H */
diff --git a/arch/score/include/asm/siginfo.h b/arch/score/include/asm/siginfo.h
deleted file mode 100644
index 87ca356..0000000
--- a/arch/score/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SIGINFO_H
-#define _ASM_SCORE_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif /* _ASM_SCORE_SIGINFO_H */
diff --git a/arch/score/include/asm/signal.h b/arch/score/include/asm/signal.h
deleted file mode 100644
index 2605bc0..0000000
--- a/arch/score/include/asm/signal.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SIGNAL_H
-#define _ASM_SCORE_SIGNAL_H
-
-#include <asm-generic/signal.h>
-
-#endif /* _ASM_SCORE_SIGNAL_H */
diff --git a/arch/score/include/asm/socket.h b/arch/score/include/asm/socket.h
deleted file mode 100644
index 612a70e..0000000
--- a/arch/score/include/asm/socket.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SOCKET_H
-#define _ASM_SCORE_SOCKET_H
-
-#include <asm-generic/socket.h>
-
-#endif /* _ASM_SCORE_SOCKET_H */
diff --git a/arch/score/include/asm/sockios.h b/arch/score/include/asm/sockios.h
deleted file mode 100644
index ba825648..0000000
--- a/arch/score/include/asm/sockios.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SOCKIOS_H
-#define _ASM_SCORE_SOCKIOS_H
-
-#include <asm-generic/sockios.h>
-
-#endif /* _ASM_SCORE_SOCKIOS_H */
diff --git a/arch/score/include/asm/stat.h b/arch/score/include/asm/stat.h
deleted file mode 100644
index 5037055..0000000
--- a/arch/score/include/asm/stat.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_STAT_H
-#define _ASM_SCORE_STAT_H
-
-#include <asm-generic/stat.h>
-
-#endif /* _ASM_SCORE_STAT_H */
diff --git a/arch/score/include/asm/statfs.h b/arch/score/include/asm/statfs.h
deleted file mode 100644
index 36e4100..0000000
--- a/arch/score/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_STATFS_H
-#define _ASM_SCORE_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* _ASM_SCORE_STATFS_H */
diff --git a/arch/score/include/asm/swab.h b/arch/score/include/asm/swab.h
deleted file mode 100644
index fadc3cc..0000000
--- a/arch/score/include/asm/swab.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SWAB_H
-#define _ASM_SCORE_SWAB_H
-
-#include <asm-generic/swab.h>
-
-#endif /* _ASM_SCORE_SWAB_H */
diff --git a/arch/score/include/asm/termbits.h b/arch/score/include/asm/termbits.h
deleted file mode 100644
index 9a95c14..0000000
--- a/arch/score/include/asm/termbits.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_TERMBITS_H
-#define _ASM_SCORE_TERMBITS_H
-
-#include <asm-generic/termbits.h>
-
-#endif /* _ASM_SCORE_TERMBITS_H */
diff --git a/arch/score/include/asm/termios.h b/arch/score/include/asm/termios.h
deleted file mode 100644
index 40984e8..0000000
--- a/arch/score/include/asm/termios.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_TERMIOS_H
-#define _ASM_SCORE_TERMIOS_H
-
-#include <asm-generic/termios.h>
-
-#endif /* _ASM_SCORE_TERMIOS_H */
diff --git a/arch/score/include/asm/topology.h b/arch/score/include/asm/topology.h
deleted file mode 100644
index 425fba3..0000000
--- a/arch/score/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_TOPOLOGY_H
-#define _ASM_SCORE_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_SCORE_TOPOLOGY_H */
diff --git a/arch/score/include/asm/types.h b/arch/score/include/asm/types.h
deleted file mode 100644
index 2140032..0000000
--- a/arch/score/include/asm/types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_TYPES_H
-#define _ASM_SCORE_TYPES_H
-
-#include <asm-generic/types.h>
-
-#endif /* _ASM_SCORE_TYPES_H */
diff --git a/arch/score/include/asm/ucontext.h b/arch/score/include/asm/ucontext.h
deleted file mode 100644
index 9bc07b9..0000000
--- a/arch/score/include/asm/ucontext.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ucontext.h>
diff --git a/arch/score/include/asm/unaligned.h b/arch/score/include/asm/unaligned.h
deleted file mode 100644
index 2fc06de..0000000
--- a/arch/score/include/asm/unaligned.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_UNALIGNED_H
-#define _ASM_SCORE_UNALIGNED_H
-
-#include <asm-generic/unaligned.h>
-
-#endif /* _ASM_SCORE_UNALIGNED_H */
-- 
1.7.10.4


