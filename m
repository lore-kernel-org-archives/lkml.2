Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1HEKFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:05:46 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:40975 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab1HEKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:59 -0400
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
Subject: [PATCH V3 06/20] dmaengine/amba-pl08x: Remove redundant comment and rewrite original
Date: Fri, 5 Aug 2011 15:32:31 +0530
Message-ID: <182e51a0dac3661a7095daaa310d2302818ecbf4.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar comment is present over routine also pl08x_choose_master_bus(). Keeping
one of them. Also rewrite that comment to convey message clearly.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 01c2f50..6c52959 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -497,9 +497,13 @@ struct pl08x_lli_build_data {
 };
 
 /*
- * Autoselect a master bus to use for the transfer this prefers the
- * destination bus if both available if fixed address on one bus the
- * other will be chosen
+ * Autoselect a master bus to use for the transfer. Slave will be the chosen as
+ * victim in case src & dest are not similarly aligned. i.e. If after aligning
+ * masters address with width requirements of transfer (by sending few byte by
+ * byte data), slave is still not aligned, then its width will be reduced to
+ * BYTE.
+ * - prefers the destination bus if both available
+ * - if fixed address on one bus the other will be chosen
  */
 static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
 	struct pl08x_bus_data **mbus, struct pl08x_bus_data **sbus, u32 cctl)
@@ -625,11 +629,6 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	/* We need to count this down to zero */
 	bd.remainder = txd->len;
 
-	/*
-	 * Choose bus to align to
-	 * - prefers destination bus if both available
-	 * - if fixed address on one bus chooses other
-	 */
 	pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
 
 	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu llimax=%zu\n",
-- 
1.7.2.2

