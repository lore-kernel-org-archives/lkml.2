Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127Ab2COSfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:35:40 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:48835 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762029Ab2COSff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:35:35 -0400
From: Aneesh V <aneesh@ti.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Aneesh V <aneesh@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 3/4] arm: dts: EMIF and LPDDR2 device tree data for OMAP4 boards
Date: Fri, 16 Mar 2012 00:04:06 +0530
Message-Id: <1331836447-7584-4-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1331836447-7584-1-git-send-email-aneesh@ti.com>
References: <1331836447-7584-1-git-send-email-aneesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree data for the EMIF sdram controllers in OMAP4
and LPDDR2 memory devices attached to OMAP4 boards.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Aneesh V <aneesh@ti.com>
---
v1:
- Removed DDR3 only parameters from
  elpida_ecb240abacn.dtsi
---
 arch/arm/boot/dts/elpida_ecb240abacn.dtsi |   67 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap4-panda.dts         |   13 ++++++
 arch/arm/boot/dts/omap4-sdp.dts           |   13 ++++++
 arch/arm/boot/dts/omap4.dtsi              |   18 ++++++++
 4 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/elpida_ecb240abacn.dtsi

diff --git a/arch/arm/boot/dts/elpida_ecb240abacn.dtsi b/arch/arm/boot/dts/elpida_ecb240abacn.dtsi
new file mode 100644
index 0000000..34b9f72
--- /dev/null
+++ b/arch/arm/boot/dts/elpida_ecb240abacn.dtsi
@@ -0,0 +1,67 @@
+/*
+ * Common devices used in different OMAP boards
+ */
+
+/ {
+	elpida_ECB240ABACN: lpddr2 {
+		compatible 	= "Elpida,ECB240ABACN","jedec,lpddr2-s4";
+		density		= <2048>;
+		io-width	= <32>;
+
+		tRPab-min-tck	= <3>;
+		tRCD-min-tck	= <3>;
+		tWR-min-tck	= <3>;
+		tRASmin-min-tck	= <3>;
+		tRRD-min-tck	= <2>;
+		tWTR-min-tck	= <2>;
+		tXP-min-tck	= <2>;
+		tRTP-min-tck	= <2>;
+		tCKE-min-tck	= <3>;
+		tCKESR-min-tck	= <3>;
+		tFAW-min-tck	= <8>;
+
+		timings_elpida_ECB240ABACN_400mhz: lpddr2-timings@0 {
+			compatible	= "jedec,lpddr2-timings";
+			min-freq	= <10000000>;
+			max-freq	= <400000000>;
+			tRPab		= <21000>;
+			tRCD		= <18000>;
+			tWR		= <15000>;
+			tRAS-min	= <42000>;
+			tRRD		= <10000>;
+			tWTR		= <7500>;
+			tXP		= <7500>;
+			tRTP		= <7500>;
+			tCKESR		= <15000>;
+			tDQSCK-max 	= <5500>;
+			tFAW		= <50000>;
+			tZQCS		= <90000>;
+			tZQCL		= <360000>;
+			tZQinit		= <1000000>;
+			tRAS-max-ns	= <70000>;
+			tDQSCK-max-derated = <6000>;
+		};
+
+		timings_elpida_ECB240ABACN_200mhz: lpddr2-timings@1 {
+			compatible	= "jedec,lpddr2-timings";
+			min-freq	= <10000000>;
+			max-freq	= <200000000>;
+			tRPab		= <21000>;
+			tRCD		= <18000>;
+			tWR		= <15000>;
+			tRAS-min	= <42000>;
+			tRRD		= <10000>;
+			tWTR		= <10000>;
+			tXP		= <7500>;
+			tRTP		= <7500>;
+			tCKESR		= <15000>;
+			tDQSCK-max 	= <5500>;
+			tFAW		= <50000>;
+			tZQCS		= <90000>;
+			tZQCL		= <360000>;
+			tZQinit		= <1000000>;
+			tRAS-max-ns	= <70000>;
+			tDQSCK-max-derated = <6000>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 9755ad5..f548523 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -8,6 +8,7 @@
 /dts-v1/;
 
 /include/ "omap4.dtsi"
+/include/ "elpida_ecb240abacn.dtsi"
 
 / {
 	model = "TI OMAP4 PandaBoard";
@@ -17,4 +18,16 @@
 		device_type = "memory";
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
+
+	ocp {
+		emif1: emif@0x4c000000 {
+			cs1-used;
+			device-handle = <&elpida_ECB240ABACN>;
+		};
+
+		emif2: emif@0x4d000000 {
+			cs1-used;
+			device-handle = <&elpida_ECB240ABACN>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 63c6b2b..6dc08bc 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -8,6 +8,7 @@
 /dts-v1/;
 
 /include/ "omap4.dtsi"
+/include/ "elpida_ecb240abacn.dtsi"
 
 / {
 	model = "TI OMAP4 SDP board";
@@ -17,4 +18,16 @@
 		device_type = "memory";
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
+
+	ocp {
+		emif1: emif@0x4c000000 {
+			cs1-used;
+			device-handle = <&elpida_ECB240ABACN>;
+		};
+
+		emif2: emif@0x4d000000 {
+			cs1-used;
+			device-handle = <&elpida_ECB240ABACN>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 70a44f6..fe3664a 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -127,5 +127,23 @@
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
 		};
+
+		emif1: emif@0x4c000000 {
+			compatible	= "ti,emif-4d";
+			ti,hwmods	= "emif1";
+			phy-type	= <1>;
+			hw-caps-read-idle-ctrl;
+			hw-caps-ll-interface;
+			hw-caps-temp-alert;
+		};
+
+		emif2: emif@0x4d000000 {
+			compatible	= "ti,emif-4d";
+			ti,hwmods	= "emif2";
+			phy-type	= <1>;
+			hw-caps-read-idle-ctrl;
+			hw-caps-ll-interface;
+			hw-caps-temp-alert;
+		};
 	};
 };
-- 
1.7.1

