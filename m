Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2J0R5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:57:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363Ab2J0R5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:57:34 -0400
From: Alexander Graf <agraf@suse.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Timur Tabi <B04825@freescale.com>, kvm-ppc <kvm-ppc@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH] PPC: ePAPR: Convert header to uapi
Date: Sat, 27 Oct 2012 19:57:26 +0200
Message-Id: <1351360646-19112-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new uapi framework splits kernel internal and user space exported
bits of header files more cleanly. Adjust the ePAPR header accordingly.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 arch/powerpc/include/asm/Kbuild              |    1 -
 arch/powerpc/include/asm/epapr_hcalls.h      |   56 +--------------
 arch/powerpc/include/uapi/asm/Kbuild         |    1 +
 arch/powerpc/include/uapi/asm/epapr_hcalls.h |   98 ++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 56 deletions(-)
 create mode 100644 arch/powerpc/include/uapi/asm/epapr_hcalls.h

diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 13d6b7b..7e313f1 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -34,6 +34,5 @@ header-y += termios.h
 header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h
-header-y += epapr_hcalls.h
 
 generic-y += rwsem.h
diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include/asm/epapr_hcalls.h
index b8d9445..22defe7 100644
--- a/arch/powerpc/include/asm/epapr_hcalls.h
+++ b/arch/powerpc/include/asm/epapr_hcalls.h
@@ -50,65 +50,11 @@
 #ifndef _EPAPR_HCALLS_H
 #define _EPAPR_HCALLS_H
 
-#define EV_BYTE_CHANNEL_SEND		1
-#define EV_BYTE_CHANNEL_RECEIVE		2
-#define EV_BYTE_CHANNEL_POLL		3
-#define EV_INT_SET_CONFIG		4
-#define EV_INT_GET_CONFIG		5
-#define EV_INT_SET_MASK			6
-#define EV_INT_GET_MASK			7
-#define EV_INT_IACK			9
-#define EV_INT_EOI			10
-#define EV_INT_SEND_IPI			11
-#define EV_INT_SET_TASK_PRIORITY	12
-#define EV_INT_GET_TASK_PRIORITY	13
-#define EV_DOORBELL_SEND		14
-#define EV_MSGSND			15
-#define EV_IDLE				16
-
-/* vendor ID: epapr */
-#define EV_LOCAL_VENDOR_ID		0	/* for private use */
-#define EV_EPAPR_VENDOR_ID		1
-#define EV_FSL_VENDOR_ID		2	/* Freescale Semiconductor */
-#define EV_IBM_VENDOR_ID		3	/* IBM */
-#define EV_GHS_VENDOR_ID		4	/* Green Hills Software */
-#define EV_ENEA_VENDOR_ID		5	/* Enea */
-#define EV_WR_VENDOR_ID			6	/* Wind River Systems */
-#define EV_AMCC_VENDOR_ID		7	/* Applied Micro Circuits */
-#define EV_KVM_VENDOR_ID		42	/* KVM */
-
-/* The max number of bytes that a byte channel can send or receive per call */
-#define EV_BYTE_CHANNEL_MAX_BYTES	16
-
-
-#define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
-#define EV_HCALL_TOKEN(hcall_num) _EV_HCALL_TOKEN(EV_EPAPR_VENDOR_ID, hcall_num)
-
-/* epapr return codes */
-#define EV_SUCCESS		0
-#define EV_EPERM		1	/* Operation not permitted */
-#define EV_ENOENT		2	/*  Entry Not Found */
-#define EV_EIO			3	/* I/O error occured */
-#define EV_EAGAIN		4	/* The operation had insufficient
-					 * resources to complete and should be
-					 * retried
-					 */
-#define EV_ENOMEM		5	/* There was insufficient memory to
-					 * complete the operation */
-#define EV_EFAULT		6	/* Bad guest address */
-#define EV_ENODEV		7	/* No such device */
-#define EV_EINVAL		8	/* An argument supplied to the hcall
-					   was out of range or invalid */
-#define EV_INTERNAL		9	/* An internal error occured */
-#define EV_CONFIG		10	/* A configuration error was detected */
-#define EV_INVALID_STATE	11	/* The object is in an invalid state */
-#define EV_UNIMPLEMENTED	12	/* Unimplemented hypercall */
-#define EV_BUFFER_OVERFLOW	13	/* Caller-supplied buffer too small */
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <asm/byteorder.h>
+#include <uapi/asm/epapr_hcalls.h>
 
 /*
  * Hypercall register clobber list
diff --git a/arch/powerpc/include/uapi/asm/Kbuild b/arch/powerpc/include/uapi/asm/Kbuild
index baebb3d..e6b5be8 100644
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -1,3 +1,4 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+header-y += epapr_hcalls.h
diff --git a/arch/powerpc/include/uapi/asm/epapr_hcalls.h b/arch/powerpc/include/uapi/asm/epapr_hcalls.h
new file mode 100644
index 0000000..046c793
--- /dev/null
+++ b/arch/powerpc/include/uapi/asm/epapr_hcalls.h
@@ -0,0 +1,98 @@
+/*
+ * ePAPR hcall interface
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ *
+ * Author: Timur Tabi <timur@freescale.com>
+ *
+ * This file is provided under a dual BSD/GPL license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _UAPI__EPAPR_HCALLS_H
+#define _UAPI__EPAPR_HCALLS_H
+
+#define EV_BYTE_CHANNEL_SEND		1
+#define EV_BYTE_CHANNEL_RECEIVE		2
+#define EV_BYTE_CHANNEL_POLL		3
+#define EV_INT_SET_CONFIG		4
+#define EV_INT_GET_CONFIG		5
+#define EV_INT_SET_MASK			6
+#define EV_INT_GET_MASK			7
+#define EV_INT_IACK			9
+#define EV_INT_EOI			10
+#define EV_INT_SEND_IPI			11
+#define EV_INT_SET_TASK_PRIORITY	12
+#define EV_INT_GET_TASK_PRIORITY	13
+#define EV_DOORBELL_SEND		14
+#define EV_MSGSND			15
+#define EV_IDLE				16
+
+/* vendor ID: epapr */
+#define EV_LOCAL_VENDOR_ID		0	/* for private use */
+#define EV_EPAPR_VENDOR_ID		1
+#define EV_FSL_VENDOR_ID		2	/* Freescale Semiconductor */
+#define EV_IBM_VENDOR_ID		3	/* IBM */
+#define EV_GHS_VENDOR_ID		4	/* Green Hills Software */
+#define EV_ENEA_VENDOR_ID		5	/* Enea */
+#define EV_WR_VENDOR_ID			6	/* Wind River Systems */
+#define EV_AMCC_VENDOR_ID		7	/* Applied Micro Circuits */
+#define EV_KVM_VENDOR_ID		42	/* KVM */
+
+/* The max number of bytes that a byte channel can send or receive per call */
+#define EV_BYTE_CHANNEL_MAX_BYTES	16
+
+
+#define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
+#define EV_HCALL_TOKEN(hcall_num) _EV_HCALL_TOKEN(EV_EPAPR_VENDOR_ID, hcall_num)
+
+/* epapr return codes */
+#define EV_SUCCESS		0
+#define EV_EPERM		1	/* Operation not permitted */
+#define EV_ENOENT		2	/*  Entry Not Found */
+#define EV_EIO			3	/* I/O error occured */
+#define EV_EAGAIN		4	/* The operation had insufficient
+					 * resources to complete and should be
+					 * retried
+					 */
+#define EV_ENOMEM		5	/* There was insufficient memory to
+					 * complete the operation */
+#define EV_EFAULT		6	/* Bad guest address */
+#define EV_ENODEV		7	/* No such device */
+#define EV_EINVAL		8	/* An argument supplied to the hcall
+					   was out of range or invalid */
+#define EV_INTERNAL		9	/* An internal error occured */
+#define EV_CONFIG		10	/* A configuration error was detected */
+#define EV_INVALID_STATE	11	/* The object is in an invalid state */
+#define EV_UNIMPLEMENTED	12	/* Unimplemented hypercall */
+#define EV_BUFFER_OVERFLOW	13	/* Caller-supplied buffer too small */
+
+#endif /* _UAPI__EPAPR_HCALLS_H */
-- 
1.6.0.2

