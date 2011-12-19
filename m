Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1LSEbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:31:45 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:47645 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab1LSEbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:31:20 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V1 Resend 2/3] dmaengine/dw_dmac: Set channel id's in controller driver
Date: Mon, 19 Dec 2011 10:00:59 +0530
Message-ID: <f623b2b26a6236418a9fced145e2541b626809de.1324268691.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1324268691.git.viresh.kumar@st.com>
References: <cover.1324268691.git.viresh.kumar@st.com>
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
index 9b592b0..35c8829 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1417,6 +1417,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
 	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
+	dw->dma.chan_ids_set = true;
 
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < pdata->nr_channels; i++) {
@@ -1424,6 +1425,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 		dwc->chan.device = &dw->dma;
 		dwc->chan.cookie = dwc->completed = 1;
+		dwc->chan.chan_id = i;
 		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
 			list_add_tail(&dwc->chan.device_node,
 					&dw->dma.channels);
-- 
1.7.8.110.g4cb5d

