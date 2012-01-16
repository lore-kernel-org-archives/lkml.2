Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2APJvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:32 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:58736 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab2APJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:30 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux@arm.linux.org.uk>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH 2/8] dmaengine: Add flow controller information to dma_slave_config
Date: Mon, 16 Jan 2012 15:20:30 +0530
Message-ID: <5f9ec59562e86536c4123f61891b95590293030f.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flow controller is programmable for few controllers and there are few
intelligent peripherals like, Synopsys JPEG controller, that needs to be a flow
controller of DMA transfers on dest side.

For this, currently two drivers, pl08x and dw_dmac, support flow controller to
be passed from platform to these drivers.

Perhaps, this should be a part of struct dma_slave_config. This patch adds
another field device_fc to this structure. User drivers must pass this as true
if they want to be flow controller of certain transfers.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 include/linux/dmaengine.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5532bb8..dd1915f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -25,6 +25,7 @@
 #include <linux/uio.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
+#include <linux/types.h>
 #include <asm/page.h>
 
 /**
@@ -330,6 +331,9 @@ enum dma_slave_buswidth {
  * may or may not be applicable on memory sources.
  * @dst_maxburst: same as src_maxburst but for destination target
  * mutatis mutandis.
+ * @device_fc: Flow Controller Settings for ccfg register. Only valid for slave
+ * channels. Fill with 'true' if peripheral should be flow controller. Direction
+ * will be selected at Runtime.
  *
  * This struct is passed in as configuration data to a DMA engine
  * in order to set up a certain channel for DMA transport at runtime.
@@ -356,6 +360,7 @@ struct dma_slave_config {
 	enum dma_slave_buswidth dst_addr_width;
 	u32 src_maxburst;
 	u32 dst_maxburst;
+	bool device_fc;
 };
 
 static inline const char *dma_chan_name(struct dma_chan *chan)
-- 
1.7.8.110.g4cb5d

