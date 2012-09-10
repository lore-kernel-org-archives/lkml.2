Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2IJRdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:33:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34323 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2IJRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:33:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6830"; a="232625226"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/9] ARM: msm: Allow 8960 and 8660 to compile together
Date: Mon, 10 Sep 2012 10:33:09 -0700
Message-Id: <1347298389-12567-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c.dirty
In-Reply-To: <1347298389-12567-1-git-send-email-sboyd@codeaurora.org>
References: <1347298389-12567-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the Kconfig to allow the MSM 8660 and MSM 8960 targets to
compile together in the same build. As long as one of these two
targets is selected the choice menu used to select which SoC to
support will be hidden. Deselecting both of these targets will
reintroduce the choice menu, and allow users to select targets
that must be compiled in isolation.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index b2740c8..7902de15 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,8 +1,12 @@
 if ARCH_MSM
 
+comment "Qualcomm MSM SoC Type"
+	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
+
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
+	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -36,6 +40,8 @@ config ARCH_QSD8X50
 	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 
+endchoice
+
 config ARCH_MSM8X60
 	bool "MSM8X60"
 	select ARCH_MSM_SCORPIONMP
@@ -57,8 +63,6 @@ config ARCH_MSM8960
 	select MSM_SCM if SMP
 	select USE_OF
 
-endchoice
-
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

