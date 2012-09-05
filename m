Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab2IETb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:31:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2IET3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:29:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6826"; a="230947985"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 4/9] ARM: msm: Move 8660 to DT timer
Date: Wed,  5 Sep 2012 12:28:54 -0700
Message-Id: <1346873339-10927-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c
In-Reply-To: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the timer entry and point the machine descriptor to the
device tree based msm timer.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts | 17 +++++++++++++++++
 arch/arm/mach-msm/board-msm8x60.c  |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 45bc4bb..93a15ab 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -15,6 +15,23 @@
 		      < 0x02081000 0x1000 >;
 	};
 
+	timer@02000004 {
+		compatible = "qcom,msm-gpt", "qcom,msm-timer";
+		interrupts = <1 1 0x301>;
+		reg = <0x02000004 0x10>;
+		clock-frequency = <32768>;
+		cpu-offset = <0x40000>;
+	};
+
+	timer@02000024 {
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

