Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab1CDKNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:13:16 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42068 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759241Ab1CDKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:13:15 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, <shiraz.hashim@st.com>,
        <armando.visconti@st.com>, <amit.goel@st.com>, <jamie@jamieiles.com>,
        <hans-christian.egtvedt@atmel.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 06/13 resend] dw_dmac: Change value of DWC_MAX_COUNT to 4095.
Date: Fri, 4 Mar 2011 15:42:50 +0530
Message-ID: <201c75549049c9259327056d65b60525923f3d8a.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every descriptor can transfer a maximum count of 4095 (12 bits, in control reg),
So we must have DWC_MAX_COUNT as 4095 instead of 2048.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e5d97bf..711ebe9 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -47,14 +47,13 @@
 
 /*
  * This is configuration-dependent and usually a funny size like 4095.
- * Let's round it down to the nearest power of two.
  *
  * Note that this is a transfer count, i.e. if we transfer 32-bit
- * words, we can do 8192 bytes per descriptor.
+ * words, we can do 16380 bytes per descriptor.
  *
  * This parameter is also system-specific.
  */
-#define DWC_MAX_COUNT	2048U
+#define DWC_MAX_COUNT	4095U
 
 /*
  * Number of descriptors to allocate for each channel. This should be
-- 
1.7.2.2

