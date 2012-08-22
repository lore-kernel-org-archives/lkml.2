Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2HVQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:20:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16732 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023Ab2HVQUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:20:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336363200"; 
   d="scan'208";a="35465046"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/6] xen: missing includes
Date: Wed, 22 Aug 2012 17:20:12 +0100
Message-ID: <1345652416-27181-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 09d5f7f..ee9cad6 100644
--- a/arch/ia64/include/asm/xen/interface.h
+++ b/arch/ia64/include/asm/xen/interface.h
@@ -265,6 +265,8 @@ typedef struct xen_callback xen_callback_t;
 
 #endif /* !__ASSEMBLY__ */
 
+#include <asm/pvclock-abi.h>
+
 /* Size of the shared_info area (this is not related to page size).  */
 #define XSI_SHIFT			14
 #define XSI_SIZE			(1 << XSI_SHIFT)
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index cbf0c9d..a93db16 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -121,6 +121,8 @@ struct arch_shared_info {
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
index 0801468..6e75dea 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -10,7 +10,6 @@
 #define __XEN_PUBLIC_XEN_H__
 
 #include <asm/xen/interface.h>
-#include <asm/pvclock-abi.h>
 
 /*
  * XEN "SYSTEM CALLS" (a.k.a. HYPERCALLS).
diff --git a/include/xen/privcmd.h b/include/xen/privcmd.h
index 17857fb..4d58881 100644
--- a/include/xen/privcmd.h
+++ b/include/xen/privcmd.h
@@ -35,6 +35,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <xen/interface/xen.h>
 
 typedef unsigned long xen_pfn_t;
 
-- 
1.7.2.5

