Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2GCU0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:26:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55554 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2GCU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:26:07 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] clk: fix used-uninitialized warning in__clk_set_parent
Date: Tue,  3 Jul 2012 14:26:00 -0600
Message-Id: <1341347160-21170-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This fixes:
drivers/clk/clk.c: In function '__clk_set_parent':
drivers/clk/clk.c:1069:5: warning: 'i' may be used uninitialized in this function

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/clk/clk.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 026d901..42647ca 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1071,13 +1071,15 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	old_parent = clk->parent;
 
 	/* find index of new parent clock using cached parent ptrs */
-	if (clk->parents)
+	if (clk->parents) {
 		for (i = 0; i < clk->num_parents; i++)
 			if (clk->parents[i] == parent)
 				break;
-	else
+	} else {
 		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
 								GFP_KERNEL);
+		i = clk->num_parents;
+	}
 
 	/*
 	 * find index of new parent clock using string name comparison
-- 
1.7.0.4

