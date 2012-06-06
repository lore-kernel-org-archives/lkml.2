Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2FFFdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:33:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8811 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2FFFdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:33:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 05 Jun 2012 22:33:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V5 1/2] dma: dmaengine: add slave req id in slave_config
Date: Wed, 6 Jun 2012 10:55:26 +0530
Message-ID: <1338960327-31453-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA controller like Nvidia's Tegra Dma controller
supports the different slave requestor id from different slave.
This need to be configure in dma controller to handle the request
properly.

Adding the slave-id in the slave configuration so that information
can be passed from client when configuring for slave.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V2: 
- Make slave_id as unsigned.

No Changes from V3 and V4. 

 include/linux/dmaengine.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 56377df..ccec62f 100644
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
+	unsigned int slave_id;
 };
 
 static inline const char *dma_chan_name(struct dma_chan *chan)
-- 
1.7.1.1

