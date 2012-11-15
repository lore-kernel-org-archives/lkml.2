Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab2KOVVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:21:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2KOVUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] ARM: tegra: Add Tegra20 host1x support
Date: Thu, 15 Nov 2012 22:07:54 +0100
Message-Id: <1353013679-16773-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:iV53RHK78+9EFJhp6DeS5OzTUI7Cz44DSlSdC3k1DRR
 5eNKkr9KjgrDI8iZ5PWRvb8mZVeqO8OuoO1nq1POJvavT7QvIv
 Od03RA01nXzeITu04ZX7ttQUOS+CAbJkSf1VLuqGFHunQEEB55
 lFnmwXbwLxadEPGreq2ONjmIYFIO34ndgZzWnWNuwnwRh5TqNc
 WhrNKYBdHv4/cb1Lruej1jNEiD4+bUq8bd2Zg6otfsMXpc2sbh
 PVvnY6Y3MJcVLhcyDO4iEZgdxnP94GqY0O5/JpiDPeW4mpec44
 QtA0f9F+TUl619vqSl93z6f1siTqr1eIkX6Qq8CoXBp8tgZ7C4
 B52Bi+9MDQdSJOPAQnkROV+X/GdBBu2zJL1M28l8r5096TYSgT
 YoMrgCbxe4Y7FYEyfI8APgR8DLgBRZPM79K14UULBmoAWf1xFM
 KIhFw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host1x node along with its children to the Tegra20 DTSI. Board-
specific DTS files are expected to enable the available outputs and
complement the device tree with data specific to the hardware.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20.dtsi | 87 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 4519a6f..b8effa1 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -4,6 +4,93 @@
 	compatible = "nvidia,tegra20";
 	interrupt-parent = <&intc>;
 
+	host1x {
+		compatible = "nvidia,tegra20-host1x", "simple-bus";
+		reg = <0x50000000 0x00024000>;
+		interrupts = <0 65 0x04   /* mpcore syncpt */
+			      0 67 0x04>; /* mpcore general */
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		ranges = <0x54000000 0x54000000 0x04000000>;
+
+		mpe {
+			compatible = "nvidia,tegra20-mpe";
+			reg = <0x54040000 0x00040000>;
+			interrupts = <0 68 0x04>;
+		};
+
+		vi {
+			compatible = "nvidia,tegra20-vi";
+			reg = <0x54080000 0x00040000>;
+			interrupts = <0 69 0x04>;
+		};
+
+		epp {
+			compatible = "nvidia,tegra20-epp";
+			reg = <0x540c0000 0x00040000>;
+			interrupts = <0 70 0x04>;
+		};
+
+		isp {
+			compatible = "nvidia,tegra20-isp";
+			reg = <0x54100000 0x00040000>;
+			interrupts = <0 71 0x04>;
+		};
+
+		gr2d {
+			compatible = "nvidia,tegra20-gr2d";
+			reg = <0x54140000 0x00040000>;
+			interrupts = <0 72 0x04>;
+		};
+
+		gr3d {
+			compatible = "nvidia,tegra20-gr3d";
+			reg = <0x54180000 0x00040000>;
+		};
+
+		dc@54200000 {
+			compatible = "nvidia,tegra20-dc";
+			reg = <0x54200000 0x00040000>;
+			interrupts = <0 73 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		dc@54240000 {
+			compatible = "nvidia,tegra20-dc";
+			reg = <0x54240000 0x00040000>;
+			interrupts = <0 74 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		hdmi {
+			compatible = "nvidia,tegra20-hdmi";
+			reg = <0x54280000 0x00040000>;
+			interrupts = <0 75 0x04>;
+			status = "disabled";
+		};
+
+		tvo {
+			compatible = "nvidia,tegra20-tvo";
+			reg = <0x542c0000 0x00040000>;
+			interrupts = <0 76 0x04>;
+			status = "disabled";
+		};
+
+		dsi {
+			compatible = "nvidia,tegra20-dsi";
+			reg = <0x54300000 0x00040000>;
+			status = "disabled";
+		};
+	};
+
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
-- 
1.8.0

