Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2FPFCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2FPFCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:19 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 05/12] irqdomain: Fix irq_create_direct_mapping() to test irq_domain type.
Date: Fri, 15 Jun 2012 23:01:30 -0600
Message-Id: <1339822897-15840-6-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_create_direct_mapping can only be used with the NOMAP type.  Make
the function test to ensure it is passed the correct type of
irq_domain.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 79a7711..0483e27 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -447,8 +447,8 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	if (domain == NULL)
 		domain = irq_default_domain;
 
-	BUG_ON(domain == NULL);
-	WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
+	if (WARN_ON(!domain || domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP))
+		return 0;
 
 	virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
 	if (!virq) {
-- 
1.7.9.5

