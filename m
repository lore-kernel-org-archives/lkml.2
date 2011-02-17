Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1BQHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:25:58 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:50173 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab1BQHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:25:56 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 4/7] dw_dmac: calling dwc_scan_descriptors from dwc_tx_status() after taking lock
Date: Thu, 17 Feb 2011 12:54:54 +0530
Message-ID: <2221975299c2fa187f86be691a5a5c27a4cbdf90.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3bf4772..5cc5abf 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -830,7 +830,9 @@ dwc_tx_status(struct dma_chan *chan,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
+		spin_lock_bh(&dwc->lock);
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+		spin_unlock_bh(&dwc->lock);
 
 		last_complete = dwc->completed;
 		last_used = chan->cookie;
-- 
1.7.2.2

