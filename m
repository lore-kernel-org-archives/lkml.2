Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2ECHoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:44:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4616 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2ECHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:44:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 May 2012 00:44:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] dma: dmaengine: add slave req id in slave_config
Date: Thu,  3 May 2012 13:11:28 +0530
Message-Id: <1336030889-32269-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma controller like Nvidia's Tegra Dma controller
supports the different slave requestor id from different slave.
This need to be configure in dma controller to handle the request
properly.

Adding the slave-id in the slave configuration so that information
can be passed from client when configuring for slave.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---

This change is require to get rid of tegra_dma header to pass the
slave requestor id.

 include/linux/dmaengine.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1082698..b0b275f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -338,6 +338,9 @@ enum dma_slave_buswidth {
  * @device_fc: Flow Controller Settings. Only valid for slave channels. Fill
  * with 'true' if peripheral should be flow controller. Direction will be
  * selected at Runtime.
+ * @slave_id: Slave requester id. Only valid for slave channels. The dma
+ * slave peripheral will have unique id as dma requester which need to be
+ * pass as slave config.
  *
  * This struct is passed in as configuration data to a DMA engine
  * in order to set up a certain channel for DMA transport at runtime.
@@ -365,6 +368,7 @@ struct dma_slave_config {
 	u32 src_maxburst;
 	u32 dst_maxburst;
 	bool device_fc;
+	int slave_id;
 };
 
 static inline const char *dma_chan_name(struct dma_chan *chan)
-- 
1.7.1.1

