Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1KWMZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:25:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54141 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab1KWMZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:25:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] irq: Staticise irq_domain_simple_dt_translate()
Date: Wed, 23 Nov 2011 12:25:39 +0000
Message-Id: <1322051139-15202-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_simple_dt_translate() is only ever accessed indirectly through
irq_domain_simple_ops and should therefore be static.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b22a641..4dc9826 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -126,7 +126,7 @@ void irq_dispose_mapping(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
-int irq_domain_simple_dt_translate(struct irq_domain *d,
+static int irq_domain_simple_dt_translate(struct irq_domain *d,
 			    struct device_node *controller,
 			    const u32 *intspec, unsigned int intsize,
 			    unsigned long *out_hwirq, unsigned int *out_type)
-- 
1.7.7.3

