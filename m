Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1G2Ku3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:50:29 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59448 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756142Ab1G2Ku0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:26 -0400
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
Subject: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment and rewrite original
Date: Fri, 29 Jul 2011 16:19:14 +0530
Message-ID: <e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar comment is present over routine also pl08x_choose_master_bus(). Keeping
one of them. Also rewrite that comment to convey message clearly.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 1f7c510..4a64fdf 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -498,9 +498,9 @@ struct pl08x_lli_build_data {
 };
 
 /*
- * Autoselect a master bus to use for the transfer this prefers the
- * destination bus if both available if fixed address on one bus the
- * other will be chosen
+ * Autoselect a master bus to use for the transfer
+ * - prefers the destination bus if both available
+ * - if fixed address on one bus the other will be chosen
  */
 static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
 	struct pl08x_bus_data **mbus, struct pl08x_bus_data **sbus, u32 cctl)
@@ -626,11 +626,6 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	/* We need to count this down to zero */
 	bd.remainder = txd->len;
 
-	/*
-	 * Choose bus to align to
-	 * - prefers destination bus if both available
-	 * - if fixed address on one bus chooses other
-	 */
 	pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
 
 	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu "
-- 
1.7.2.2

