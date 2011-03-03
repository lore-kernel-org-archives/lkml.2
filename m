Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab1CCKTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:19:09 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46263 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218Ab1CCKTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:19:07 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 12/13] dw_dmac: Setting Default Burst length for transfers as 16.
Date: Thu, 3 Mar 2011 15:47:25 +0530
Message-ID: <4f478a7a897ffead93f71574f74b178533dde647.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets default Burst length for all transfer to 16. This will
enhance performance when user doesn't have any chan->private data.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5f5b28b..cf07539 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -36,8 +36,8 @@
 		struct dw_dma_slave *__slave = (private);	\
 		int dms = __slave ? __slave->dst_master : 0;	\
 		int sms = __slave ? __slave->src_master : 1;	\
-		u8 smsize = __slave ? __slave->src_msize : 0;	\
-		u8 dmsize = __slave ? __slave->dst_msize : 0;	\
+		u8 smsize = __slave ? __slave->src_msize : DW_DMA_MSIZE_16; \
+		u8 dmsize = __slave ? __slave->dst_msize : DW_DMA_MSIZE_16; \
 								\
 		(DWC_CTLL_DST_MSIZE(dmsize)			\
 		 | DWC_CTLL_SRC_MSIZE(smsize)			\
-- 
1.7.2.2

