Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1LNP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:29:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab1LNP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:29:26 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/9] irq: check domain hwirq range for DT translate
Date: Wed, 14 Dec 2011 09:28:51 -0600
Message-Id: <1323876538-20406-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

A DT node may have more than 1 domain associated with it, so make sure
the hwirq number is within range when doing DT translation.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 200ce83..ae6441e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -135,6 +135,9 @@ int irq_domain_simple_dt_translate(struct irq_domain *d,
 		return -EINVAL;
 	if (intsize < 1)
 		return -EINVAL;
+	if ((intspec[0] < d->hwirq_base) ||
+	    (intspec[0] >= d->hwirq_base + d->nr_irq))
+		return -EINVAL;
 
 	*out_hwirq = intspec[0];
 	*out_type = IRQ_TYPE_NONE;
-- 
1.7.5.4

