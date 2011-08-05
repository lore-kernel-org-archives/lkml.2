Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1HEKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:08:22 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47196 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab1HEKDw (ORCPT
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
Subject: [PATCH V3 10/20] dmaengine/amba-pl08x: No need to check "ch->signal < 0"
Date: Fri, 5 Aug 2011 15:32:35 +0530
Message-ID: <3f2bc035f4f7285c30636fae97630f365d69978c.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have just executed following in pl08x_get_phy_channel():
	ch->signal = -1;

We don't have to compare "ch->signal < 0", as this will always be true.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d79688d..3653961 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -916,7 +916,7 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 	 * need, but for slaves the physical signals may be muxed!
 	 * Can the platform allow us to use this channel?
 	 */
-	if (plchan->slave && ch->signal < 0 && pl08x->pd->get_signal) {
+	if (plchan->slave && pl08x->pd->get_signal) {
 		ret = pl08x->pd->get_signal(plchan);
 		if (ret < 0) {
 			dev_dbg(&pl08x->adev->dev,
-- 
1.7.2.2

