Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1LNPwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:52:23 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:7253
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756627Ab1LNPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:52:20 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 1/4] dt: add of_get_child_number helper function
Date: Thu, 15 Dec 2011 00:03:39 +0800
Message-ID: <1323878622-26602-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323878622-26602-1-git-send-email-b29396@freescale.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Currently most code to get child number in kernel are almost same,
add a helper to implement this function for dt to use.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 4948552..09d53dc 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -189,6 +189,18 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
 	for (child = of_get_next_child(parent, NULL); child != NULL; \
 	     child = of_get_next_child(parent, child))
 
+static inline int of_get_child_number(struct device_node *np)
+
+{
+	struct device_node *child = NULL;
+	int num = 0;
+
+	while((child = of_get_next_child(np, child)))
+		num++;
+
+	return num;
+}
+
 extern struct device_node *of_find_node_with_property(
 	struct device_node *from, const char *prop_name);
 #define for_each_node_with_property(dn, prop_name) \
@@ -262,6 +274,11 @@ static inline bool of_have_populated_dt(void)
 #define for_each_child_of_node(parent, child) \
 	while (0)
 
+static inline int of_get_child_number(struct device_node *np)
+{
+	return -ENOSYS;
+}
+
 static inline int of_device_is_compatible(const struct device_node *device,
 					  const char *name)
 {
-- 
1.7.0.4


