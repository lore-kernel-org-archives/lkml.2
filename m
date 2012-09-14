Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2INLlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:41:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8685 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab2INLk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:40:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37874944"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 22/24] xen: missing includes
Date: Fri, 14 Sep 2012 12:13:24 +0100
Message-ID: <1347621207-11294-22-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this patch should be already in Konrad's tree, it is here just for
convenience.

Changes in v3:
- add missing pvclock-abi.h include to ia64 header files.

Changes in v2:
- remove pvclock hack;
- remove include linux/types.h from xen/interface/xen.h.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/ia64/include/asm/xen/interface.h      |    2 ++
 arch/x86/include/asm/xen/interface.h       |    2 ++
 drivers/tty/hvc/hvc_xen.c                  |    2 ++
 drivers/xen/grant-table.c                  |    1 +
 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 include/xen/interface/xen.h                |    1 -
 include/xen/privcmd.h                      |    1 +
 7 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/xen/interface.h b/arch/ia64/include/asm/xen/interface.h
index 7c83445..e88c5de 100644
--- a/arch/ia64/include/asm/xen/interface.h
+++ b/arch/ia64/include/asm/xen/interface.h
@@ -269,6 +269,8 @@ typedef struct xen_callback xen_callback_t;
 
 #endif /* !__ASSEMBLY__ */
 
+#include <asm/pvclock-abi.h>
+
 /* Size of the shared_info area (this is not related to page size).  */
 #define XSI_SHIFT			14
 #define XSI_SIZE			(1 << XSI_SHIFT)
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 25cc8df..28fc621 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -127,6 +127,8 @@ struct arch_shared_info {
 #include "interface_64.h"
 #endif
 
+#include <asm/pvclock-abi.h>
+
 #ifndef __ASSEMBLY__
 /*
  * The following is all CPU context. Note that the fpu_ctxt block is filled
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 1e456dc..2944ff8 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/err.h>
+#include <linux/irq.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/list.h>
@@ -35,6 +36,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
+#include <xen/interface/sched.h>
 #include <xen/hvc-console.h>
 #include <xen/xenbus.h>
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 0bfc1ef..1d0d95e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -47,6 +47,7 @@
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/interface.h>
 
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index a31b54d..3159a37 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -21,6 +21,7 @@
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/xen.h>
 
 #include <xen/platform_pci.h>
 
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 0054db1..1e0df6b 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -10,7 +10,6 @@
 #define __XEN_PUBLIC_XEN_H__
 
 #include <asm/xen/interface.h>
-#include <asm/pvclock-abi.h>
 
 /*
  * XEN "SYSTEM CALLS" (a.k.a. HYPERCALLS).
diff --git a/include/xen/privcmd.h b/include/xen/privcmd.h
index 59f1bd8..45c1aa1 100644
--- a/include/xen/privcmd.h
+++ b/include/xen/privcmd.h
@@ -35,6 +35,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <xen/interface/xen.h>
 
 struct privcmd_hypercall {
 	__u64 op;
-- 
1.7.2.5

