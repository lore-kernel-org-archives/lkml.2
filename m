Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1D0Jhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:37:39 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:53123 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756861Ab1D0Jhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:37:36 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 5/7] dmaengine/dw_dmac: set residue as total len in dwc_tx_status if status is !DMA_SUCCESS
Date: Wed, 27 Apr 2011 15:06:47 +0530
Message-ID: <b4e86c79390324e94ef89d71d19e0d6693829b16.1303896567.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303896566.git.viresh.kumar@st.com>
References: <cover.1303896566.git.viresh.kumar@st.com>
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
index 3285ae9..964d2d6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -876,7 +876,11 @@ dwc_tx_status(struct dma_chan *chan,
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
1.7.3.4

