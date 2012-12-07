Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422775Ab2LGAVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:21:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41344 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422745Ab2LGAVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:21:21 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: trimslice: add gpio-poweroff node to DT
Date: Thu,  6 Dec 2012 17:21:11 -0700
Message-Id: <1354839672-31187-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

... and disable tri-state from the pingroup that contains the poweroff
GPIO.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra20-trimslice.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index b70b4cb..4b6c486 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -249,6 +249,11 @@
 					"ld23_22";
 				nvidia,pull = <1>;
 			};
+			conf_spif {
+				nvidia,pins = "spif";
+				nvidia,pull = <1>;
+				nvidia,tristate = <0>;
+			};
 		};
 	};
 
@@ -322,6 +327,11 @@
 		bus-width = <4>;
 	};
 
+	poweroff {
+		compatible = "gpio-poweroff";
+		gpios = <&gpio 191 1>; /* gpio PX7, active low */
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
1.7.10.4

