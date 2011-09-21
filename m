Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1IUTXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:23:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51534 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1IUTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:23:21 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dt: add empty for_each_child_of_node, of_find_property
Date: Wed, 21 Sep 2011 13:23:10 -0600
Message-Id: <1316632990-12876-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds a couple empty functions for non-dt build, so that
drivers migrating to dt can save some '#ifdef CONFIG_OF'.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Unfortunately, I screwed up and my recent sdhci-tegra.c changes rely on this
change to compile without CONFIG_OF; I really need to stop doing my test-
builds in a single branch will all my outstanding changes present:-(

 include/linux/of.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 9180dc5..1fc5875 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -242,6 +242,16 @@ static inline bool of_have_populated_dt(void)
 	return false;
 }
 
+#define for_each_child_of_node(parent, child) \
+	while (0)
+
+static inline struct property *of_find_property(const struct device_node *np,
+						const char *name,
+						int *lenp)
+{
+	return NULL;
+}
+
 static inline int of_property_read_u32_array(const struct device_node *np,
 					     const char *propname,
 					     u32 *out_values, size_t sz)
-- 
1.7.0.4

