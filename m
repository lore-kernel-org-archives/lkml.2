Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2IQRlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:41:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab2IQRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:40:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344211200"; 
   d="scan'208";a="208319440"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <tim@xen.org>,
        <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 16/17] xen/arm: compile netback
Date: Mon, 17 Sep 2012 18:39:02 +0100
Message-ID: <1347903543-2135-16-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/include/asm/xen/hypercall.h |   19 +++++++++++++++++++
 drivers/net/xen-netback/netback.c    |    1 +
 drivers/net/xen-netfront.c           |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
index 4ac0624..8a82325 100644
--- a/arch/arm/include/asm/xen/hypercall.h
+++ b/arch/arm/include/asm/xen/hypercall.h
@@ -47,4 +47,23 @@ unsigned long HYPERVISOR_hvm_op(int op, void *arg);
 int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
 int HYPERVISOR_physdev_op(int cmd, void *arg);
 
+static inline void
+MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
+			unsigned int new_val, unsigned long flags)
+{
+	BUG();
+}
+
+static inline void
+MULTI_mmu_update(struct multicall_entry *mcl, struct mmu_update *req,
+		 int count, int *success_count, domid_t domid)
+{
+	BUG();
+}
+
+static inline int
+HYPERVISOR_multicall(void *call_list, int nr_calls)
+{
+	BUG();
+}
 #endif /* _ASM_ARM_XEN_HYPERCALL_H */
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 682633b..1c0a302 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -40,6 +40,7 @@
 
 #include <net/tcp.h>
 
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/interface/memory.h>
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 650f79a..24d968d 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -43,6 +43,7 @@
 #include <linux/slab.h>
 #include <net/ip.h>
 
+#include <asm/xen/page.h>
 #include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
-- 
1.7.2.5

