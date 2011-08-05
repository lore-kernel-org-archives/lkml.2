Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1HEKIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:08:21 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37946 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609Ab1HEKDw (ORCPT
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
Subject: [PATCH V3 04/20] dmaengine/amba-pl08x: pass (*ptr) to sizeof() instead of (struct xyz)
Date: Fri, 5 Aug 2011 15:32:29 +0530
Message-ID: <064fabdf1ceca5437e6df8c94e3d4cd1538e7c41.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in Documentation/CodingStyle,

The preferred form for passing a size of a struct is the following:
   p = kmalloc(sizeof(*p), ...);

The alternative form where struct name is spelled out hurts readability and
introduces an opportunity for a bug when the pointer variable type is changed
but the corresponding sizeof that is passed to a memory allocator is not.

This patch replaces (struct xyz) with *ptr at several occurrences in driver.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 8e2056b..01c2f50 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1293,7 +1293,7 @@ static int pl08x_prep_channel_resources(struct pl08x_dma_chan *plchan,
 static struct pl08x_txd *pl08x_get_txd(struct pl08x_dma_chan *plchan,
 	unsigned long flags)
 {
-	struct pl08x_txd *txd = kzalloc(sizeof(struct pl08x_txd), GFP_NOWAIT);
+	struct pl08x_txd *txd = kzalloc(sizeof(*txd), GFP_NOWAIT);
 
 	if (txd) {
 		dma_async_tx_descriptor_init(&txd->tx, &plchan->chan);
@@ -1690,7 +1690,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 	 * to cope with that situation.
 	 */
 	for (i = 0; i < channels; i++) {
-		chan = kzalloc(sizeof(struct pl08x_dma_chan), GFP_KERNEL);
+		chan = kzalloc(sizeof(*chan), GFP_KERNEL);
 		if (!chan) {
 			dev_err(&pl08x->adev->dev,
 				"%s no memory for channel\n", __func__);
@@ -1850,7 +1850,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		return ret;
 
 	/* Create the driver state holder */
-	pl08x = kzalloc(sizeof(struct pl08x_driver_data), GFP_KERNEL);
+	pl08x = kzalloc(sizeof(*pl08x), GFP_KERNEL);
 	if (!pl08x) {
 		ret = -ENOMEM;
 		goto out_no_pl08x;
@@ -1929,7 +1929,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	/* Initialize physical channels */
-	pl08x->phy_chans = kmalloc((vd->channels * sizeof(struct pl08x_phy_chan)),
+	pl08x->phy_chans = kmalloc((vd->channels * sizeof(*pl08x->phy_chans)),
 			GFP_KERNEL);
 	if (!pl08x->phy_chans) {
 		dev_err(&adev->dev, "%s failed to allocate "
-- 
1.7.2.2

