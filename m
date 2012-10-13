Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2JMCd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:33:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2JMC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:57 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xmIl-V1i9JYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=duw1wRX3FsYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=WPyIoOwQAAAA:8 a=8E8v3OysDKnRTnF82tMA:9 a=jEp0ucaQiEUA:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.289710602@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 13/25] mips: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0013-mips-Use-Kbuild-infrastructure-to-handle-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/include/asm/Kbuild              |   14 ++++++++++++++
 arch/mips/include/asm/cputime.h           |    6 ------
 arch/mips/include/asm/current.h           |    1 -
 arch/mips/include/asm/emergency-restart.h |    6 ------
 arch/mips/include/asm/kvm_para.h          |    1 -
 arch/mips/include/asm/local64.h           |    1 -
 arch/mips/include/asm/parport.h           |    1 -
 arch/mips/include/asm/percpu.h            |    6 ------
 arch/mips/include/asm/scatterlist.h       |    6 ------
 arch/mips/include/asm/sections.h          |    6 ------
 arch/mips/include/asm/serial.h            |    1 -
 arch/mips/include/asm/ucontext.h          |    1 -
 arch/mips/include/asm/xor.h               |    1 -
 arch/mn10300/include/asm/ipcbuf.h         |    1 -
 14 files changed, 14 insertions(+), 38 deletions(-)
 delete mode 100644 arch/mips/include/asm/cputime.h
 delete mode 100644 arch/mips/include/asm/current.h
 delete mode 100644 arch/mips/include/asm/emergency-restart.h
 delete mode 100644 arch/mips/include/asm/kvm_para.h
 delete mode 100644 arch/mips/include/asm/local64.h
 delete mode 100644 arch/mips/include/asm/parport.h
 delete mode 100644 arch/mips/include/asm/percpu.h
 delete mode 100644 arch/mips/include/asm/scatterlist.h
 delete mode 100644 arch/mips/include/asm/sections.h
 delete mode 100644 arch/mips/include/asm/serial.h
 delete mode 100644 arch/mips/include/asm/ucontext.h
 delete mode 100644 arch/mips/include/asm/xor.h
 delete mode 100644 arch/mn10300/include/asm/ipcbuf.h

diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index f53f9ca..b5a6509 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -3,3 +3,17 @@ include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
 header-y += sgidefs.h
 header-y += sysmips.h
+
+generic-y += cputime.h
+generic-y += current.h
+generic-y += emergency-restart.h
+generic-y += ipcbuf.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += serial.h
+generic-y += ucontext.h
+generic-y += xor.h
diff --git a/arch/mips/include/asm/cputime.h b/arch/mips/include/asm/cputime.h
deleted file mode 100644
index c00eacb..0000000
--- a/arch/mips/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __MIPS_CPUTIME_H
-#define __MIPS_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __MIPS_CPUTIME_H */
diff --git a/arch/mips/include/asm/current.h b/arch/mips/include/asm/current.h
deleted file mode 100644
index 4c51401..0000000
--- a/arch/mips/include/asm/current.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/current.h>
diff --git a/arch/mips/include/asm/emergency-restart.h b/arch/mips/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/mips/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/mips/include/asm/kvm_para.h b/arch/mips/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/mips/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/mips/include/asm/local64.h b/arch/mips/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/mips/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/mips/include/asm/parport.h b/arch/mips/include/asm/parport.h
deleted file mode 100644
index cf252af..0000000
--- a/arch/mips/include/asm/parport.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/parport.h>
diff --git a/arch/mips/include/asm/percpu.h b/arch/mips/include/asm/percpu.h
deleted file mode 100644
index 844e763..0000000
--- a/arch/mips/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PERCPU_H
-#define __ASM_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif /* __ASM_PERCPU_H */
diff --git a/arch/mips/include/asm/scatterlist.h b/arch/mips/include/asm/scatterlist.h
deleted file mode 100644
index 7ee0e64..0000000
--- a/arch/mips/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_SCATTERLIST_H
-#define __ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* __ASM_SCATTERLIST_H */
diff --git a/arch/mips/include/asm/sections.h b/arch/mips/include/asm/sections.h
deleted file mode 100644
index b7e3726..0000000
--- a/arch/mips/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SECTIONS_H
-#define _ASM_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* _ASM_SECTIONS_H */
diff --git a/arch/mips/include/asm/serial.h b/arch/mips/include/asm/serial.h
deleted file mode 100644
index a0cb0ca..0000000
--- a/arch/mips/include/asm/serial.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/serial.h>
diff --git a/arch/mips/include/asm/ucontext.h b/arch/mips/include/asm/ucontext.h
deleted file mode 100644
index 9bc07b9..0000000
--- a/arch/mips/include/asm/ucontext.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ucontext.h>
diff --git a/arch/mips/include/asm/xor.h b/arch/mips/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/mips/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/mn10300/include/asm/ipcbuf.h b/arch/mn10300/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/mn10300/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


