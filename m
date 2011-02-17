Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1BQHoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:44:23 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:58801 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab1BQHoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:44:21 -0500
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Feb 2011 02:44:20 EST
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: [PATCH 3/7] dw_dmac: call dwc_scan_descriptor from dwc_issue_pending only if active list is empty
Date: Thu, 17 Feb 2011 12:54:53 +0530
Message-ID: <9e85d47d1c8f0a4978f69a9ffb60b5674954954e.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh KUMAR <viresh.kumar@st.com>

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

