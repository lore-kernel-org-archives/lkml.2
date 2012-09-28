Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2I1Nnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:43:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48302 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148Ab2I1Nnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:43:41 -0400
Message-ID: <1348839817.2411.19.camel@dabdike.int.hansenpartnership.com>
Subject: Re: parisc: orphaned asm/compat_signal.h file?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 14:43:37 +0100
In-Reply-To: <BLU0-SMTP54F29C73A16BAB0885137A979D0@phx.gbl>
References: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com>
	 <BLU0-SMTP54F29C73A16BAB0885137A979D0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 19:23 -0400, John David Anglin wrote:
> On 24-Sep-12, at 8:39 AM, Denys Vlasenko wrote:
> 
> > Maybe it needs to be removed?
> 
> Worked for me with 3.5.4.

It's probably time to tidy up all of our asm-generic code and use the
proper infrastructure.  I thought of doing it when the word-at-a-time
problem arose, but I forgot about it.

James

---

diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 4383707..7fdde2e 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += pdc.h
-generic-y += word-at-a-time.h
+generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
+	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
+	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
+	  poll.h xor.h
diff --git a/arch/parisc/include/asm/auxvec.h b/arch/parisc/include/asm/auxvec.h
deleted file mode 100644
index 9c3ac4b..0000000
--- a/arch/parisc/include/asm/auxvec.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASMPARISC_AUXVEC_H
-#define __ASMPARISC_AUXVEC_H
-
-#endif
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
diff --git a/arch/parisc/include/asm/hw_irq.h b/arch/parisc/include/asm/hw_irq.h
deleted file mode 100644
index 6707f7d..0000000
--- a/arch/parisc/include/asm/hw_irq.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_HW_IRQ_H
-#define _ASM_HW_IRQ_H
-
-/*
- *	linux/include/asm/hw_irq.h
- */
-
-#endif
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
diff --git a/arch/parisc/include/asm/mutex.h b/arch/parisc/include/asm/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/arch/parisc/include/asm/mutex.h
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
diff --git a/arch/parisc/include/asm/real.h b/arch/parisc/include/asm/real.h
deleted file mode 100644
index 82acb25..0000000
--- a/arch/parisc/include/asm/real.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#ifndef _PARISC_REAL_H
-#define _PARISC_REAL_H
-
-
-#endif
diff --git a/arch/parisc/include/asm/segment.h b/arch/parisc/include/asm/segment.h
deleted file mode 100644
index 26794dd..0000000
--- a/arch/parisc/include/asm/segment.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __PARISC_SEGMENT_H
-#define __PARISC_SEGMENT_H
-
-/* Only here because we have some old header files that expect it.. */
-
-#endif
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
diff --git a/arch/parisc/include/asm/user.h b/arch/parisc/include/asm/user.h
deleted file mode 100644
index 8022475..0000000
--- a/arch/parisc/include/asm/user.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* This file should not exist, but lots of generic code still includes
-   it. It's a hangover from old a.out days and the traditional core
-   dump format.  We are ELF-only, and so are our core dumps.  If we
-   need to support HP/UX core format then we'll do it here
-   eventually. */
diff --git a/arch/parisc/include/asm/vga.h b/arch/parisc/include/asm/vga.h
deleted file mode 100644
index 171399a..0000000
--- a/arch/parisc/include/asm/vga.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PARISC_VGA_H__
-#define __ASM_PARISC_VGA_H__
-
-/* nothing */
-
-#endif /* __ASM_PARISC_VGA_H__ */
diff --git a/arch/parisc/include/asm/xor.h b/arch/parisc/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/parisc/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>


