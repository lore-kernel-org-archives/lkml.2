Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2ARJM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:12:57 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:35331 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab2ARJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:12:51 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V2 05/12] dmaengine/dw_dmac: Don't use magic number for total number of channels
Date: Wed, 18 Jan 2012 14:41:52 +0530
Message-ID: <0bd6490c26e9b4cb56ea585a76d31b8a34101220.1326876464.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
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

