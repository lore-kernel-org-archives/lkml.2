Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2ESGNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:13:24 -0400
Received: from linux-sh.org ([111.68.239.195]:60861 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 7/8] irqdomain: trivial pr_fmt conversion.
Date: Sat, 19 May 2012 15:11:47 +0900
Message-Id: <1337407908-7421-8-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to pr_fmt before things start to get out of hand and some
janitors start getting overly excited.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 kernel/irq/irqdomain.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index ac44781..e8ac7df 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt)  "irq: " fmt
+
 #include <linux/debugfs.h>
 #include <linux/hardirq.h>
 #include <linux/interrupt.h>
@@ -124,7 +126,7 @@ void irq_domain_remove(struct irq_domain *domain)
 
 	mutex_unlock(&irq_domain_mutex);
 
-	pr_debug("irq: Removed domain of type %d @0x%p\n",
+	pr_debug("Removed domain of type %d @0x%p\n",
 		 domain->revmap_type, domain);
 
 	irq_domain_free(domain);
@@ -329,7 +331,7 @@ EXPORT_SYMBOL_GPL(irq_find_host);
  */
 void irq_set_default_host(struct irq_domain *domain)
 {
-	pr_debug("irq: Default domain set to @0x%p\n", domain);
+	pr_debug("Default domain set to @0x%p\n", domain);
 
 	irq_default_domain = domain;
 }
@@ -343,7 +345,7 @@ static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map(domain, virq, hwirq)) {
-		pr_debug("irq: -> mapping failed, freeing\n");
+		pr_debug("-> mapping failed, freeing\n");
 		irq_data->domain = NULL;
 		irq_data->hwirq = 0;
 		return -1;
@@ -374,7 +376,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 
 	virq = irq_alloc_desc_from(1, irq_domain_nid(domain->of_node));
 	if (!virq) {
-		pr_debug("irq: create_direct virq allocation failed\n");
+		pr_debug("create_direct virq allocation failed\n");
 		return 0;
 	}
 	if (virq >= domain->revmap_data.nomap.max_irq) {
@@ -383,7 +385,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 		irq_free_desc(virq);
 		return 0;
 	}
-	pr_debug("irq: create_direct obtained virq %d\n", virq);
+	pr_debug("create_direct obtained virq %d\n", virq);
 
 	if (irq_setup_virq(domain, virq, virq)) {
 		irq_free_desc(virq);
@@ -410,23 +412,23 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	unsigned int hint;
 	int virq;
 
-	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
+	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL) {
-		printk(KERN_WARNING "irq_create_mapping called for"
-		       " NULL domain, hwirq=%lx\n", hwirq);
+		pr_warning("irq_create_mapping called for"
+			   " NULL domain, hwirq=%lx\n", hwirq);
 		WARN_ON(1);
 		return 0;
 	}
-	pr_debug("irq: -> using domain @%p\n", domain);
+	pr_debug("-> using domain @%p\n", domain);
 
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
-		pr_debug("irq: -> existing mapping on virq %d\n", virq);
+		pr_debug("-> existing mapping on virq %d\n", virq);
 		return virq;
 	}
 
@@ -442,7 +444,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	if (virq <= 0)
 		virq = irq_alloc_desc_from(1, irq_domain_nid(domain->of_node));
 	if (virq <= 0) {
-		pr_debug("irq: -> virq allocation failed\n");
+		pr_debug("-> virq allocation failed\n");
 		return 0;
 	}
 
@@ -452,7 +454,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	pr_debug("irq: irq %lu on domain %s mapped to virtual irq %u\n",
+	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
 		hwirq, domain->of_node ? domain->of_node->full_name : "null", virq);
 
 	return virq;
@@ -472,7 +474,7 @@ unsigned int irq_create_identity_mapping(struct irq_domain *domain,
 {
 	int virq;
 
-	pr_debug("irq: irq_create_identity_mapping(0x%p, 0x%lx)\n",
+	pr_debug("irq_create_identity_mapping(0x%p, 0x%lx)\n",
 		 domain, hwirq);
 
 	if (domain == NULL)
@@ -484,7 +486,7 @@ unsigned int irq_create_identity_mapping(struct irq_domain *domain,
 
 	virq = irq_alloc_desc_at(hwirq, irq_domain_nid(domain->of_node));
 	if (virq < 0) {
-		pr_debug("irq: -> virq allocation failed\n");
+		pr_debug("-> virq allocation failed\n");
 		return 0;
 	}
 
@@ -494,7 +496,7 @@ unsigned int irq_create_identity_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	pr_debug("irq: irq %lu identity mapped\n", hwirq);
+	pr_debug("irq %lu identity mapped\n", hwirq);
 
 	return virq;
 }
@@ -522,8 +524,8 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 		if (intsize > 0)
 			return intspec[0];
 #endif
-		printk(KERN_WARNING "irq: no irq domain found for %s !\n",
-		       controller->full_name);
+		pr_warning("no irq domain found for %s !\n",
+			   controller->full_name);
 		return 0;
 	}
 
-- 
1.7.9.rc0.28.g0e1cf

