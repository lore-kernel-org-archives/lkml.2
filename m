Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab2GDLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:15:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41382 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620Ab2GDLPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="30393587"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, david.vrabel@citrix.com
Subject: [PATCH WIP 5/5] xen/arm: compile blkfront and blkback
Date: Wed, 4 Jul 2012 12:15:20 +0100
Message-ID: <1341400520-31770-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/hypervisor.h    |    6 ++++++
 drivers/block/xen-blkback/blkback.c  |    1 +
 drivers/block/xen-blkfront.c         |    1 +
 include/xen/interface/io/protocols.h |    3 +++
 4 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/hypervisor.h

diff --git a/arch/arm/include/asm/hypervisor.h b/arch/arm/include/asm/hypervisor.h
new file mode 100644
index 0000000..b90d9e5
--- /dev/null
+++ b/arch/arm/include/asm/hypervisor.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ARM_HYPERVISOR_H
+#define _ASM_ARM_HYPERVISOR_H
+
+#include <asm/xen/hypervisor.h>
+
+#endif
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index fbffdf0..78ce4c0 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -45,6 +45,7 @@
 
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include "common.h"
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9fd3ee2..dd1589e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -56,6 +56,7 @@
 #include <xen/interface/io/protocols.h>
 
 #include <asm/xen/hypervisor.h>
+#include <asm/xen/mmu.h>
 
 enum blkif_state {
 	BLKIF_STATE_DISCONNECTED,
diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
index 01fc8ae..e85cc64 100644
--- a/include/xen/interface/io/protocols.h
+++ b/include/xen/interface/io/protocols.h
@@ -5,6 +5,7 @@
 #define XEN_IO_PROTO_ABI_X86_64     "x86_64-abi"
 #define XEN_IO_PROTO_ABI_IA64       "ia64-abi"
 #define XEN_IO_PROTO_ABI_POWERPC64  "powerpc64-abi"
+#define XEN_IO_PROTO_ABI_ARM	    "arm-abi"
 
 #if defined(__i386__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_32
@@ -14,6 +15,8 @@
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
 #elif defined(__powerpc64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
+#elif defined(__arm__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
 #else
 # error arch fixup needed here
 #endif
-- 
1.7.2.5

