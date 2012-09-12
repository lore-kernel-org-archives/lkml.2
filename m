Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2ILQ7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2ILQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521456"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 14/24] ARM: msm: Move 8660 to DT timer
Date: Wed, 12 Sep 2012 09:58:50 -0700
Message-Id: <1347469140-25069-15-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add the timer entry and point the machine descriptor to the
device tree based msm timer.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
[davidb@codeaurora.org: Remove leading zeros]
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts | 19 ++++++++++++++++++-
 arch/arm/mach-msm/board-msm8x60.c  |  2 +-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 45bc4bb..31f2157 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -7,7 +7,7 @@
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
 	interrupt-parent = <&intc>;
 
-	intc: interrupt-controller@02080000 {
+	intc: interrupt-controller@2080000 {
 		compatible = "qcom,msm-8660-qgic";
 		interrupt-controller;
 		#interrupt-cells = <3>;
@@ -15,6 +15,23 @@
 		      < 0x02081000 0x1000 >;
 	};
 
+	timer@2000004 {
+		compatible = "qcom,msm-gpt", "qcom,msm-timer";
+		interrupts = <1 1 0x301>;
+		reg = <0x02000004 0x10>;
+		clock-frequency = <32768>;
+		cpu-offset = <0x40000>;
+	};
+
+	timer@2000024 {
+		compatible = "qcom,msm-dgt", "qcom,msm-timer";
+		interrupts = <1 0 0x301>;
+		reg = <0x02000024 0x10>,
+		      <0x02000034 0x4>;
+		clock-frequency = <6750000>;
+		cpu-offset = <0x40000>;
+	};
+
 	serial@19c400000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x19c40000 0x1000>,
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 97db3cd..64c981d 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -154,7 +154,7 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm8x60_timer,
+	.timer = &msm_dt_timer,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END
 #endif /* CONFIG_OF */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

