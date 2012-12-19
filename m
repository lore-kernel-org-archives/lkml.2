Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2LSK6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:58:48 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56537 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2LSK6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:58:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] of: Fix export of of_find_matching_node_and_match()
Date: Wed, 19 Dec 2012 10:58:36 +0000
Message-Id: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 50c8af4cf9, "of: introduce for_each_matching_node_and_match()"
renamed of_find_matching_node() to of_find_matching_node_and_match() and
created a new static inline of_find_matching_node() wrapper around the
new name. However, the change neglected to change the EXPORT_SYMBOL()
reference causing build errors for modules.

This patch fixes the EXPORT_SYMBOL() statement. Discovered on a PowerPC
Efika build with the mpc52xx_uart driver being built as a module.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Anatolij Gustschin <agust@denx.de>
---

I'll push this patch out to my tree ASAP.

 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index db8d211..2390ddb 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -629,7 +629,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
 	read_unlock(&devtree_lock);
 	return np;
 }
-EXPORT_SYMBOL(of_find_matching_node);
+EXPORT_SYMBOL(of_find_matching_node_and_match);
 
 /**
  * of_modalias_node - Lookup appropriate modalias for a device node
-- 
1.7.10.4

