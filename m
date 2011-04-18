Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1DRKux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:50:53 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:58345 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1DRKuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:50:46 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <jamie@jamieiles.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 5/6] dmaengine/dw_dmac: set residue as total len in dwc_tx_status if status is !DMA_SUCCESS
Date: Mon, 18 Apr 2011 16:20:03 +0530
Message-ID: <6264b8d24bf15b8aaff86c4d3fe8df5f777c552c.1303123511.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If transfer status is !=DMA_SUCCESS, return total transfer len as residue,
instead of zero.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9d8ed35..92f4cb0 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -870,7 +870,11 @@ dwc_tx_status(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	dma_set_tx_state(txstate, last_complete, last_used, 0);
+	if (ret != DMA_SUCCESS)
+		dma_set_tx_state(txstate, last_complete, last_used,
+				dwc_first_active(dwc)->len);
+	else
+		dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return ret;
 }
-- 
1.7.2.2

