Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1IVKn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:43:58 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:42782 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab1IVKnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:43:46 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>
Subject: [PATCH 3/3] dmaengine/dw_dmac: Don't use magic number for total number of channels
Date: Thu, 22 Sep 2011 16:13:14 +0530
Message-ID: <96428d0d7e086ea4fb765c618209a0cd1259b843.1316687776.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
References: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Total number of channels is passed in pdata->nr_channels variable, thus we must
not use magic number '7' for total number of channels.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e2c8e4e..4010044 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1414,7 +1414,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = 7 - i;
+			dwc->priority = pdata->nr_channels - i - 1;
 		else
 			dwc->priority = i;
 
-- 
1.7.2.2

