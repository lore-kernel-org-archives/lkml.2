Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2FOSNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:13:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65479 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2FOSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:13:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/2] irqdomain: Remove unnecessary test for IRQ_DOMAIN_MAP_LEGACY
Date: Fri, 15 Jun 2012 12:13:31 -0600
Message-Id: <1339784011-7604-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339784011-7604-1-git-send-email-grant.likely@secretlab.ca>
References: <1339784011-7604-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where irq_domain_associate() is called in irq_create_mapping, there is
no need to test for IRQ_DOMAIN_MAP_LEGACY because it is already tested
for earlier in the routine.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 79ae0eb..b1f774c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -445,8 +445,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	if (irq_setup_virq(domain, virq, hwirq)) {
-		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
-			irq_free_desc(virq);
+		irq_free_desc(virq);
 		return 0;
 	}
 
-- 
1.7.9.5

