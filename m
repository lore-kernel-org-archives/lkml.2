Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2APJvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:40 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:36066 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab2APJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:36 -0500
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
Subject: [PATCH 5/8] dmaengine/dw_dmac: Use platform_get_drvdata instead of accessing dev directly
Date: Mon, 16 Jan 2012 15:20:33 +0530
Message-ID: <51d3263224d48c1d68de1449af28fb1570900254.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use already defined function platform_get_drvdata() instead of accessing
pdev->dev.data.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1577394..f061daa 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1369,7 +1369,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	int			err;
 	int			i;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
 		return -EINVAL;
 
-- 
1.7.8.110.g4cb5d

