Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2JMCfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:35:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2JMC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:55 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3rYvbv1zdbIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WhSYsHB3ddwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=rWkr9Ua9AAAA:8 a=tOO0nKmCAAAA:8 a=pGLkceISAAAA:8 a=elk7Z4CtRfxZ2S1txgsA:9 a=jEp0ucaQiEUA:10 a=xGgb05WdMJwA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022952.563646981@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 01/25] alpha: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0001-alpha-Use-Kbuild-infrastructure-to-handle-asm-generi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/alpha/include/asm/Kbuild              |   12 ++++++++++++
 arch/alpha/include/asm/cputime.h           |    6 ------
 arch/alpha/include/asm/device.h            |    7 -------
 arch/alpha/include/asm/div64.h             |    1 -
 arch/alpha/include/asm/emergency-restart.h |    6 ------
 arch/alpha/include/asm/ipcbuf.h            |    1 -
 arch/alpha/include/asm/irq_regs.h          |    1 -
 arch/alpha/include/asm/kdebug.h            |    1 -
 arch/alpha/include/asm/kvm_para.h          |    1 -
 arch/alpha/include/asm/local64.h           |    1 -
 arch/alpha/include/asm/poll.h              |    1 -
 arch/alpha/include/asm/scatterlist.h       |    6 ------
 arch/alpha/include/asm/sections.h          |    7 -------
 13 files changed, 12 insertions(+), 39 deletions(-)
 delete mode 100644 arch/alpha/include/asm/cputime.h
 delete mode 100644 arch/alpha/include/asm/device.h
 delete mode 100644 arch/alpha/include/asm/div64.h
 delete mode 100644 arch/alpha/include/asm/emergency-restart.h
 delete mode 100644 arch/alpha/include/asm/ipcbuf.h
 delete mode 100644 arch/alpha/include/asm/irq_regs.h
 delete mode 100644 arch/alpha/include/asm/kdebug.h
 delete mode 100644 arch/alpha/include/asm/kvm_para.h
 delete mode 100644 arch/alpha/include/asm/local64.h
 delete mode 100644 arch/alpha/include/asm/poll.h
 delete mode 100644 arch/alpha/include/asm/scatterlist.h
 delete mode 100644 arch/alpha/include/asm/sections.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 64ffc9e..2bd12d6 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -10,4 +10,16 @@ header-y += pal.h
 header-y += reg.h
 header-y += regdef.h
 header-y += sysinfo.h
+generic-y += cputime.h
 generic-y += exec.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += poll.h
+generic-y += scatterlist.h
+generic-y += sections.h
diff --git a/arch/alpha/include/asm/cputime.h b/arch/alpha/include/asm/cputime.h
deleted file mode 100644
index 19577fd..0000000
--- a/arch/alpha/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ALPHA_CPUTIME_H
-#define __ALPHA_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __ALPHA_CPUTIME_H */
diff --git a/arch/alpha/include/asm/device.h b/arch/alpha/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/alpha/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/alpha/include/asm/div64.h b/arch/alpha/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/alpha/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/alpha/include/asm/emergency-restart.h b/arch/alpha/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/alpha/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/alpha/include/asm/ipcbuf.h b/arch/alpha/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/alpha/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/alpha/include/asm/irq_regs.h b/arch/alpha/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/alpha/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/alpha/include/asm/kdebug.h b/arch/alpha/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/alpha/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/alpha/include/asm/kvm_para.h b/arch/alpha/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/alpha/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/alpha/include/asm/local64.h b/arch/alpha/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/alpha/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/alpha/include/asm/poll.h b/arch/alpha/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/alpha/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/alpha/include/asm/scatterlist.h b/arch/alpha/include/asm/scatterlist.h
deleted file mode 100644
index 017d747..0000000
--- a/arch/alpha/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ALPHA_SCATTERLIST_H
-#define _ALPHA_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !(_ALPHA_SCATTERLIST_H) */
diff --git a/arch/alpha/include/asm/sections.h b/arch/alpha/include/asm/sections.h
deleted file mode 100644
index 43b40ed..0000000
--- a/arch/alpha/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ALPHA_SECTIONS_H
-#define _ALPHA_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
-- 
1.7.10.4


