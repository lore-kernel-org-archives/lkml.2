Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2IJEhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:37:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43689 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2IJEhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:37:53 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:37:52 +0800
Message-ID: <CAPgLHd_jX4nBPZvzKES4reabdeNb9SOpL1CdVShrrqOgR6OzqQ@mail.gmail.com>
Subject: [PATCH] irqdomain: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org, grant.likely@secretlab.ca, tglx@linutronix.de
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/irq/irqdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 49a7772..3e5d3fc 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -374,11 +374,12 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 	while (count--) {
 		int irq = irq_base + count;
 		struct irq_data *irq_data = irq_get_irq_data(irq);
-		irq_hw_number_t hwirq = irq_data->hwirq;
+		irq_hw_number_t hwirq;
 
 		if (WARN_ON(!irq_data || irq_data->domain != domain))
 			continue;
 
+		hwirq = irq_data->hwirq;
 		irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 		/* remove chip and handler */

