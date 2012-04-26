Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2DZOa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:30:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20601 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2DZOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:30:54 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <cjb@laptop.org>, <b20223@freescale.com>
Subject: [PATCH v4 1/4] dt: add of_get_child_count helper function
Date: Thu, 26 Apr 2012 22:40:24 +0800
Message-ID: <1335451227-27709-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Currently most code to get child count in kernel are almost same,
add a helper to implement this function for dt to use.

Cc: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
Rob missed this patch for 3.4 kernel.
Based on Rob's suggestion, we can get it go in with pinctrl driver.
Since Rob once had applied it, i added Rob's ack.
See:
https://lkml.org/lkml/2012/4/14/239

changes v3->v4:
 * addressed Grant's suggestion to use for_each_child_of_node.

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
index e3f942d..1c14976 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -193,6 +193,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
 	for (child = of_get_next_child(parent, NULL); child != NULL; \
 	     child = of_get_next_child(parent, child))
 
+static inline int of_get_child_count(const struct device_node *np)
+{
+	struct device_node *child = NULL;
+	int num = 0;
+
+	for_each_child_of_node(np, child)
+		num++;
+
+	return num;
+}
+
 extern struct device_node *of_find_node_with_property(
 	struct device_node *from, const char *prop_name);
 #define for_each_node_with_property(dn, prop_name) \
@@ -300,6 +311,11 @@ static inline bool of_have_populated_dt(void)
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
1.7.0.4


