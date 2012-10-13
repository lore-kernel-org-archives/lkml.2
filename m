Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2JMCaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:30:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2JMCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:30:00 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mnsAqlKKE2cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6dnQEJPOWUUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=oGMlB6cnAAAA:8 a=56RlJAwOAM7nuK1V3R4A:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022955.876351998@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 24/25] x86: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0024-x86-Use-Kbuild-infrastructure-to-handle-asm-generic-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/Kbuild     |   18 ++++++++++++++++++
 arch/x86/include/asm/cputime.h  |    1 -
 arch/x86/include/asm/errno.h    |    1 -
 arch/x86/include/asm/fcntl.h    |    1 -
 arch/x86/include/asm/ioctl.h    |    1 -
 arch/x86/include/asm/ioctls.h   |    1 -
 arch/x86/include/asm/local64.h  |    1 -
 arch/x86/include/asm/msgbuf.h   |    1 -
 arch/x86/include/asm/param.h    |    1 -
 arch/x86/include/asm/poll.h     |    1 -
 arch/x86/include/asm/resource.h |    1 -
 arch/x86/include/asm/rtc.h      |    1 -
 arch/x86/include/asm/shmbuf.h   |    1 -
 arch/x86/include/asm/socket.h   |    1 -
 arch/x86/include/asm/sockios.h  |    1 -
 arch/x86/include/asm/termbits.h |    1 -
 arch/x86/include/asm/termios.h  |    1 -
 arch/x86/include/asm/types.h    |    6 ------
 18 files changed, 18 insertions(+), 22 deletions(-)
 delete mode 100644 arch/x86/include/asm/cputime.h
 delete mode 100644 arch/x86/include/asm/errno.h
 delete mode 100644 arch/x86/include/asm/fcntl.h
 delete mode 100644 arch/x86/include/asm/ioctl.h
 delete mode 100644 arch/x86/include/asm/ioctls.h
 delete mode 100644 arch/x86/include/asm/local64.h
 delete mode 100644 arch/x86/include/asm/msgbuf.h
 delete mode 100644 arch/x86/include/asm/param.h
 delete mode 100644 arch/x86/include/asm/poll.h
 delete mode 100644 arch/x86/include/asm/resource.h
 delete mode 100644 arch/x86/include/asm/rtc.h
 delete mode 100644 arch/x86/include/asm/shmbuf.h
 delete mode 100644 arch/x86/include/asm/socket.h
 delete mode 100644 arch/x86/include/asm/sockios.h
 delete mode 100644 arch/x86/include/asm/termbits.h
 delete mode 100644 arch/x86/include/asm/termios.h
 delete mode 100644 arch/x86/include/asm/types.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 66e5f0e..eb28799 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -27,4 +27,22 @@ genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += local64.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += rtc.h
+generic-y += shmbuf.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += types.h
diff --git a/arch/x86/include/asm/cputime.h b/arch/x86/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/x86/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/x86/include/asm/errno.h b/arch/x86/include/asm/errno.h
deleted file mode 100644
index 4c82b50..0000000
--- a/arch/x86/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/errno.h>
diff --git a/arch/x86/include/asm/fcntl.h b/arch/x86/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/x86/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/x86/include/asm/ioctl.h b/arch/x86/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/x86/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/x86/include/asm/ioctls.h b/arch/x86/include/asm/ioctls.h
deleted file mode 100644
index ec34c76..0000000
--- a/arch/x86/include/asm/ioctls.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctls.h>
diff --git a/arch/x86/include/asm/local64.h b/arch/x86/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/x86/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/x86/include/asm/msgbuf.h b/arch/x86/include/asm/msgbuf.h
deleted file mode 100644
index 809134c..0000000
--- a/arch/x86/include/asm/msgbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/msgbuf.h>
diff --git a/arch/x86/include/asm/param.h b/arch/x86/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/x86/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/x86/include/asm/poll.h b/arch/x86/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/x86/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/x86/include/asm/resource.h b/arch/x86/include/asm/resource.h
deleted file mode 100644
index 04bc4db..0000000
--- a/arch/x86/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/resource.h>
diff --git a/arch/x86/include/asm/rtc.h b/arch/x86/include/asm/rtc.h
deleted file mode 100644
index f71c3b0..0000000
--- a/arch/x86/include/asm/rtc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/rtc.h>
diff --git a/arch/x86/include/asm/shmbuf.h b/arch/x86/include/asm/shmbuf.h
deleted file mode 100644
index 83c05fc..0000000
--- a/arch/x86/include/asm/shmbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/shmbuf.h>
diff --git a/arch/x86/include/asm/socket.h b/arch/x86/include/asm/socket.h
deleted file mode 100644
index 6b71384..0000000
--- a/arch/x86/include/asm/socket.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/socket.h>
diff --git a/arch/x86/include/asm/sockios.h b/arch/x86/include/asm/sockios.h
deleted file mode 100644
index def6d47..0000000
--- a/arch/x86/include/asm/sockios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sockios.h>
diff --git a/arch/x86/include/asm/termbits.h b/arch/x86/include/asm/termbits.h
deleted file mode 100644
index 3935b10..0000000
--- a/arch/x86/include/asm/termbits.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termbits.h>
diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
deleted file mode 100644
index 280d78a..0000000
--- a/arch/x86/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termios.h>
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
deleted file mode 100644
index 8e8c23f..0000000
--- a/arch/x86/include/asm/types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_X86_TYPES_H
-#define _ASM_X86_TYPES_H
-
-#include <asm-generic/types.h>
-
-#endif /* _ASM_X86_TYPES_H */
-- 
1.7.10.4


