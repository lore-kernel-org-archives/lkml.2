Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2ILTqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:46:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39351 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2ILTqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:21 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v2 9/9] arm/dts: OMAP3/4: Add iommu nodes
Date: Wed, 12 Sep 2012 14:45:52 -0500
Message-Id: <1347479152-588-10-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for iommu DT, to interface with hwmods.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/boot/dts/omap3.dtsi |   12 +++++++++++-
 arch/arm/boot/dts/omap4.dtsi |   17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 8109471..7500136 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -38,12 +38,17 @@
 		};
 
 		iva {
-			compatible = "ti,iva2.2";
+			compatible = "ti,iva2.2", "simple-bus";
 			ti,hwmods = "iva";
 
 			dsp {
 				compatible = "ti,omap3-c64";
 			};
+
+			mmu_iva: mmu_iva@5d000000 {
+				compatible = "ti,omap3-iommu";
+				ti,hwmods = "mmu_iva";
+			};
 		};
 	};
 
@@ -216,6 +221,11 @@
 			ti,hwmods = "mmc3";
 		};
 
+		mmu_isp: mmu_isp@480bd400 {
+			compatible = "ti,omap3-iommu";
+			ti,hwmods = "mmu_isp";
+		};
+
 		wdt2: wdt@48314000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 04cbbcb..07f3587 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -48,8 +48,23 @@
 		};
 
 		dsp {
-			compatible = "ti,omap3-c64";
+			compatible = "ti,omap3-c64", "simple-bus";
 			ti,hwmods = "dsp";
+
+			mmu_dsp: mmu_dsp@4a066000 {
+				compatible = "ti,omap4-iommu";
+				ti,hwmods = "mmu_dsp";
+			};
+		};
+
+		ipu {
+			compatible = "ti,omap4-ipu", "simple-bus";
+			ti,hwmods = "ipu";
+
+			mmu_ipu: mmu_ipu@55082000 {
+				compatible = "ti,omap4-iommu";
+				ti,hwmods = "mmu_ipu";
+			};
 		};
 
 		iva {
-- 
1.7.9.5

