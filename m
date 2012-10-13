Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2JMCco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2JMC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:57 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SdzO0FUB-SEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xKM2JtUpy8kA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=voM4FWlXAAAA:8 a=wMNdZWldAAAA:8 a=hGzw-44bAAAA:8 a=FTlw61NjaoMqhvZeE-wA:9 a=jEp0ucaQiEUA:10 a=dowx1zmaLagA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.861437159@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 17/25] powerpc: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0017-powerpc-Use-Kbuild-infrastructure-to-handle-asm-gene.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/Kbuild              |    9 +++++++++
 arch/powerpc/include/asm/div64.h             |    1 -
 arch/powerpc/include/asm/emergency-restart.h |    1 -
 arch/powerpc/include/asm/irq_regs.h          |    2 --
 arch/powerpc/include/asm/local64.h           |    1 -
 arch/powerpc/include/asm/param.h             |    1 -
 arch/powerpc/include/asm/poll.h              |    1 -
 arch/powerpc/include/asm/resource.h          |    1 -
 arch/powerpc/include/asm/statfs.h            |    6 ------
 arch/powerpc/include/asm/xor.h               |    1 -
 10 files changed, 9 insertions(+), 15 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/div64.h
 delete mode 100644 arch/powerpc/include/asm/emergency-restart.h
 delete mode 100644 arch/powerpc/include/asm/irq_regs.h
 delete mode 100644 arch/powerpc/include/asm/local64.h
 delete mode 100644 arch/powerpc/include/asm/param.h
 delete mode 100644 arch/powerpc/include/asm/poll.h
 delete mode 100644 arch/powerpc/include/asm/resource.h
 delete mode 100644 arch/powerpc/include/asm/statfs.h
 delete mode 100644 arch/powerpc/include/asm/xor.h

diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index ace53db..8ae0511 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -36,4 +36,13 @@ header-y += ucontext.h
 header-y += unistd.h
 
 generic-y += clkdev.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += irq_regs.h
+generic-y += local64.h
+generic-y += param.h
+generic-y += poll.h
+generic-y += resource.h
 generic-y += rwsem.h
+generic-y += statfs.h
+generic-y += xor.h
diff --git a/arch/powerpc/include/asm/div64.h b/arch/powerpc/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/powerpc/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/powerpc/include/asm/emergency-restart.h b/arch/powerpc/include/asm/emergency-restart.h
deleted file mode 100644
index 3711bd9..0000000
--- a/arch/powerpc/include/asm/emergency-restart.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/emergency-restart.h>
diff --git a/arch/powerpc/include/asm/irq_regs.h b/arch/powerpc/include/asm/irq_regs.h
deleted file mode 100644
index ba94b51..0000000
--- a/arch/powerpc/include/asm/irq_regs.h
+++ /dev/null
@@ -1,2 +0,0 @@
-#include <asm-generic/irq_regs.h>
-
diff --git a/arch/powerpc/include/asm/local64.h b/arch/powerpc/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/powerpc/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/powerpc/include/asm/param.h b/arch/powerpc/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/powerpc/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/powerpc/include/asm/poll.h b/arch/powerpc/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/powerpc/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/powerpc/include/asm/resource.h b/arch/powerpc/include/asm/resource.h
deleted file mode 100644
index 04bc4db..0000000
--- a/arch/powerpc/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/resource.h>
diff --git a/arch/powerpc/include/asm/statfs.h b/arch/powerpc/include/asm/statfs.h
deleted file mode 100644
index 5244834..0000000
--- a/arch/powerpc/include/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_POWERPC_STATFS_H
-#define _ASM_POWERPC_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif
diff --git a/arch/powerpc/include/asm/xor.h b/arch/powerpc/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/powerpc/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
-- 
1.7.10.4


