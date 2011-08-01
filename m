Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1HAJj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:39:58 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:39849 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407Ab1HAJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:24 -0400
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
Subject: [PATCH V2 09/20] dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
Date: Mon, 1 Aug 2011 15:07:19 +0530
Message-ID: <e55c1235b79772d2f8f33e487fa272b3dd7d3604.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply writing 1 on bit 0 is sufficient instead of reading and clearing bits.
Also as per manual, for bit 3-31 of DMACConfiguration register:
"read undefined, write as 0"

So, we must not rely on values read from this registers bit 3-31.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 428a67b..da17249 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1507,13 +1507,7 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
  */
 static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
 {
-	u32 val;
-
-	val = readl(pl08x->base + PL080_CONFIG);
-	val &= ~(PL080_CONFIG_M2_BE | PL080_CONFIG_M1_BE | PL080_CONFIG_ENABLE);
-	/* We implicitly clear bit 1 and that means little-endian mode */
-	val |= PL080_CONFIG_ENABLE;
-	writel(val, pl08x->base + PL080_CONFIG);
+	writel(PL080_CONFIG_ENABLE, pl08x->base + PL080_CONFIG);
 }
 
 static void pl08x_unmap_buffers(struct pl08x_txd *txd)
-- 
1.7.2.2

