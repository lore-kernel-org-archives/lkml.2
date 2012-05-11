Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab2EKLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:06:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7275 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525Ab2EKLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:05:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 11 May 2012 04:05:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/2] dma: dmaengine: add slave req id in slave_config
Date: Fri, 11 May 2012 16:30:43 +0530
Message-ID: <1336734044-14275-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com>
References: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com>
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

 include/linux/dmaengine.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1082698..9732396 100644
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

