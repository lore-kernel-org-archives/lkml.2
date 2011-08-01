Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1HAJjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:39:40 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:56111 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab1HAJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:23 -0400
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
Subject: [PATCH V2 07/20] dmaengine/amba-pl08x: Changing few prints to dev_dbg from dev_info
Date: Mon, 1 Aug 2011 15:07:17 +0530
Message-ID: <5752f0202ff197d548999395d68131053693e4b3.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 8 memory and 16 slave channels 35 boot print lines are printed. And that is
too much. Most of this would be more useful for debugging. So moving few of them
to dev_dbg instead of dev_info. Now only 3 prints will be printed.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6c52959..3fbaf0e 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1717,7 +1717,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 			kfree(chan);
 			continue;
 		}
-		dev_info(&pl08x->adev->dev,
+		dev_dbg(&pl08x->adev->dev,
 			 "initialize virtual channel \"%s\"\n",
 			 chan->name);
 
@@ -1945,7 +1945,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		spin_lock_init(&ch->lock);
 		ch->serving = NULL;
 		ch->signal = -1;
-		dev_info(&adev->dev,
+		dev_dbg(&adev->dev,
 			 "physical channel %d is %s\n", i,
 			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
 	}
-- 
1.7.2.2

