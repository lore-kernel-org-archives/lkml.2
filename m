Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab1INQb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:31:58 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57600 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1INQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:31:57 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] irq: fix existing domain check in irq_domain_add
Date: Wed, 14 Sep 2011 11:31:37 -0500
Message-Id: <1316017900-19918-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

irq_data will normally exist, so the domain was prevented from being set.
The simple domain code did not hit this as nr_irq is always 0.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d5828da..84f4110 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -29,7 +29,7 @@ void irq_domain_add(struct irq_domain *domain)
 	 */
 	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
 		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
-		if (d || d->domain) {
+		if (d && d->domain) {
 			/* things are broken; just report, don't clean up */
 			WARN(1, "error: irq_desc already assigned to a domain");
 			return;
-- 
1.7.5.4

