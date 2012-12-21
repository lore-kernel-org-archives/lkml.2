Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2LURj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:39:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47169 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2LURjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:39:20 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] ODROID-X: dts: Add mshc node for ODROID-X board
Date: Sat, 22 Dec 2012 02:37:03 +0900
Message-Id: <1356111423-3454-5-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
References: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the device node to support eMMC storage on SDCARD4 ports, controlled by
Mobile Storage Host Controller.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index e5c57c1..7a2df8e 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -68,4 +68,24 @@
 			linux,default-trigger = "mmc0";
 		};
 	};
+
+	mshc@12550000 {
+		bus-width = <8>;
+		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3 3>;
+		samsung,dw-mshc-ddr-timing = <1 2 3>;
+
+		slot@0 {
+			reg = <0>;
+		};
+	};
 };
-- 
1.7.9.5

