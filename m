Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab1KBSk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:40:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378Ab1KBShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707007"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 26/34] msm: 8660: Add FLUID support
Date: Wed,  2 Nov 2011 11:36:23 -0700
Message-Id: <1320258991-22325-27-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The machine descriptor for FLUID was missing. Adding it allows us
to boot FLUID devices since the basic support for 8660 is the
same.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    6 ++++++
 arch/arm/mach-msm/board-msm8x60.c |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index ebde97f..57c0ae2 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -138,6 +138,12 @@ config MACH_MSM8X60_FFA
 	help
 	  Support for the Qualcomm MSM8x60 FFA eval board.
 
+config MACH_MSM8X60_FLUID
+	depends on ARCH_MSM8X60
+	bool "MSM8x60 FLUID"
+	help
+	  Support for the Qualcomm MSM8x60 FLUID board.
+
 config MACH_MSM8960_SIM
 	depends on ARCH_MSM8960
 	bool "MSM8960 Simulator"
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index a6bfc91..7b8016f 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -116,3 +116,11 @@ MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8X60_FLUID, "QCT MSM8X60 FLUID")
+	.map_io = msm8x60_map_io,
+	.init_early = msm8x60_init_early,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_init,
+	.timer = &msm_timer,
+MACHINE_END
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

