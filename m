Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2IUI53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:57:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11364 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2IUI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:56:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 21 Sep 2012 01:56:05 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 3/5] ARM: dt: t20 ventana: set pinmux and power for wlan
Date: Fri, 21 Sep 2012 16:54:58 +0800
Message-ID: <1348217700-12309-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348217700-12309-1-git-send-email-wni@nvidia.com>
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure pinmux as required for WiFi.
Enable the SDHCI1 controller, which is connectted to the WiFi module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 3e5952f..d8161fb 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -237,6 +237,16 @@
 					"ld23_22";
 				nvidia,pull = <1>;
 			};
+			drive_sdio1 {
+				nvidia,pins = "drive_sdio1";
+				nvidia,high-speed-mode = <0>;
+				nvidia,schmitt = <1>;
+				nvidia,low-power-mode = <3>;
+				nvidia,pull-down-strength = <31>;
+				nvidia,pull-up-strength = <31>;
+				nvidia,slew-rate-rising = <3>;
+				nvidia,slew-rate-falling = <3>;
+			};
 		};
 	};
 
@@ -456,6 +466,12 @@
 		status = "okay";
 	};
 
+	sdhci@c8000000 {
+		status = "okay";
+		power-gpios = <&gpio 86 0>; /* gpio PK6 */
+		bus-width = <4>;
+	};
+
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-- 
1.7.1

