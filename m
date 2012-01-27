Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2A0Vgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:36:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49572 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2A0Vgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:49 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 23/25] irq_domain: Include hwirq number in /proc/interrupts
Date: Fri, 27 Jan 2012 14:36:17 -0700
Message-Id: <1327700179-17454-24-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hardware interrupt number to the output of /proc/interrupts.
It is often important to have access to the hardware interrupt number because
it identifies exactly how an interrupt signal is wired up to the interrupt
controller.  This is especially important when using irq_domains since irq
numbers get dynamically allocated in that case, and have no relation to the
actual hardware number.

Note: This output is currently conditional on whether or not the irq_domain
pointer is set; however hwirq could still be used without irq_domain.  It
may be worthwhile to always output the hwirq number regardless of the
domain pointer.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/proc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4bd4faa..2ec61d0 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -472,6 +472,9 @@ int show_interrupts(struct seq_file *p, void *v)
 	if (desc->name)
 		seq_printf(p, "-%-8s", desc->name);
 
+	if (desc->irq_data.domain)
+		seq_printf(p, " %-8d", (int) desc->irq_data.hwirq);
+
 	if (action) {
 		seq_printf(p, "  %s", action->name);
 		while ((action = action->next) != NULL)
-- 
1.7.5.4

