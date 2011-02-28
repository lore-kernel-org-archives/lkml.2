Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1B1KmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:42:09 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:60113 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab1B1KmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:42:07 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 3/8 resend] dw_dmac: call dwc_scan_descriptor from dwc_issue_pending only if active list is empty
Date: Mon, 28 Feb 2011 16:11:18 +0530
Message-ID: <8003205172278ef36cfca1fd50a54cb143fad958.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc_scan_descriptor was called even when there were descriptors in active list.
Checking if active list is empty or not.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 6dd03b0..3bf4772 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -848,7 +848,7 @@ static void dwc_issue_pending(struct dma_chan *chan)
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 
 	spin_lock_bh(&dwc->lock);
-	if (!list_empty(&dwc->queue))
+	if (!list_empty(&dwc->queue) && list_empty(&dwc->active_list))
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
 	spin_unlock_bh(&dwc->lock);
 }
-- 
1.7.2.2

