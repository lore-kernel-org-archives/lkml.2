Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1HAJk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:40:27 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:38915 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668Ab1HAJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:49 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 19/20] dmaengine/amba-pl08x: Check txd->llis_va before freeing dma_pool
Date: Mon, 1 Aug 2011 15:07:29 +0530
Message-ID: <ac7230fffb2629b8a745b90d6c2d6e6d59d78794.1312190882.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pl08x_free_txd(), check if pool is allocated successfully before freeing it.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index adc8a36..2667e0d 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -796,7 +796,8 @@ static void pl08x_free_txd(struct pl08x_driver_data *pl08x,
 	struct pl08x_sg *dsg, *_dsg;
 
 	/* Free the LLI */
-	dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
+	if (txd->llis_va)
+		dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
 
 	pl08x->pool_ctr--;
 
-- 
1.7.2.2

