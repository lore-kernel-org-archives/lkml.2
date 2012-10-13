Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2JMCeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:34:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2JMC34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:56 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=F67TvOeN6akA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WI9_TAJlJ1wA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=_A5TAQVKAAAA:8 a=ssWaikZrh9QRXiziTLwA:9 a=jEp0ucaQiEUA:10 a=t__e_55n4pAA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.722147403@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 16/25] parisc: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0016-parisc-Use-Kbuild-infrastructure-to-handle-asm-gener.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/include/asm/Kbuild              |   18 +++++++++++++++++-
 arch/parisc/include/asm/compat_signal.h     |    2 --
 arch/parisc/include/asm/cputime.h           |    6 ------
 arch/parisc/include/asm/device.h            |    7 -------
 arch/parisc/include/asm/div64.h             |    1 -
 arch/parisc/include/asm/emergency-restart.h |    6 ------
 arch/parisc/include/asm/hardirq.h           |   11 -----------
 arch/parisc/include/asm/irq_regs.h          |    1 -
 arch/parisc/include/asm/kdebug.h            |    1 -
 arch/parisc/include/asm/kvm_para.h          |    1 -
 arch/parisc/include/asm/local.h             |    1 -
 arch/parisc/include/asm/local64.h           |    1 -
 arch/parisc/include/asm/param.h             |    1 -
 arch/parisc/include/asm/percpu.h            |    7 -------
 arch/parisc/include/asm/poll.h              |    1 -
 arch/parisc/include/asm/topology.h          |    6 ------
 arch/parisc/include/asm/xor.h               |    1 -
 17 files changed, 17 insertions(+), 55 deletions(-)
 delete mode 100644 arch/parisc/include/asm/compat_signal.h
 delete mode 100644 arch/parisc/include/asm/cputime.h
 delete mode 100644 arch/parisc/include/asm/device.h
 delete mode 100644 arch/parisc/include/asm/div64.h
 delete mode 100644 arch/parisc/include/asm/emergency-restart.h
 delete mode 100644 arch/parisc/include/asm/hardirq.h
 delete mode 100644 arch/parisc/include/asm/irq_regs.h
 delete mode 100644 arch/parisc/include/asm/kdebug.h
 delete mode 100644 arch/parisc/include/asm/kvm_para.h
 delete mode 100644 arch/parisc/include/asm/local.h
 delete mode 100644 arch/parisc/include/asm/local64.h
 delete mode 100644 arch/parisc/include/asm/param.h
 delete mode 100644 arch/parisc/include/asm/percpu.h
 delete mode 100644 arch/parisc/include/asm/poll.h
 delete mode 100644 arch/parisc/include/asm/topology.h
 delete mode 100644 arch/parisc/include/asm/xor.h

diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 458371a..6ee772d 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,6 +1,22 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += pdc.h
+generic-y += compat_signal.h
+generic-y += cputime.h
 generic-y += clkdev.h
-generic-y += word-at-a-time.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
 generic-y += exec.h
+generic-y += hardirq.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += param.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += topology.h
+generic-y += word-at-a-time.h
+generic-y += xor.h
diff --git a/arch/parisc/include/asm/compat_signal.h b/arch/parisc/include/asm/compat_signal.h
deleted file mode 100644
index 6ad02c3..0000000
--- a/arch/parisc/include/asm/compat_signal.h
+++ /dev/null
@@ -1,2 +0,0 @@
-/* Use generic */
-#include <asm-generic/compat_signal.h>
diff --git a/arch/parisc/include/asm/cputime.h b/arch/parisc/include/asm/cputime.h
deleted file mode 100644
index dcdf2fb..0000000
--- a/arch/parisc/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __PARISC_CPUTIME_H
-#define __PARISC_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __PARISC_CPUTIME_H */
diff --git a/arch/parisc/include/asm/device.h b/arch/parisc/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/parisc/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/parisc/include/asm/div64.h b/arch/parisc/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/parisc/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/parisc/include/asm/emergency-restart.h b/arch/parisc/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/parisc/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/parisc/include/asm/hardirq.h b/arch/parisc/include/asm/hardirq.h
deleted file mode 100644
index 0d68184..0000000
--- a/arch/parisc/include/asm/hardirq.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* hardirq.h: PA-RISC hard IRQ support.
- *
- * Copyright (C) 2001 Matthew Wilcox <matthew@wil.cx>
- */
-
-#ifndef _PARISC_HARDIRQ_H
-#define _PARISC_HARDIRQ_H
-
-#include <asm-generic/hardirq.h>
-
-#endif /* _PARISC_HARDIRQ_H */
diff --git a/arch/parisc/include/asm/irq_regs.h b/arch/parisc/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/parisc/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/parisc/include/asm/kdebug.h b/arch/parisc/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/parisc/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/parisc/include/asm/kvm_para.h b/arch/parisc/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/parisc/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/parisc/include/asm/local.h b/arch/parisc/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/parisc/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/parisc/include/asm/local64.h b/arch/parisc/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/parisc/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/parisc/include/asm/param.h b/arch/parisc/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/parisc/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/parisc/include/asm/percpu.h b/arch/parisc/include/asm/percpu.h
deleted file mode 100644
index a0dcd19..0000000
--- a/arch/parisc/include/asm/percpu.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _PARISC_PERCPU_H
-#define _PARISC_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif 
-
diff --git a/arch/parisc/include/asm/poll.h b/arch/parisc/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/parisc/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/parisc/include/asm/topology.h b/arch/parisc/include/asm/topology.h
deleted file mode 100644
index d8133eb..0000000
--- a/arch/parisc/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_PARISC_TOPOLOGY_H
-#define _ASM_PARISC_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_PARISC_TOPOLOGY_H */
diff --git a/arch/parisc/include/asm/xor.h b/arch/parisc/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/parisc/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
-- 
1.7.10.4


