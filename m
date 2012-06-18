Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2FRLau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRLas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:48 -0400
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
Subject: [RFC PATCH 4/8] ARM: smp: Move cpu initialization directly to ipi_cpu_stop
Date: Mon, 18 Jun 2012 13:30:07 +0200
Message-Id: <1340019011-18642-5-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just preparation patch for dynamic IPI allocation.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/kernel/smp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 2c7217d..47406ee 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -468,8 +468,10 @@ static DEFINE_RAW_SPINLOCK(stop_lock);
 /*
  * ipi_cpu_stop - handle IPI from smp_send_stop()
  */
-static void ipi_cpu_stop(unsigned int cpu)
+static void ipi_cpu_stop(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (system_state == SYSTEM_BOOTING ||
 	    system_state == SYSTEM_RUNNING) {
 		raw_spin_lock(&stop_lock);
@@ -528,7 +530,7 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 
 	case IPI_CPU_STOP:
 		irq_enter();
-		ipi_cpu_stop(cpu);
+		ipi_cpu_stop();
 		irq_exit();
 		break;
 
-- 
1.7.0.4

