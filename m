Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2CXJXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:23:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53856 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2CXJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:22:52 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-72-4f6d926a3f2f
From: Thomas Abraham <thomas.abraham@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca, patches@linaro.org
Subject: [PATCH] of/irq: add empty irq_of_parse_and_map() for non-dt builds
Date: Sat, 24 Mar 2012 14:57:37 +0530
Message-id: <1332581257-15989-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a empty irq_of_parse_and_map() that returns 0 for non-dt builds and
avoid having #ifdef CONFIG_OF around all calls to irq_of_parse_and_map().

Suggested-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 include/linux/of_irq.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index d229ad3..5614355 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -76,5 +76,11 @@ extern struct device_node *of_irq_find_parent(struct device_node *child);
 extern void of_irq_init(const struct of_device_id *matches);
 
 #endif /* CONFIG_OF_IRQ */
+#else /* CONFIG_OF */
+static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
+						int index)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 #endif /* __OF_IRQ_H */
-- 
1.6.6.rc2

