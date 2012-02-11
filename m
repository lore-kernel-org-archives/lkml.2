Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2BKRWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 12:22:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56103 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2BKRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 12:22:22 -0500
MIME-Version: 1.0
From: Dong Aisheng <dong.aisheng@linaro.org>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: [PATCH V3 1/1] dt: add of_get_child_count helper function
Date: Sat, 11 Feb 2012 09:22:09 -0800
Message-Id: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently most code to get child count in kernel are almost same,
add a helper to implement this function for dt to use.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>

---
Hi Rob,

Since my imx pinctrl driver series still depends on the pinctrl core dt
binding patch which is still not in mainline, i'd like this pure dt patch
go separately first in case others want to use.

changes v2->v3:
 Addressed some people's comments:
 * do not use assignment as expression
 * return 0 for non-dt case

Changes v1->v2:
 * change the name from of_get_child_number to of_get_child_count
---
 include/linux/of.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index a75a831..ae242ef 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -195,6 +195,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
 	for (child = of_get_next_child(parent, NULL); child != NULL; \
 	     child = of_get_next_child(parent, child))
 
+static inline int of_get_child_count(const struct device_node *np)
+{
+	struct device_node *child = NULL;
+	int num = 0;
+
+	while ((child = of_get_next_child(np, child)) != NULL)
+		num++;
+
+	return num;
+}
+
 extern struct device_node *of_find_node_with_property(
 	struct device_node *from, const char *prop_name);
 #define for_each_node_with_property(dn, prop_name) \
@@ -268,6 +279,11 @@ static inline bool of_have_populated_dt(void)
 #define for_each_child_of_node(parent, child) \
 	while (0)
 
+static inline int of_get_child_count(const struct device_node *np)
+{
+	return 0;
+}
+
 static inline int of_device_is_compatible(const struct device_node *device,
 					  const char *name)
 {
-- 
1.7.5.4

