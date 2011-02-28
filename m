Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1B1KmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:42:25 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:55797 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506Ab1B1KmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:42:23 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 4/8 resend] dw_dmac: calling dwc_scan_descriptors from dwc_tx_status() after taking lock
Date: Mon, 28 Feb 2011 16:11:19 +0530
Message-ID: <725d9e629bce9f79d87bdab4596a5088b70ea416.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
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

