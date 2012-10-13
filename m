Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2JMCf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:35:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2JMC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:54 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6ZbaGTdDOoAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EBtgh3b89u8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Qf6hv5U293OFthkhEQMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022953.436816116@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 07/25] frv: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0007-frv-Use-Kbuild-infrastructure-to-handle-asm-generic-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/frv/include/asm/Kbuild              |   19 +++++++++++++++++++
 arch/frv/include/asm/bitsperlong.h       |    1 -
 arch/frv/include/asm/cputime.h           |    6 ------
 arch/frv/include/asm/device.h            |    7 -------
 arch/frv/include/asm/div64.h             |    1 -
 arch/frv/include/asm/emergency-restart.h |    6 ------
 arch/frv/include/asm/errno.h             |    7 -------
 arch/frv/include/asm/fcntl.h             |    1 -
 arch/frv/include/asm/ioctl.h             |    1 -
 arch/frv/include/asm/kdebug.h            |    1 -
 arch/frv/include/asm/kvm_para.h          |    1 -
 arch/frv/include/asm/local.h             |    6 ------
 arch/frv/include/asm/local64.h           |    1 -
 arch/frv/include/asm/mman.h              |    1 -
 arch/frv/include/asm/percpu.h            |    6 ------
 arch/frv/include/asm/resource.h          |    7 -------
 arch/frv/include/asm/scatterlist.h       |    6 ------
 arch/frv/include/asm/statfs.h            |    7 -------
 arch/frv/include/asm/xor.h               |    1 -
 arch/h8300/include/asm/ipcbuf.h          |    1 -
 20 files changed, 19 insertions(+), 68 deletions(-)
 delete mode 100644 arch/frv/include/asm/bitsperlong.h
 delete mode 100644 arch/frv/include/asm/cputime.h
 delete mode 100644 arch/frv/include/asm/device.h
 delete mode 100644 arch/frv/include/asm/div64.h
 delete mode 100644 arch/frv/include/asm/emergency-restart.h
 delete mode 100644 arch/frv/include/asm/errno.h
 delete mode 100644 arch/frv/include/asm/fcntl.h
 delete mode 100644 arch/frv/include/asm/ioctl.h
 delete mode 100644 arch/frv/include/asm/kdebug.h
 delete mode 100644 arch/frv/include/asm/kvm_para.h
 delete mode 100644 arch/frv/include/asm/local.h
 delete mode 100644 arch/frv/include/asm/local64.h
 delete mode 100644 arch/frv/include/asm/mman.h
 delete mode 100644 arch/frv/include/asm/percpu.h
 delete mode 100644 arch/frv/include/asm/resource.h
 delete mode 100644 arch/frv/include/asm/scatterlist.h
 delete mode 100644 arch/frv/include/asm/statfs.h
 delete mode 100644 arch/frv/include/asm/xor.h
 delete mode 100644 arch/h8300/include/asm/ipcbuf.h

diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 251bd71..1e46bc5 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,5 +2,24 @@ include include/asm-generic/Kbuild.asm
 
 header-y += registers.h
 header-y += termios.h
+generic-y += bitsperlong.h
 generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += ipcbuf.h
+generic-y += kdebug.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += percpu.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += statfs.h
+generic-y += xor.h
diff --git a/arch/frv/include/asm/bitsperlong.h b/arch/frv/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/frv/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/frv/include/asm/cputime.h b/arch/frv/include/asm/cputime.h
deleted file mode 100644
index f6c373a..0000000
--- a/arch/frv/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUTIME_H
-#define _ASM_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_CPUTIME_H */
diff --git a/arch/frv/include/asm/device.h b/arch/frv/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/frv/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/frv/include/asm/div64.h b/arch/frv/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/frv/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/frv/include/asm/emergency-restart.h b/arch/frv/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/frv/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/frv/include/asm/errno.h b/arch/frv/include/asm/errno.h
deleted file mode 100644
index d010795..0000000
--- a/arch/frv/include/asm/errno.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_ERRNO_H
-#define _ASM_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _ASM_ERRNO_H */
-
diff --git a/arch/frv/include/asm/fcntl.h b/arch/frv/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/frv/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/frv/include/asm/ioctl.h b/arch/frv/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/frv/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/frv/include/asm/kdebug.h b/arch/frv/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/frv/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/frv/include/asm/kvm_para.h b/arch/frv/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/frv/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/frv/include/asm/local.h b/arch/frv/include/asm/local.h
deleted file mode 100644
index c27bdf0..0000000
--- a/arch/frv/include/asm/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_LOCAL_H
-#define _ASM_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_LOCAL_H */
diff --git a/arch/frv/include/asm/local64.h b/arch/frv/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/frv/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/frv/include/asm/mman.h b/arch/frv/include/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/frv/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/frv/include/asm/percpu.h b/arch/frv/include/asm/percpu.h
deleted file mode 100644
index 2cad3f8..0000000
--- a/arch/frv/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PERCPU_H
-#define __ASM_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif	/* __ASM_PERCPU_H */
diff --git a/arch/frv/include/asm/resource.h b/arch/frv/include/asm/resource.h
deleted file mode 100644
index 5fc6054..0000000
--- a/arch/frv/include/asm/resource.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_RESOURCE_H
-#define _ASM_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* _ASM_RESOURCE_H */
-
diff --git a/arch/frv/include/asm/scatterlist.h b/arch/frv/include/asm/scatterlist.h
deleted file mode 100644
index 0e5eb30..0000000
--- a/arch/frv/include/asm/scatterlist.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* !_ASM_SCATTERLIST_H */
diff --git a/arch/frv/include/asm/statfs.h b/arch/frv/include/asm/statfs.h
deleted file mode 100644
index 741f586..0000000
--- a/arch/frv/include/asm/statfs.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_STATFS_H
-#define _ASM_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* _ASM_STATFS_H */
-
diff --git a/arch/frv/include/asm/xor.h b/arch/frv/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/frv/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/h8300/include/asm/ipcbuf.h b/arch/h8300/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/h8300/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


