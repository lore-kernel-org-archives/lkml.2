Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2IQTN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:13:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36760 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2IQTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:13:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6838"; a="237736812"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: Silence warning when CONFIG_MMC=n
Date: Mon, 17 Sep 2012 12:13:22 -0700
Message-Id: <1347909202-14773-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/board-trout.c:67:6: warning: unused variable 'rc'

Just drop the #ifdef and do this unconditionally.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-trout.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 4ba0800..7861c1b 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -67,12 +67,9 @@ static void __init trout_init(void)
 
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
-#ifdef CONFIG_MMC
         rc = trout_init_mmc(system_rev);
         if (rc)
                 printk(KERN_CRIT "%s: MMC init failure (%d)\n", __func__, rc);
-#endif
-
 }
 
 static struct map_desc trout_io_desc[] __initdata = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

