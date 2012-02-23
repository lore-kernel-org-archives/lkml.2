Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2BWRoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:44:12 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14225 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab2BWRmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:42:38 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387550"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 06/13] xen/arm: missing includes
Date: Thu, 23 Feb 2012 17:48:27 +0000
Message-ID: <1330019314-20865-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/grant_table.h     |    2 ++
 drivers/xen/grant-table.c                  |    2 ++
 drivers/xen/xenbus/xenbus_client.c         |    1 +
 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 drivers/xen/xenfs/xenstored.c              |    1 +
 include/xen/privcmd.h                      |    1 +
 6 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/xen/grant_table.h b/arch/arm/include/asm/xen/grant_table.h
index 4e3f7b2..43c0d4b 100644
--- a/arch/arm/include/asm/xen/grant_table.h
+++ b/arch/arm/include/asm/xen/grant_table.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_ARM_XEN_GRANT_TABLE_H
 #define _ASM_ARM_XEN_GRANT_TABLE_H
 
+#include <asm/xen/mmu.h>
+
 #define xen_alloc_vm_area(size)	alloc_vm_area(size)
 #define xen_free_vm_area(area)	free_vm_area(area)
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index bf1c094..de77304 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -45,6 +45,8 @@
 #include <xen/grant_table.h>
 #include <xen/interface/memory.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/mmu.h>
+#include <asm/xen/interface.h>
 
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 1906125..65088964 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -36,6 +36,7 @@
 #include <linux/export.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/page.h>
+#include <asm/xen/grant_table.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 #include <xen/events.h>
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 2f73195..e8d1798 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -21,6 +21,7 @@
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/xen.h>
 
 #include <xen/platform_pci.h>
 
diff --git a/drivers/xen/xenfs/xenstored.c b/drivers/xen/xenfs/xenstored.c
index fef20db..ddf2585 100644
--- a/drivers/xen/xenfs/xenstored.c
+++ b/drivers/xen/xenfs/xenstored.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 
 #include <xen/page.h>
+#include <asm/xen/mmu.h>
 
 #include "xenfs.h"
 #include "../xenbus/xenbus_comms.h"
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

