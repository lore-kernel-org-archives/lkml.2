Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761Ab1IOUKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:9031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934568Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="51959234"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com
Subject: [PATCH 04/27] Initconst section fixes for IA64
Date: Thu, 15 Sep 2011 13:09:31 -0700
Message-Id: <1316117394-21666-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: tony.luck@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/ia64/xen/irq_xen.c |    2 +-
 arch/ia64/xen/irq_xen.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index b279e14..b60c855 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -433,7 +433,7 @@ xen_resend_irq(unsigned int vector)
 	(void)resend_irq_on_evtchn(vector);
 }
 
-const struct pv_irq_ops xen_irq_ops __initdata = {
+const struct pv_irq_ops xen_irq_ops __initconst = {
 	.register_ipi = xen_register_ipi,
 
 	.assign_irq_vector = xen_assign_irq_vector,
diff --git a/arch/ia64/xen/irq_xen.h b/arch/ia64/xen/irq_xen.h
index 26110f3..1778517 100644
--- a/arch/ia64/xen/irq_xen.h
+++ b/arch/ia64/xen/irq_xen.h
@@ -27,7 +27,7 @@ extern void (*late_time_init)(void);
 extern char xen_event_callback;
 void __init xen_init_IRQ(void);
 
-extern const struct pv_irq_ops xen_irq_ops __initdata;
+extern const struct pv_irq_ops xen_irq_ops __initconst;
 extern void xen_smp_intr_init(void);
 extern void xen_send_ipi(int cpu, int vec);
 
-- 
1.7.4.4

