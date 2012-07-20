Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2GTNhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:37:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5506 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2GTNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:37:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 20 Jul 2012 06:36:55 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: fix return value check in clk_get
Date: Fri, 20 Jul 2012 16:36:37 +0300
Message-ID: <1342791397-11732-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_clk_get_by_name returns an ERR_PTR on failure. Hence we should use IS_ERR()
and not just check for a non NULL value.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clkdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 8f87b0f..d423c9b 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -157,7 +157,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 
 	if (dev) {
 		clk = of_clk_get_by_name(dev->of_node, con_id);
-		if (clk && __clk_get(clk))
+		if (!IS_ERR(clk) && __clk_get(clk))
 			return clk;
 	}
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

