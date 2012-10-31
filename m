Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2KHTyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:54:15 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:47061 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab2KHTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:12 -0500
Message-Id: <052ad319f1599baa9a2fc840726a98f573e08672.1352400580.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1352400580.git.josh.cartwright@ni.com>
References: <cover.1352400580.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>, John Linn <john.linn@xilinx.com>,
        arm@kernel.org
Date: Wed, 31 Oct 2012 12:24:48 -0600
Subject: [PATCH v2 1/5] ARM: zynq: dts: split up device tree
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize complete at 11/08/2012 01:54:07 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-08_04:2012-11-08,2012-11-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of the created zynq-7000.dtsi file is to describe the
hardware common to all Zynq 7000-based boards.  Also, get rid of the
zynq-ep107 device tree, since it is not hardware anyone can purchase.

Add a zc702 dts file based on the zynq-7000.dtsi.  Add it to the
dts/Makefile so it is built with the 'dtbs' target.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/boot/dts/Makefile                         |  1 +
 .../boot/dts/{zynq-ep107.dts => zynq-7000.dtsi}    | 19 +++-----------
 arch/arm/boot/dts/zynq-zc702.dts                   | 30 ++++++++++++++++++++++
 arch/arm/mach-zynq/common.c                        |  3 ++-
 4 files changed, 36 insertions(+), 17 deletions(-)
 rename arch/arm/boot/dts/{zynq-ep107.dts => zynq-7000.dtsi} (79%)
 create mode 100644 arch/arm/boot/dts/zynq-zc702.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f37cf9f..76ed11e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -103,5 +103,6 @@ dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \
 dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8505-ref.dtb \
 	wm8650-mid.dtb
+dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
 
 endif
diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-7000.dtsi
similarity index 79%
rename from arch/arm/boot/dts/zynq-ep107.dts
rename to arch/arm/boot/dts/zynq-7000.dtsi
index 5caf100..8b30e59 100644
--- a/arch/arm/boot/dts/zynq-ep107.dts
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -10,29 +10,16 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+/include/ "skeleton.dtsi"
 
-/dts-v1/;
 / {
-	model = "Xilinx Zynq EP107";
-	compatible = "xlnx,zynq-ep107";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	interrupt-parent = <&intc>;
-
-	memory {
-		device_type = "memory";
-		reg = <0x0 0x10000000>;
-	};
-
-	chosen {
-		bootargs = "console=ttyPS0,9600 root=/dev/ram rw initrd=0x800000,8M earlyprintk";
-		linux,stdout-path = &uart0;
-	};
+	compatible = "xlnx,zynq-7000";
 
 	amba {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
+		interrupt-parent = <&intc>;
 		ranges;
 
 		intc: interrupt-controller@f8f01000 {
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
new file mode 100644
index 0000000..e25a307
--- /dev/null
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -0,0 +1,30 @@
+/*
+ *  Copyright (C) 2011 Xilinx
+ *  Copyright (C) 2012 National Instruments Corp.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/dts-v1/;
+/include/ "zynq-7000.dtsi"
+
+/ {
+	model = "Zynq ZC702 Development Board";
+	compatible = "xlnx,zynq-zc702", "xlnx,zynq-7000";
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyPS1,115200 earlyprintk";
+	};
+
+};
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index f0eef84..5441323 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -115,7 +115,8 @@ static void __init xilinx_map_io(void)
 }
 
 static const char *xilinx_dt_match[] = {
-	"xlnx,zynq-ep107",
+	"xlnx,zynq-zc702",
+	"xlnx,zynq-7000",
 	NULL
 };
 
-- 
1.8.0


