Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707Ab2ILRB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:01:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2ILQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521485"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 24/24] ARM: msm: Allow 8960 and 8660 to compile together
Date: Wed, 12 Sep 2012 09:59:00 -0700
Message-Id: <1347469140-25069-25-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Modify the Kconfig to allow the MSM 8660 and MSM 8960 targets to
compile together in the same build. As long as one of these two
targets is selected the choice menu used to select which SoC to
support will be hidden. Deselecting both of these targets will
reintroduce the choice menu, and allow users to select targets
that must be compiled in isolation.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
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

