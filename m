Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2ARJNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:13:05 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:42438 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198Ab2ARJNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:13:01 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V2 09/12] dmaengine/dw_dmac: Add 64 bit access width support for slave xfers on mem side
Date: Wed, 18 Jan 2012 14:41:56 +0530
Message-ID: <433a4ffb3a3e9b75a81d97db3dda4c9912288731.1326876464.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64 bit transfers are possible on both sides in slave transfers (memory as well
as peripherals). This patch adds support for it memory side 64 bit transfers.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 49d477c..44d8069 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -756,8 +756,14 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			mem = sg_phys(sg);
 			len = sg_dma_len(sg);
-			mem_width = 2;
-			if (unlikely(mem & 3 || len & 3))
+
+			if (!((mem | len) & 7))
+				mem_width = 3;
+			else if (!((mem | len) & 3))
+				mem_width = 2;
+			else if (!((mem | len) & 1))
+				mem_width = 1;
+			else
 				mem_width = 0;
 
 slave_sg_todev_fill_desc:
@@ -814,8 +820,14 @@ slave_sg_todev_fill_desc:
 
 			mem = sg_phys(sg);
 			len = sg_dma_len(sg);
-			mem_width = 2;
-			if (unlikely(mem & 3 || len & 3))
+
+			if (!((mem | len) & 7))
+				mem_width = 3;
+			else if (!((mem | len) & 3))
+				mem_width = 2;
+			else if (!((mem | len) & 1))
+				mem_width = 1;
+			else
 				mem_width = 0;
 
 slave_sg_fromdev_fill_desc:
-- 
1.7.8.110.g4cb5d

