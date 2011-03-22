Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1CVL5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:57:48 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:52991 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab1CVL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:57:45 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <shiraz.hashim@st.com>, <armando.visconti@st.com>, <amit.goel@st.com>,
        <ajay.khandelwal@st.com>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dmaengine/dmatest: Pass timeout via module params
Date: Tue, 22 Mar 2011 17:27:25 +0530
Message-ID: <f4a301c8c917e98f44bd380aa94a51c3c4750f1c.1300794846.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to test all channels present on our controller together, some
channels of lower priority may be very slow as compared to others. If number of
transfers is unlimited, some channels may timeout and will not finish within 3
seconds. Thus, while doing such regress testing we may need to have higher value
of timeouts. This patch adds support for passing timeout value via module
parameters. Default value is 3 msec, a negative value means max timeout
possible.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dmatest.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 5589358..99394bb 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -54,6 +54,11 @@ module_param(pq_sources, uint, S_IRUGO);
 MODULE_PARM_DESC(pq_sources,
 		"Number of p+q source buffers (default: 3)");
 
+static int timeout = 3000;
+module_param(timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), \
+		Pass -1 for infinite timeout");
+
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
  * set, all bytes in the destination buffer has bit 7 cleared.
@@ -294,7 +299,7 @@ static int dmatest_func(void *data)
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
 		struct completion cmp;
-		unsigned long tmo = msecs_to_jiffies(3000);
+		unsigned long tmo = msecs_to_jiffies(timeout);
 		u8 align = 0;
 
 		total_tests++;
-- 
1.7.2.2

