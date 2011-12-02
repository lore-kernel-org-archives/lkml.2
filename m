Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1LBNa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:30:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:44637 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab1LBNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:30:25 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] irqdomain: protect macro variable in domain iterators
Date: Fri,  2 Dec 2011 14:30:09 +0100
Message-Id: <1322832609-24956-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322833997-32083-1-git-send-email-nicolas.ferre@atmel.com>
References: <1322833997-32083-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2: add brackets to each macro variable.

 include/linux/irqdomain.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index bd4272b..e535063 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -82,12 +82,14 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 }
 
 #define irq_domain_for_each_hwirq(d, hw) \
-	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
+	for ((hw) = (d)->hwirq_base; \
+	     (hw) < (d)->hwirq_base + (d)->nr_irq; \
+	     (hw)++)
 
 #define irq_domain_for_each_irq(d, hw, irq) \
-	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
-	     hw < d->hwirq_base + d->nr_irq; \
-	     hw++, irq = irq_domain_to_irq(d, hw))
+	for ((hw) = (d)->hwirq_base, (irq) = irq_domain_to_irq((d), (hw)); \
+	     (hw) < (d)->hwirq_base + (d)->nr_irq; \
+	     (hw)++, (irq) = irq_domain_to_irq((d), (hw)))
 
 extern void irq_domain_add(struct irq_domain *domain);
 extern void irq_domain_del(struct irq_domain *domain);
-- 
1.7.5.4

