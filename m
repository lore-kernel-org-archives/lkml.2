Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab2DJXvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:51:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40589 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab2DJXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:51:46 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] irq_domain: Fix debug output to use "irq" instead of "virq"
Date: Tue, 10 Apr 2012 17:51:38 -0600
Message-Id: <1334101898-19389-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back when irq_domain was a powerpc-only thing, the term "virq", or
virtual irq, was used to differentiate irq numbers from hardware irq
numbers.  However, virqs are synonymous with Linux irq numbers, so
using a different term is confusing.  This patch changes the debug
output to use the header "irq" instead of "virq" for the irq number
output column.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4bf074a..b792e58 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -643,7 +643,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 	void *data;
 	int i;
 
-	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
+	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "irq", "hwirq",
 		      "chip name", "chip data", "domain name");
 
 	for (i = 1; i < nr_irqs; i++) {
-- 
1.7.9.1

