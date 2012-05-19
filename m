Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2ESGMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:12:37 -0400
Received: from linux-sh.org ([111.68.239.195]:60857 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/8] irqdomain: Make irq_domain_simple_map() static.
Date: Sat, 19 May 2012 15:11:43 +0900
Message-Id: <1337407908-7421-4-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently irq_domain_simple_map() isn't labelled as static, but there's
no definition for it in the public irqdomain header either. At present
all in-tree ->map users have meaningful work to do, and all others are
using irq_domain_simple_ops directly. Make it static for now, as it can
always be exported and added to the public API later.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 kernel/irq/irqdomain.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 01d4a0d..92e06442 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -758,8 +758,8 @@ static int __init irq_debugfs_init(void)
 __initcall(irq_debugfs_init);
 #endif /* CONFIG_IRQ_DOMAIN_DEBUG */
 
-int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
-			  irq_hw_number_t hwirq)
+static int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
+				 irq_hw_number_t hwirq)
 {
 	return 0;
 }
-- 
1.7.9.rc0.28.g0e1cf

