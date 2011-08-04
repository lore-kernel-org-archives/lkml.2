Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1HDJyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:54:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26849 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1HDJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:53:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6427"; a="108040625"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] of/address: Add of_iomap_nocache
Date: Thu,  4 Aug 2011 02:53:49 -0700
Message-Id: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add uncached mappings from devicetree nodes similar to regular io
mappings.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/of/address.c       |   19 +++++++++++++++++++
 include/linux/of_address.h |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 72c33fb..9bee7f8 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -613,3 +613,22 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
+
+/**
+ * of_iomap_nocache - Maps the memory mapped IO for a given
+ *                    device_node, using ioremap_nocache.
+ * @device:	the device whose io range will be mapped
+ * @index:	index of the io range
+ *
+ * Returns a pointer to the mapped memory
+ */
+void __iomem *of_iomap_nocache(struct device_node *np, int index)
+{
+	struct resource res;
+
+	if (of_address_to_resource(np, index, &res))
+		return NULL;
+
+	return ioremap_nocache(res.start, 1 + res.end - res.start);
+}
+EXPORT_SYMBOL(of_iomap_nocache);
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 3118623..3ce1277 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -12,6 +12,7 @@ extern struct device_node *of_find_matching_node_by_address(
 					const struct of_device_id *matches,
 					u64 base_address);
 extern void __iomem *of_iomap(struct device_node *device, int index);
+extern void __iomem *of_iomap_nocache(struct device_node *device, int index);
 
 /* Extract an address from a device, returns the region size and
  * the address space flags too. The PCI version uses a BAR number
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

