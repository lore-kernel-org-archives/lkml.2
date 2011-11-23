Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1KWMNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:13:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58124 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985Ab1KWMNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:13:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] irq: Fix possible null pointer dereference on domains with no ops
Date: Wed, 23 Nov 2011 12:13:27 +0000
Message-Id: <1322050407-12234-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is optional for irqdomains to have operations so we need to check for
their presence before dereferencing them when looking for dt_translate().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 200ce83..b22a641 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -89,7 +89,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	/* Find a domain which can translate the irq spec */
 	mutex_lock(&irq_domain_mutex);
 	list_for_each_entry(domain, &irq_domain_list, list) {
-		if (!domain->ops->dt_translate)
+		if (!domain->ops || !domain->ops->dt_translate)
 			continue;
 		rc = domain->ops->dt_translate(domain, controller,
 					intspec, intsize, &hwirq, &type);
-- 
1.7.7.3

