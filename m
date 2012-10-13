Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2JMCcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:32:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2JMC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:57 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cFtHrUT0qXQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=K1F_eu_i-nMA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=x2GZnTqNAAAA:8 a=krXenIicA7tXVKVNX_cA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022954.440950198@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 14/25] mn10300: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0014-mn10300-Use-Kbuild-infrastructure-to-handle-asm-gene.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-am33-list@redhat.com
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mn10300/include/asm/Kbuild              |   23 +++++++++++++++++++++++
 arch/mn10300/include/asm/bitsperlong.h       |    1 -
 arch/mn10300/include/asm/cputime.h           |    1 -
 arch/mn10300/include/asm/device.h            |    1 -
 arch/mn10300/include/asm/emergency-restart.h |    1 -
 arch/mn10300/include/asm/errno.h             |    1 -
 arch/mn10300/include/asm/fcntl.h             |    1 -
 arch/mn10300/include/asm/futex.h             |    1 -
 arch/mn10300/include/asm/ioctl.h             |    1 -
 arch/mn10300/include/asm/ioctls.h            |    6 ------
 arch/mn10300/include/asm/kmap_types.h        |    6 ------
 arch/mn10300/include/asm/kvm_para.h          |    1 -
 arch/mn10300/include/asm/local.h             |    1 -
 arch/mn10300/include/asm/local64.h           |    1 -
 arch/mn10300/include/asm/percpu.h            |    1 -
 arch/mn10300/include/asm/poll.h              |    1 -
 arch/mn10300/include/asm/resource.h          |    1 -
 arch/mn10300/include/asm/scatterlist.h       |   16 ----------------
 arch/mn10300/include/asm/sections.h          |    1 -
 arch/mn10300/include/asm/siginfo.h           |    1 -
 arch/mn10300/include/asm/statfs.h            |    1 -
 arch/mn10300/include/asm/topology.h          |    1 -
 arch/mn10300/include/asm/xor.h               |    1 -
 arch/x86/include/asm/ipcbuf.h                |    1 -
 24 files changed, 23 insertions(+), 48 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/bitsperlong.h
 delete mode 100644 arch/mn10300/include/asm/cputime.h
 delete mode 100644 arch/mn10300/include/asm/device.h
 delete mode 100644 arch/mn10300/include/asm/emergency-restart.h
 delete mode 100644 arch/mn10300/include/asm/errno.h
 delete mode 100644 arch/mn10300/include/asm/fcntl.h
 delete mode 100644 arch/mn10300/include/asm/futex.h
 delete mode 100644 arch/mn10300/include/asm/ioctl.h
 delete mode 100644 arch/mn10300/include/asm/ioctls.h
 delete mode 100644 arch/mn10300/include/asm/kmap_types.h
 delete mode 100644 arch/mn10300/include/asm/kvm_para.h
 delete mode 100644 arch/mn10300/include/asm/local.h
 delete mode 100644 arch/mn10300/include/asm/local64.h
 delete mode 100644 arch/mn10300/include/asm/percpu.h
 delete mode 100644 arch/mn10300/include/asm/poll.h
 delete mode 100644 arch/mn10300/include/asm/resource.h
 delete mode 100644 arch/mn10300/include/asm/scatterlist.h
 delete mode 100644 arch/mn10300/include/asm/sections.h
 delete mode 100644 arch/mn10300/include/asm/siginfo.h
 delete mode 100644 arch/mn10300/include/asm/statfs.h
 delete mode 100644 arch/mn10300/include/asm/topology.h
 delete mode 100644 arch/mn10300/include/asm/xor.h
 delete mode 100644 arch/x86/include/asm/ipcbuf.h

diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index fccd81e..df065d7 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,4 +1,27 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += bitsperlong.h
+generic-y += cputime.h
 generic-y += clkdev.h
+generic-y += device.h
+generic-y += emergency-restart.h
+generic-y += errno.h
 generic-y += exec.h
+generic-y += fcntl.h
+generic-y += futex.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += statfs.h
+generic-y += topology.h
+generic-y += xor.h
diff --git a/arch/mn10300/include/asm/bitsperlong.h b/arch/mn10300/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/mn10300/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/mn10300/include/asm/cputime.h b/arch/mn10300/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/mn10300/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/mn10300/include/asm/device.h b/arch/mn10300/include/asm/device.h
deleted file mode 100644
index f0a4c25..0000000
--- a/arch/mn10300/include/asm/device.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/device.h>
diff --git a/arch/mn10300/include/asm/emergency-restart.h b/arch/mn10300/include/asm/emergency-restart.h
deleted file mode 100644
index 3711bd9..0000000
--- a/arch/mn10300/include/asm/emergency-restart.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/emergency-restart.h>
diff --git a/arch/mn10300/include/asm/errno.h b/arch/mn10300/include/asm/errno.h
deleted file mode 100644
index 4c82b50..0000000
--- a/arch/mn10300/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/errno.h>
diff --git a/arch/mn10300/include/asm/fcntl.h b/arch/mn10300/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/mn10300/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/mn10300/include/asm/futex.h b/arch/mn10300/include/asm/futex.h
deleted file mode 100644
index 0b74582..0000000
--- a/arch/mn10300/include/asm/futex.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/futex.h>
diff --git a/arch/mn10300/include/asm/ioctl.h b/arch/mn10300/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/mn10300/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/mn10300/include/asm/ioctls.h b/arch/mn10300/include/asm/ioctls.h
deleted file mode 100644
index 0212f4b..0000000
--- a/arch/mn10300/include/asm/ioctls.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_IOCTLS_H
-#define _ASM_IOCTLS_H
-
-#include <asm-generic/ioctls.h>
-
-#endif /* _ASM_IOCTLS_H */
diff --git a/arch/mn10300/include/asm/kmap_types.h b/arch/mn10300/include/asm/kmap_types.h
deleted file mode 100644
index 76d093b..0000000
--- a/arch/mn10300/include/asm/kmap_types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_KMAP_TYPES_H
-#define _ASM_KMAP_TYPES_H
-
-#include <asm-generic/kmap_types.h>
-
-#endif /* _ASM_KMAP_TYPES_H */
diff --git a/arch/mn10300/include/asm/kvm_para.h b/arch/mn10300/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/mn10300/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/mn10300/include/asm/local.h b/arch/mn10300/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/mn10300/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/mn10300/include/asm/local64.h b/arch/mn10300/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/mn10300/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/mn10300/include/asm/percpu.h b/arch/mn10300/include/asm/percpu.h
deleted file mode 100644
index 06a959d..0000000
--- a/arch/mn10300/include/asm/percpu.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/percpu.h>
diff --git a/arch/mn10300/include/asm/poll.h b/arch/mn10300/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/mn10300/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/mn10300/include/asm/resource.h b/arch/mn10300/include/asm/resource.h
deleted file mode 100644
index 04bc4db..0000000
--- a/arch/mn10300/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/resource.h>
diff --git a/arch/mn10300/include/asm/scatterlist.h b/arch/mn10300/include/asm/scatterlist.h
deleted file mode 100644
index 7baa400..0000000
--- a/arch/mn10300/include/asm/scatterlist.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* MN10300 Scatterlist definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASM_SCATTERLIST_H */
diff --git a/arch/mn10300/include/asm/sections.h b/arch/mn10300/include/asm/sections.h
deleted file mode 100644
index 2b8c516..0000000
--- a/arch/mn10300/include/asm/sections.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sections.h>
diff --git a/arch/mn10300/include/asm/siginfo.h b/arch/mn10300/include/asm/siginfo.h
deleted file mode 100644
index 0815d29..0000000
--- a/arch/mn10300/include/asm/siginfo.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/siginfo.h>
diff --git a/arch/mn10300/include/asm/statfs.h b/arch/mn10300/include/asm/statfs.h
deleted file mode 100644
index 0b91fe1..0000000
--- a/arch/mn10300/include/asm/statfs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/statfs.h>
diff --git a/arch/mn10300/include/asm/topology.h b/arch/mn10300/include/asm/topology.h
deleted file mode 100644
index 5428f33..0000000
--- a/arch/mn10300/include/asm/topology.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/topology.h>
diff --git a/arch/mn10300/include/asm/xor.h b/arch/mn10300/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/mn10300/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/x86/include/asm/ipcbuf.h b/arch/x86/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/x86/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


