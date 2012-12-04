Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2LDL2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:28:51 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58920 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2LDL2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:28:48 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] memory: of_memory.c: remove unnecessary initialization
Date: Tue,  4 Dec 2012 11:26:59 +0000
Message-Id: <1354620448-14317-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the initialization of variable ret is unnecessary, we can remove it while save
one time "or" operation.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/memory/of_memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
index 6007435..c59a946 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -30,14 +30,14 @@
 const struct lpddr2_min_tck *of_get_min_tck(struct device_node *np,
 		struct device *dev)
 {
-	int			ret = 0;
+	int			ret;
 	struct lpddr2_min_tck	*min;
 
 	min = devm_kzalloc(dev, sizeof(*min), GFP_KERNEL);
 	if (!min)
 		goto default_min_tck;
 
-	ret |= of_property_read_u32(np, "tRPab-min-tck", &min->tRPab);
+	ret = of_property_read_u32(np, "tRPab-min-tck", &min->tRPab);
 	ret |= of_property_read_u32(np, "tRCD-min-tck", &min->tRCD);
 	ret |= of_property_read_u32(np, "tWR-min-tck", &min->tWR);
 	ret |= of_property_read_u32(np, "tRASmin-min-tck", &min->tRASmin);
-- 
1.7.4.5

