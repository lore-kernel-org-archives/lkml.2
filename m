Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1BSDOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 22:14:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8732 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1BSDOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 22:14:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6261"; a="75197504"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: headsmp.S: Fix section mismatch
Date: Fri, 18 Feb 2011 19:14:09 -0800
Message-Id: <1298085249-10518-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.26.g00e6e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.cpuinit.text+0xc80): Section mismatch in
reference from the function boot_secondary() to the variable
.init.text:msm_secondary_startup
The function __cpuinit boot_secondary() references a variable
__init msm_secondary_startup.  If msm_secondary_startup is only
used by boot_secondary then annotate msm_secondary_startup with
a matching annotation.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/headsmp.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/headsmp.S b/arch/arm/mach-msm/headsmp.S
index d0c2143..0c631a9 100644
--- a/arch/arm/mach-msm/headsmp.S
+++ b/arch/arm/mach-msm/headsmp.S
@@ -11,7 +11,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__INIT
+	__CPUINIT
 
 /*
  * MSM specific entry point for secondary CPUs.  This provides
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

