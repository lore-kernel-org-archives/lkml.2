Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2FFJLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:11:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44246 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FFJLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:11:40 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 1/2] clk: cache parent clocks only for muxes
Date: Wed, 6 Jun 2012 14:41:30 +0530
Message-ID: <1338973891-28719-2-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338973891-28719-1-git-send-email-rnayak@ti.com>
References: <1338973891-28719-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caching parent clocks makes sense only when a clock has more
than one parent (mux clocks).
Avoid doing this for every other clock.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/clk/clk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 687b00d..40568e9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1229,7 +1229,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * If clk->parents is not NULL we skip this entire block.  This allows
 	 * for clock drivers to statically initialize clk->parents.
 	 */
-	if (clk->num_parents && !clk->parents) {
+	if ((clk->num_parents > 1) && !clk->parents) {
 		clk->parents = kmalloc((sizeof(struct clk*) * clk->num_parents),
 				GFP_KERNEL);
 		/*
-- 
1.7.1

