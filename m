Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab2FRLcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:32:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43210 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2FRLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:40 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 2/8] ARM: gic: Export gic_raise_softirq function for kernel modules
Date: Mon, 18 Jun 2012 13:30:05 +0200
Message-Id: <1340019011-18642-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used by device driver for raising
software irqs. For example AMP(remoteproc) on Zynq.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/common/gic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 4003cc2..b8e7202 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -22,6 +22,7 @@
  * As such, the enable set/clear, pending set/clear and active bit
  * registers are banked per-cpu for these sources.
  */
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
@@ -753,6 +754,7 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 }
+EXPORT_SYMBOL(gic_raise_softirq);
 #endif
 
 #ifdef CONFIG_OF
-- 
1.7.0.4

