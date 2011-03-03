Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1CCKSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:18 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53743 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1CCKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:16 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 02/13] dw_dmac: Replace module_init() with subsys_initcall()
Date: Thu, 3 Mar 2011 15:47:15 +0530
Message-ID: <28e0a75c609f8ab901824f95704600ec29eb8548.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases users of dw_dmac are initialized before dw_dmac, and if they try
to use dw_dmac, they simply fail. So its better we register init() routine
of driver using subsys_initcall() instead of module_init(), so that dma driver
is available at the earliest possible.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 08dab3b..064a183 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1455,7 +1455,7 @@ static int __init dw_init(void)
 {
 	return platform_driver_probe(&dw_driver, dw_probe);
 }
-module_init(dw_init);
+subsys_initcall(dw_init);
 
 static void __exit dw_exit(void)
 {
-- 
1.7.2.2

