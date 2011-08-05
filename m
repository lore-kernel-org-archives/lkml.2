Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1HEKEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:04:01 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:47817 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab1HEKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:54 -0400
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
Subject: [PATCH V3 07/20] dmaengine/amba-pl08x: Changing few prints to dev_dbg from dev_info
Date: Fri, 5 Aug 2011 15:32:32 +0530
Message-ID: <49528b8e03fdb19f458b979da32c092ee0aa7dc0.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 8 memory and 16 slave channels 35 boot print lines are printed. And that is
too much. Most of this would be more useful for debugging. So moving few of them
to dev_dbg instead of dev_info. Now only 3 prints will be printed.

This also rearrange one of the debug message to fit into two lines.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6c52959..ead88c9 100644
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
 
@@ -1945,9 +1945,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		spin_lock_init(&ch->lock);
 		ch->serving = NULL;
 		ch->signal = -1;
-		dev_info(&adev->dev,
-			 "physical channel %d is %s\n", i,
-			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
+		dev_dbg(&adev->dev, "physical channel %d is %s\n",
+			i, pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
 	}
 
 	/* Register as many memcpy channels as there are physical channels */
-- 
1.7.2.2

