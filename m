Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2JMCeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:34:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2JMC34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:56 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NQCnzHcJYmgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nOXYzS8gOIkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=W5yDZE8ifEmhEUxKnF0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.142913646@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 12/25] microblaze: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0012-microblaze-Use-Kbuild-infrastructure-to-handle-asm-g.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/microblaze/include/asm/Kbuild              |   46 +++++++++++++++++++++++
 arch/microblaze/include/asm/bitops.h            |    1 -
 arch/microblaze/include/asm/bitsperlong.h       |    1 -
 arch/microblaze/include/asm/bug.h               |    1 -
 arch/microblaze/include/asm/bugs.h              |    1 -
 arch/microblaze/include/asm/cputime.h           |    1 -
 arch/microblaze/include/asm/div64.h             |    1 -
 arch/microblaze/include/asm/emergency-restart.h |    1 -
 arch/microblaze/include/asm/errno.h             |    1 -
 arch/microblaze/include/asm/fb.h                |    1 -
 arch/microblaze/include/asm/fcntl.h             |    1 -
 arch/microblaze/include/asm/hardirq.h           |    1 -
 arch/microblaze/include/asm/ioctl.h             |    1 -
 arch/microblaze/include/asm/ioctls.h            |    1 -
 arch/microblaze/include/asm/irq_regs.h          |    1 -
 arch/microblaze/include/asm/kdebug.h            |    1 -
 arch/microblaze/include/asm/kmap_types.h        |    6 ---
 arch/microblaze/include/asm/kvm_para.h          |    1 -
 arch/microblaze/include/asm/local.h             |    1 -
 arch/microblaze/include/asm/local64.h           |    1 -
 arch/microblaze/include/asm/mman.h              |    1 -
 arch/microblaze/include/asm/msgbuf.h            |    1 -
 arch/microblaze/include/asm/param.h             |    1 -
 arch/microblaze/include/asm/parport.h           |    1 -
 arch/microblaze/include/asm/percpu.h            |    1 -
 arch/microblaze/include/asm/poll.h              |    1 -
 arch/microblaze/include/asm/resource.h          |    1 -
 arch/microblaze/include/asm/scatterlist.h       |    1 -
 arch/microblaze/include/asm/sembuf.h            |    1 -
 arch/microblaze/include/asm/serial.h            |    1 -
 arch/microblaze/include/asm/shmbuf.h            |    1 -
 arch/microblaze/include/asm/shmparam.h          |    1 -
 arch/microblaze/include/asm/siginfo.h           |    1 -
 arch/microblaze/include/asm/signal.h            |    1 -
 arch/microblaze/include/asm/socket.h            |    1 -
 arch/microblaze/include/asm/sockios.h           |    1 -
 arch/microblaze/include/asm/stat.h              |    1 -
 arch/microblaze/include/asm/statfs.h            |    1 -
 arch/microblaze/include/asm/swab.h              |    1 -
 arch/microblaze/include/asm/termbits.h          |    1 -
 arch/microblaze/include/asm/termios.h           |    1 -
 arch/microblaze/include/asm/topology.h          |    1 -
 arch/microblaze/include/asm/types.h             |    1 -
 arch/microblaze/include/asm/ucontext.h          |    1 -
 arch/microblaze/include/asm/vga.h               |    1 -
 arch/microblaze/include/asm/xor.h               |    1 -
 arch/mips/include/asm/ipcbuf.h                  |    1 -
 47 files changed, 46 insertions(+), 51 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/bitops.h
 delete mode 100644 arch/microblaze/include/asm/bitsperlong.h
 delete mode 100644 arch/microblaze/include/asm/bug.h
 delete mode 100644 arch/microblaze/include/asm/bugs.h
 delete mode 100644 arch/microblaze/include/asm/cputime.h
 delete mode 100644 arch/microblaze/include/asm/div64.h
 delete mode 100644 arch/microblaze/include/asm/emergency-restart.h
 delete mode 100644 arch/microblaze/include/asm/errno.h
 delete mode 100644 arch/microblaze/include/asm/fb.h
 delete mode 100644 arch/microblaze/include/asm/fcntl.h
 delete mode 100644 arch/microblaze/include/asm/hardirq.h
 delete mode 100644 arch/microblaze/include/asm/ioctl.h
 delete mode 100644 arch/microblaze/include/asm/ioctls.h
 delete mode 100644 arch/microblaze/include/asm/irq_regs.h
 delete mode 100644 arch/microblaze/include/asm/kdebug.h
 delete mode 100644 arch/microblaze/include/asm/kmap_types.h
 delete mode 100644 arch/microblaze/include/asm/kvm_para.h
 delete mode 100644 arch/microblaze/include/asm/local.h
 delete mode 100644 arch/microblaze/include/asm/local64.h
 delete mode 100644 arch/microblaze/include/asm/mman.h
 delete mode 100644 arch/microblaze/include/asm/msgbuf.h
 delete mode 100644 arch/microblaze/include/asm/param.h
 delete mode 100644 arch/microblaze/include/asm/parport.h
 delete mode 100644 arch/microblaze/include/asm/percpu.h
 delete mode 100644 arch/microblaze/include/asm/poll.h
 delete mode 100644 arch/microblaze/include/asm/resource.h
 delete mode 100644 arch/microblaze/include/asm/scatterlist.h
 delete mode 100644 arch/microblaze/include/asm/sembuf.h
 delete mode 100644 arch/microblaze/include/asm/serial.h
 delete mode 100644 arch/microblaze/include/asm/shmbuf.h
 delete mode 100644 arch/microblaze/include/asm/shmparam.h
 delete mode 100644 arch/microblaze/include/asm/siginfo.h
 delete mode 100644 arch/microblaze/include/asm/signal.h
 delete mode 100644 arch/microblaze/include/asm/socket.h
 delete mode 100644 arch/microblaze/include/asm/sockios.h
 delete mode 100644 arch/microblaze/include/asm/stat.h
 delete mode 100644 arch/microblaze/include/asm/statfs.h
 delete mode 100644 arch/microblaze/include/asm/swab.h
 delete mode 100644 arch/microblaze/include/asm/termbits.h
 delete mode 100644 arch/microblaze/include/asm/termios.h
 delete mode 100644 arch/microblaze/include/asm/topology.h
 delete mode 100644 arch/microblaze/include/asm/types.h
 delete mode 100644 arch/microblaze/include/asm/ucontext.h
 delete mode 100644 arch/microblaze/include/asm/vga.h
 delete mode 100644 arch/microblaze/include/asm/xor.h
 delete mode 100644 arch/mips/include/asm/ipcbuf.h

diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 8653072..2f656c8 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,5 +1,51 @@
 include include/asm-generic/Kbuild.asm
 
 header-y  += elf.h
+generic-y += bitops.h
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += hardirq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += serial.h
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
+generic-y += vga.h
+generic-y += xor.h
diff --git a/arch/microblaze/include/asm/bitops.h b/arch/microblaze/include/asm/bitops.h
deleted file mode 100644
index a72468f..0000000
--- a/arch/microblaze/include/asm/bitops.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitops.h>
diff --git a/arch/microblaze/include/asm/bitsperlong.h b/arch/microblaze/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/microblaze/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/microblaze/include/asm/bug.h b/arch/microblaze/include/asm/bug.h
deleted file mode 100644
index b12fd89..0000000
--- a/arch/microblaze/include/asm/bug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bug.h>
diff --git a/arch/microblaze/include/asm/bugs.h b/arch/microblaze/include/asm/bugs.h
deleted file mode 100644
index 61791e1..0000000
--- a/arch/microblaze/include/asm/bugs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bugs.h>
diff --git a/arch/microblaze/include/asm/cputime.h b/arch/microblaze/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/microblaze/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/microblaze/include/asm/div64.h b/arch/microblaze/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/microblaze/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/microblaze/include/asm/emergency-restart.h b/arch/microblaze/include/asm/emergency-restart.h
deleted file mode 100644
index 3711bd9..0000000
--- a/arch/microblaze/include/asm/emergency-restart.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/emergency-restart.h>
diff --git a/arch/microblaze/include/asm/errno.h b/arch/microblaze/include/asm/errno.h
deleted file mode 100644
index 4c82b50..0000000
--- a/arch/microblaze/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/errno.h>
diff --git a/arch/microblaze/include/asm/fb.h b/arch/microblaze/include/asm/fb.h
deleted file mode 100644
index 3a4988e..0000000
--- a/arch/microblaze/include/asm/fb.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fb.h>
diff --git a/arch/microblaze/include/asm/fcntl.h b/arch/microblaze/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/microblaze/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/microblaze/include/asm/hardirq.h b/arch/microblaze/include/asm/hardirq.h
deleted file mode 100644
index fb3c05a..0000000
--- a/arch/microblaze/include/asm/hardirq.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/hardirq.h>
diff --git a/arch/microblaze/include/asm/ioctl.h b/arch/microblaze/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/microblaze/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/microblaze/include/asm/ioctls.h b/arch/microblaze/include/asm/ioctls.h
deleted file mode 100644
index ec34c76..0000000
--- a/arch/microblaze/include/asm/ioctls.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctls.h>
diff --git a/arch/microblaze/include/asm/irq_regs.h b/arch/microblaze/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/microblaze/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/microblaze/include/asm/kdebug.h b/arch/microblaze/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/microblaze/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/microblaze/include/asm/kmap_types.h b/arch/microblaze/include/asm/kmap_types.h
deleted file mode 100644
index 2597525..0000000
--- a/arch/microblaze/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_MICROBLAZE_KMAP_TYPES_H
-#define _ASM_MICROBLAZE_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif /* _ASM_MICROBLAZE_KMAP_TYPES_H */
diff --git a/arch/microblaze/include/asm/kvm_para.h b/arch/microblaze/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/microblaze/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/microblaze/include/asm/local.h b/arch/microblaze/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/microblaze/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/microblaze/include/asm/local64.h b/arch/microblaze/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/microblaze/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/microblaze/include/asm/mman.h b/arch/microblaze/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/microblaze/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/microblaze/include/asm/msgbuf.h b/arch/microblaze/include/asm/msgbuf.h
deleted file mode 100644
index 809134c..0000000
--- a/arch/microblaze/include/asm/msgbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/msgbuf.h>
diff --git a/arch/microblaze/include/asm/param.h b/arch/microblaze/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/microblaze/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/microblaze/include/asm/parport.h b/arch/microblaze/include/asm/parport.h
deleted file mode 100644
index cf252af..0000000
--- a/arch/microblaze/include/asm/parport.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/parport.h>
diff --git a/arch/microblaze/include/asm/percpu.h b/arch/microblaze/include/asm/percpu.h
deleted file mode 100644
index 06a959d..0000000
--- a/arch/microblaze/include/asm/percpu.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/percpu.h>
diff --git a/arch/microblaze/include/asm/poll.h b/arch/microblaze/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/microblaze/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/microblaze/include/asm/resource.h b/arch/microblaze/include/asm/resource.h
deleted file mode 100644
index 04bc4db..0000000
--- a/arch/microblaze/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/resource.h>
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
deleted file mode 100644
index 35d786f..0000000
--- a/arch/microblaze/include/asm/scatterlist.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/scatterlist.h>
diff --git a/arch/microblaze/include/asm/sembuf.h b/arch/microblaze/include/asm/sembuf.h
deleted file mode 100644
index 7673b83..0000000
--- a/arch/microblaze/include/asm/sembuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sembuf.h>
diff --git a/arch/microblaze/include/asm/serial.h b/arch/microblaze/include/asm/serial.h
deleted file mode 100644
index a0cb0ca..0000000
--- a/arch/microblaze/include/asm/serial.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/serial.h>
diff --git a/arch/microblaze/include/asm/shmbuf.h b/arch/microblaze/include/asm/shmbuf.h
deleted file mode 100644
index 83c05fc..0000000
--- a/arch/microblaze/include/asm/shmbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/shmbuf.h>
diff --git a/arch/microblaze/include/asm/shmparam.h b/arch/microblaze/include/asm/shmparam.h
deleted file mode 100644
index 93f30de..0000000
--- a/arch/microblaze/include/asm/shmparam.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/shmparam.h>
diff --git a/arch/microblaze/include/asm/siginfo.h b/arch/microblaze/include/asm/siginfo.h
deleted file mode 100644
index 0815d29..0000000
--- a/arch/microblaze/include/asm/siginfo.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/siginfo.h>
diff --git a/arch/microblaze/include/asm/signal.h b/arch/microblaze/include/asm/signal.h
deleted file mode 100644
index 7b1573c..0000000
--- a/arch/microblaze/include/asm/signal.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/signal.h>
diff --git a/arch/microblaze/include/asm/socket.h b/arch/microblaze/include/asm/socket.h
deleted file mode 100644
index 6b71384..0000000
--- a/arch/microblaze/include/asm/socket.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/socket.h>
diff --git a/arch/microblaze/include/asm/sockios.h b/arch/microblaze/include/asm/sockios.h
deleted file mode 100644
index def6d47..0000000
--- a/arch/microblaze/include/asm/sockios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sockios.h>
diff --git a/arch/microblaze/include/asm/stat.h b/arch/microblaze/include/asm/stat.h
deleted file mode 100644
index 3dc90fa..0000000
--- a/arch/microblaze/include/asm/stat.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/stat.h>
diff --git a/arch/microblaze/include/asm/statfs.h b/arch/microblaze/include/asm/statfs.h
deleted file mode 100644
index 0b91fe1..0000000
--- a/arch/microblaze/include/asm/statfs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/statfs.h>
diff --git a/arch/microblaze/include/asm/swab.h b/arch/microblaze/include/asm/swab.h
deleted file mode 100644
index 7847e56..0000000
--- a/arch/microblaze/include/asm/swab.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/swab.h>
diff --git a/arch/microblaze/include/asm/termbits.h b/arch/microblaze/include/asm/termbits.h
deleted file mode 100644
index 3935b10..0000000
--- a/arch/microblaze/include/asm/termbits.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termbits.h>
diff --git a/arch/microblaze/include/asm/termios.h b/arch/microblaze/include/asm/termios.h
deleted file mode 100644
index 280d78a..0000000
--- a/arch/microblaze/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termios.h>
diff --git a/arch/microblaze/include/asm/topology.h b/arch/microblaze/include/asm/topology.h
deleted file mode 100644
index 5428f33..0000000
--- a/arch/microblaze/include/asm/topology.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/topology.h>
diff --git a/arch/microblaze/include/asm/types.h b/arch/microblaze/include/asm/types.h
deleted file mode 100644
index b9e79bc..0000000
--- a/arch/microblaze/include/asm/types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/types.h>
diff --git a/arch/microblaze/include/asm/ucontext.h b/arch/microblaze/include/asm/ucontext.h
deleted file mode 100644
index 9bc07b9..0000000
--- a/arch/microblaze/include/asm/ucontext.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ucontext.h>
diff --git a/arch/microblaze/include/asm/vga.h b/arch/microblaze/include/asm/vga.h
deleted file mode 100644
index 89d82fd..0000000
--- a/arch/microblaze/include/asm/vga.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/vga.h>
diff --git a/arch/microblaze/include/asm/xor.h b/arch/microblaze/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/microblaze/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/mips/include/asm/ipcbuf.h b/arch/mips/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/mips/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


