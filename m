Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1CCKSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:35 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:46970 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757792Ab1CCKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:30 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 05/13] dw_dmac: Adding support for 64 bit access width for memcpy xfers
Date: Thu, 3 Mar 2011 15:47:18 +0530
Message-ID: <42625509e43721a26cc70e9f5fe16d0b93ebff84.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2b0d5e9..e5d97bf 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -583,7 +583,9 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
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

