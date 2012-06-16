Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2FPFCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2FPFCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 10/12] irqdomain: Add debugging message
Date: Fri, 15 Jun 2012 23:01:35 -0600
Message-Id: <1339822897-15840-11-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch to beef up debugging messages on irqdomain.c

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index c0a00de..0e02a1d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -334,6 +334,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 	irq_hw_number_t hwirq = hwirq_base;
 	int i;
 
+	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
+		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
+
 	for (i = 0; i < count; i++) {
 		struct irq_data *irq_data = irq_get_irq_data(virq + i);
 
-- 
1.7.9.5

