Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1HEKI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:08:29 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:41284 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab1HEKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:52 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <alim.akhtar@gmail.com>
Subject: [PATCH V3 19/20] dmaengine/amba-pl08x: Check txd->llis_va before freeing dma_pool
Date: Fri, 5 Aug 2011 15:32:44 +0530
Message-ID: <4ef4f1c757c02b89fd2cce6775318a417c2626bb.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
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
index e4e7969..4d2aedc 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -800,7 +800,8 @@ static void pl08x_free_txd(struct pl08x_driver_data *pl08x,
 	struct pl08x_sg *dsg, *_dsg;
 
 	/* Free the LLI */
-	dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
+	if (txd->llis_va)
+		dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
 
 	pl08x->pool_ctr--;
 
-- 
1.7.2.2

