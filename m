Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1LTRmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:42:32 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21460 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1LTRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:42:27 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 1/1] dt: reform for_each_property to for_each_property_of_node_of_node
Date: Wed, 21 Dec 2011 01:51:58 +0800
Message-ID: <1324403518-3462-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Make this micro more easy to use(do not need to pass properties, a node is
enough), also change to a more sensible name as for_each_child_of_node.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
---
 drivers/of/base.c  |    2 +-
 include/linux/of.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 9b6588e..f6f6fe8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1159,7 +1159,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 	if (!of_aliases)
 		return;
 
-	for_each_property(pp, of_aliases->properties) {
+	for_each_property_of_node(of_aliases, pp) {
 		const char *start = pp->name;
 		const char *end = start + strlen(start);
 		struct device_node *np;
diff --git a/include/linux/of.h b/include/linux/of.h
index 4948552..f1a490c 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -219,8 +219,8 @@ extern int of_device_is_available(const struct device_node *device);
 extern const void *of_get_property(const struct device_node *node,
 				const char *name,
 				int *lenp);
-#define for_each_property(pp, properties) \
-	for (pp = properties; pp != NULL; pp = pp->next)
+#define for_each_property_of_node(dn, pp) \
+	for (pp = dn->properties; pp != NULL; pp = pp->next)
 
 extern int of_n_addr_cells(struct device_node *np);
 extern int of_n_size_cells(struct device_node *np);
-- 
1.7.0.4


