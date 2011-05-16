Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab1EPEur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 00:50:47 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46589 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab1EPEuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 00:50:46 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linus.walleij@linaro.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
Date: Mon, 16 May 2011 10:20:25 +0530
Message-ID: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases users of dw_dmac, amba-pl022, are initialized before dw_dmac, and
if they try to use dw_dmac, they simply fail. So its better we register init()
routine of driver using arch_initcall() instead of subsys_init(), so that dma
driver is available at the earliest possible.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 54d72a8..4b580e7 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1566,7 +1566,7 @@ static int __init dw_init(void)
 {
 	return platform_driver_probe(&dw_driver, dw_probe);
 }
-subsys_initcall(dw_init);
+arch_initcall(dw_init);
 
 static void __exit dw_exit(void)
 {
-- 
1.7.2.2

