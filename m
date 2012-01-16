Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2APJvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:44 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:46870 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab2APJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:42 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux@arm.linux.org.uk>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH 4/8] dmaengine/dw_dmac: Don't use magic number for total number of channels
Date: Mon, 16 Jan 2012 15:20:32 +0530
Message-ID: <4b7b48a3d581c7e44f494f888f6eb04b6bf52512.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
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
index 3a3d7ed..1577394 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1432,7 +1432,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = 7 - i;
+			dwc->priority = pdata->nr_channels - i - 1;
 		else
 			dwc->priority = i;
 
-- 
1.7.8.110.g4cb5d

