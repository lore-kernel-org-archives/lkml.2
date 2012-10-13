Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2JMCcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2JMC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:58 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jKV6OTrkUvoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NR86huHr0OYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=ssWaikZrh9QRXiziTLwA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022955.012258301@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 18/25] s390: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0018-s390-Use-Kbuild-infrastructure-to-handle-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux390@de.ibm.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/include/asm/Kbuild              |   17 ++++++++++++++++-
 arch/s390/include/asm/device.h            |    7 -------
 arch/s390/include/asm/div64.h             |    1 -
 arch/s390/include/asm/emergency-restart.h |    6 ------
 arch/s390/include/asm/irq_regs.h          |    1 -
 arch/s390/include/asm/kmap_types.h        |    6 ------
 arch/s390/include/asm/local.h             |    1 -
 arch/s390/include/asm/local64.h           |    1 -
 arch/s390/include/asm/xor.h               |    1 -
 arch/s390/include/uapi/asm/errno.h        |   11 -----------
 arch/s390/include/uapi/asm/fcntl.h        |    1 -
 arch/s390/include/uapi/asm/ioctl.h        |    1 -
 arch/s390/include/uapi/asm/param.h        |    6 ------
 arch/s390/include/uapi/asm/poll.h         |    1 -
 arch/s390/include/uapi/asm/resource.h     |   13 -------------
 arch/s390/include/uapi/asm/sockios.h      |    6 ------
 arch/s390/include/uapi/asm/termbits.h     |    6 ------
 17 files changed, 16 insertions(+), 70 deletions(-)
 delete mode 100644 arch/s390/include/asm/device.h
 delete mode 100644 arch/s390/include/asm/div64.h
 delete mode 100644 arch/s390/include/asm/emergency-restart.h
 delete mode 100644 arch/s390/include/asm/irq_regs.h
 delete mode 100644 arch/s390/include/asm/kmap_types.h
 delete mode 100644 arch/s390/include/asm/local.h
 delete mode 100644 arch/s390/include/asm/local64.h
 delete mode 100644 arch/s390/include/asm/xor.h
 delete mode 100644 arch/s390/include/uapi/asm/errno.h
 delete mode 100644 arch/s390/include/uapi/asm/fcntl.h
 delete mode 100644 arch/s390/include/uapi/asm/ioctl.h
 delete mode 100644 arch/s390/include/uapi/asm/param.h
 delete mode 100644 arch/s390/include/uapi/asm/poll.h
 delete mode 100644 arch/s390/include/uapi/asm/resource.h
 delete mode 100644 arch/s390/include/uapi/asm/sockios.h
 delete mode 100644 arch/s390/include/uapi/asm/termbits.h

diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 0633dc6..2e52285 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,3 +1,18 @@
 
-
 generic-y += clkdev.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += irq_regs.h
+generic-y += kmap_types.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += param.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += sockios.h
+generic-y += termbits.h
+generic-y += xor.h
diff --git a/arch/s390/include/asm/device.h b/arch/s390/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/s390/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/s390/include/asm/div64.h b/arch/s390/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/s390/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/s390/include/asm/emergency-restart.h b/arch/s390/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/s390/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/s390/include/asm/irq_regs.h b/arch/s390/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/s390/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/s390/include/asm/kmap_types.h b/arch/s390/include/asm/kmap_types.h
deleted file mode 100644
index 0a88622..0000000
--- a/arch/s390/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_KMAP_TYPES_H
-#define _ASM_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif
diff --git a/arch/s390/include/asm/local.h b/arch/s390/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/s390/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/s390/include/asm/local64.h b/arch/s390/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/s390/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/s390/include/asm/xor.h b/arch/s390/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/s390/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/s390/include/uapi/asm/errno.h b/arch/s390/include/uapi/asm/errno.h
deleted file mode 100644
index 395e97d..0000000
--- a/arch/s390/include/uapi/asm/errno.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/*
- *  S390 version
- *
- */
-
-#ifndef _S390_ERRNO_H
-#define _S390_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/arch/s390/include/uapi/asm/fcntl.h b/arch/s390/include/uapi/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/s390/include/uapi/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/s390/include/uapi/asm/ioctl.h b/arch/s390/include/uapi/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/s390/include/uapi/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/s390/include/uapi/asm/param.h b/arch/s390/include/uapi/asm/param.h
deleted file mode 100644
index c616821..0000000
--- a/arch/s390/include/uapi/asm/param.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASMS390_PARAM_H
-#define _ASMS390_PARAM_H
-
-#include <asm-generic/param.h>
-
-#endif /* _ASMS390_PARAM_H */
diff --git a/arch/s390/include/uapi/asm/poll.h b/arch/s390/include/uapi/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/s390/include/uapi/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/s390/include/uapi/asm/resource.h b/arch/s390/include/uapi/asm/resource.h
deleted file mode 100644
index ec23d1c..0000000
--- a/arch/s390/include/uapi/asm/resource.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- *  S390 version
- *
- *  Derived from "include/asm-i386/resources.h"
- */
-
-#ifndef _S390_RESOURCE_H
-#define _S390_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
-
diff --git a/arch/s390/include/uapi/asm/sockios.h b/arch/s390/include/uapi/asm/sockios.h
deleted file mode 100644
index 6f60eee..0000000
--- a/arch/s390/include/uapi/asm/sockios.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_S390_SOCKIOS_H
-#define _ASM_S390_SOCKIOS_H
-
-#include <asm-generic/sockios.h>
-
-#endif
diff --git a/arch/s390/include/uapi/asm/termbits.h b/arch/s390/include/uapi/asm/termbits.h
deleted file mode 100644
index 71bf6ac..0000000
--- a/arch/s390/include/uapi/asm/termbits.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_S390_TERMBITS_H
-#define _ASM_S390_TERMBITS_H
-
-#include <asm-generic/termbits.h>
-
-#endif
-- 
1.7.10.4


