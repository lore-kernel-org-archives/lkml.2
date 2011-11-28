Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1K1Cti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:49:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61337 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab1K1Cth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:49:37 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, benh@kernel.crashing.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of/irq: of_irq_init: add check for parent equal to child node
Date: Sun, 27 Nov 2011 20:49:10 -0600
Message-Id: <1322448550-15392-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

With the revert of "of/irq: of_irq_find_parent: check for parent equal to
child" (dc9372808412edb), we need another way to handle parent node equal
to the child node. This can simply be handled in of_irq_init by checking
for this condition.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 791270b..19c0115 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -424,6 +424,8 @@ void __init of_irq_init(const struct of_device_id *matches)
 
 		desc->dev = np;
 		desc->interrupt_parent = of_irq_find_parent(np);
+		if (desc->interrupt_parent == np)
+			desc->interrupt_parent = NULL;
 		list_add_tail(&desc->list, &intc_desc_list);
 	}
 
-- 
1.7.5.4

