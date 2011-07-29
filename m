Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1G2Kv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:51:56 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:47479 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab1G2KuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:15 -0400
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
Subject: [PATCH 06/18] dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
Date: Fri, 29 Jul 2011 16:19:16 +0530
Message-ID: <88035b0bd1f3fd755b6a157193c39477e21ec60a.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
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
---
 drivers/dma/amba-pl08x.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 56a9670..53d722e 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1505,13 +1505,7 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
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

