Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2GZP4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:56:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36764 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2GZP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:56:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="203311668"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 19/24] xen/arm: compile netback
Date: Thu, 26 Jul 2012 16:34:01 +0100
Message-ID: <1343316846-25860-19-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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
index f4a6fca..ab4f81c 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -40,6 +40,7 @@
 
 #include <net/tcp.h>
 
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/interface/memory.h>
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3089990..bf4ba2b 100644
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

