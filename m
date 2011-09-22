Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1IVKnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:43:47 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41481 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab1IVKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:43:41 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>
Subject: [PATCH 2/3] dmaengine/dw_dmac: Set channel id's in controller driver
Date: Thu, 22 Sep 2011 16:13:13 +0530
Message-ID: <18c4b49c4949d7a5cb482187d1faa08178bbcb1e.1316687776.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
References: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw_dmac may conditionally add channels in reverse order inside channel list in
struct dma_device. So, we must set chan_id's here and pass this to dmaengine, so
that it doesn't override these values.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3550042..e2c8e4e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1397,6 +1397,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
 	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
+	dw->dma.chan_ids_set = true;
 
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < pdata->nr_channels; i++) {
@@ -1404,6 +1405,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 		dwc->chan.device = &dw->dma;
 		dwc->chan.cookie = dwc->completed = 1;
+		dwc->chan.chan_id = i;
 		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
 			list_add_tail(&dwc->chan.device_node,
 					&dw->dma.channels);
-- 
1.7.2.2

