Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1DZFif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:38:35 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:54837 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab1DZFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:38:34 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 resend 5/7] dmaengine/dw_dmac: set residue as total len in dwc_tx_status if status is !DMA_SUCCESS
Date: Tue, 26 Apr 2011 11:08:13 +0530
Message-ID: <5f84099ec16a3086efa6474d9239f62d0d868f49.1303796005.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303796005.git.viresh.kumar@st.com>
References: <cover.1303796005.git.viresh.kumar@st.com>
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
index 8d5d048..211728c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -864,7 +864,11 @@ dwc_tx_status(struct dma_chan *chan,
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

