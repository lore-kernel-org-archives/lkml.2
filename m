Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1B1Kme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:42:34 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:41518 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557Ab1B1Kmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:42:33 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 5/8 resend] dw_dmac: adding support for 64 bit access width for memcpy xfers
Date: Mon, 28 Feb 2011 16:11:20 +0530
Message-ID: <3db0ead268f6c53647de07286e3d60332d23abe8.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5cc5abf..c40b89f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -577,7 +577,9 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
-	if (!((src | dest  | len) & 3))
+	if (!((src | dest  | len) & 7))
+		src_width = dst_width = 3;
+	else if (!((src | dest  | len) & 3))
 		src_width = dst_width = 2;
 	else if (!((src | dest | len) & 1))
 		src_width = dst_width = 1;
-- 
1.7.2.2

