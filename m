Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2EWGv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:51:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8747 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2EWGv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:51:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 22 May 2012 23:51:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 1/2] dma: dmaengine: add slave req id in slave_config
Date: Wed, 23 May 2012 12:15:41 +0530
Message-ID: <1337755542-16271-1-git-send-email-ldewangan@nvidia.com>
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

No Changes from V3.

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

