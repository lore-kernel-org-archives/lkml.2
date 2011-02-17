Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1BQH0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:26:07 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36282 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab1BQH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:26:02 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: [PATCH 5/7] dw_dmac: adding support for 64 bit access width for memcpy xfers
Date: Thu, 17 Feb 2011 12:54:55 +0530
Message-ID: <2a9a8a4d0fe4793fcdf4418b7e44c4c08a9c4153.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh KUMAR <viresh.kumar@st.com>

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5cc5abf..c40b89f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -577,7 +577,9 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
-	if (!((src | dest  | len) & 3))
+	if (!((src | dest  | len) & 7))
+		src_width = dst_width = 3;
+	else if (!((src | dest  | len) & 3))
 		src_width = dst_width = 2;
 	else if (!((src | dest | len) & 1))
 		src_width = dst_width = 1;
-- 
1.7.2.2

