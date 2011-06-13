Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1FMAq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:46:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1FMAqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:46:25 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH] ARM: gic: Allow gic arch extensions to provide irqchip flags
Date: Sun, 12 Jun 2011 17:45:59 -0700
Message-Id: <1307925960-28839-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra can benefit from the IRQCHIP_MASK_ON_SUSPEND flag, allow it
to be passed to the gic irq chip.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/common/gic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 8d62e07..a6c28a0 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -576,6 +576,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	if (gic_nr == 0)
 		gic_cpu_base_addr = cpu_base;
 
+	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic, irq_start);
 	gic_cpu_init(gic);
 	gic_cpu_pm_init(gic);
-- 
1.7.4.1

