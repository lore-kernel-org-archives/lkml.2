Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2ESGNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:13:31 -0400
Received: from linux-sh.org ([111.68.239.195]:60859 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/8] irqdomain: Export remaining public API symbols.
Date: Sat, 19 May 2012 15:11:42 +0900
Message-Id: <1337407908-7421-3-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modules making use of irq domains at the very least need access to the
add/remove/lookup routines, though there's nothing preventing them from
using the remainder of the public API, either.

The current set of exports seem primarily geared at DT-enabled platforms
using DT-backed IRQ domains, where many of the API accesses are hidden
away in OF code. The non-DT cases need to do most of this on their own.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 kernel/irq/irqdomain.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 9cae0b2..01d4a0d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -122,6 +122,7 @@ void irq_domain_remove(struct irq_domain *domain)
 
 	irq_domain_free(domain);
 }
+EXPORT_SYMBOL_GPL(irq_domain_remove);
 
 static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
 					     irq_hw_number_t hwirq)
@@ -209,6 +210,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 	irq_domain_add(domain);
 	return domain;
 }
+EXPORT_SYMBOL_GPL(irq_domain_add_legacy);
 
 /**
  * irq_domain_add_linear() - Allocate and register a legacy revmap irq_domain.
@@ -238,6 +240,7 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 	irq_domain_add(domain);
 	return domain;
 }
+EXPORT_SYMBOL_GPL(irq_domain_add_linear);
 
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
@@ -252,6 +255,7 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 	}
 	return domain;
 }
+EXPORT_SYMBOL_GPL(irq_domain_add_nomap);
 
 /**
  * irq_domain_add_tree()
@@ -273,6 +277,7 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 	}
 	return domain;
 }
+EXPORT_SYMBOL_GPL(irq_domain_add_tree);
 
 /**
  * irq_find_host() - Locates a domain for a given device node
@@ -320,6 +325,7 @@ void irq_set_default_host(struct irq_domain *domain)
 
 	irq_default_domain = domain;
 }
+EXPORT_SYMBOL_GPL(irq_set_default_host);
 
 static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq)
@@ -378,6 +384,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 
 	return virq;
 }
+EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
 /**
  * irq_create_mapping() - Map a hardware interrupt into linux irq space
@@ -617,6 +624,7 @@ unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
 	 */
 	return irq_data ? irq_data->irq : irq_find_mapping(domain, hwirq);
 }
+EXPORT_SYMBOL_GPL(irq_radix_revmap_lookup);
 
 /**
  * irq_radix_revmap_insert() - Insert a hw irq to linux irq number mapping.
@@ -641,6 +649,7 @@ void irq_radix_revmap_insert(struct irq_domain *domain, unsigned int virq,
 		mutex_unlock(&revmap_trees_mutex);
 	}
 }
+EXPORT_SYMBOL_GPL(irq_radix_revmap_insert);
 
 /**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
@@ -674,6 +683,7 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
 
 	return revmap[hwirq];
 }
+EXPORT_SYMBOL_GPL(irq_linear_revmap);
 
 #ifdef CONFIG_IRQ_DOMAIN_DEBUG
 static int virq_debug_show(struct seq_file *m, void *private)
-- 
1.7.9.rc0.28.g0e1cf

