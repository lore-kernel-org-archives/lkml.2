Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab1LOCcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:32:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1LOCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:32:18 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 1/4] irq: Get rid of irq_domain_for_each_hwirq().
Date: Wed, 14 Dec 2011 18:32:07 -0800
Message-Id: <1323916330-8865-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
References: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

It is not used anywhere in the kernel.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/irqdomain.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 99834e58..0914a54 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -81,9 +81,6 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 	return d->irq_base + hwirq - d->hwirq_base;
 }
 
-#define irq_domain_for_each_hwirq(d, hw) \
-	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
-
 #define irq_domain_for_each_irq(d, hw, irq) \
 	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
 	     hw < d->hwirq_base + d->nr_irq; \
-- 
1.7.2.3

