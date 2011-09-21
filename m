Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1IUNBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:01:47 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:54612 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725Ab1IUNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:01:46 -0400
From: Daniel Drake <dsd@laptop.org>
To: grant.likely@secretlab.ca
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: dilinger@queued.net
Subject: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-Id: <20110921120148.4A81E9D401D@zog.reactivated.net>
Date: Wed, 21 Sep 2011 13:01:48 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=kX7dJ6wq7ZoA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=voM4FWlXAAAA:8 a=QliyG-FOrziHDn0fbTAA:9 a=X1LegjBGojUIUF5_SVMA:7 a=TPvuGpIR9P0A:10 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a mfd_cell to be linked with a device tree node, which
then allows child drivers to have easy access to that handle.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/mfd/mfd-core.c   |    1 +
 include/linux/mfd/core.h |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

I think this is what is being suggested at 
http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-September/008235.html

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0902523..7d22dcd 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -87,6 +87,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.of_node = cell->of_node;
 
 	if (cell->pdata_size) {
 		ret = platform_device_add_data(pdev,
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 4e76163..9b836f9 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -15,6 +15,7 @@
 #define MFD_CORE_H
 
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 /*
  * This struct describes the MFD part ("cell").
@@ -37,6 +38,9 @@ struct mfd_cell {
 	void			*platform_data;
 	size_t			pdata_size;
 
+	/* association with device tree node (optional) */
+	struct device_node	*of_node;
+
 	/*
 	 * These resources can be specified relative to the parent device.
 	 * For accessing hardware you should use resources from the platform dev
-- 
1.7.6.2

