Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0LCDSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:18:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:23885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab0LCDSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:18:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="632637026"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: mingo@elte.com, hpa@zytor.com, alan@linux.intel.com,
        Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@intel.com>
Subject: [PATCH 2/2] x86, apbt: setup affinity for apb timers acting as per-cpu timer
Date: Fri,  3 Dec 2010 11:51:38 +0800
Message-Id: <1291348298-21263-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
References: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a5ef2e70 "x86: Sanitize apb timer interrupt handling" forgot
the affinity setup when cleaning up the code, this patch just
adds the forgotten part

Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/apb_timer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 92543c7..7c9ab59 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -315,6 +315,7 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 
 	if (system_state == SYSTEM_BOOTING) {
 		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 		/* APB timer irqs are set up as mp_irqs, timer is edge type */
 		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
-- 
1.7.0.4

