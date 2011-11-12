Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1KLMDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 07:03:17 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:24384
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab1KLMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 07:03:14 -0500
X-SpamScore: 3
X-BigFish: VS3(z37d5kzzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 3/5,v3] powerpc/85xx: Update SRIO device tree nodes
Date: Sat, 12 Nov 2011 20:02:30 +0800
Message-ID: <1321099352-21462-3-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>

Update all dts files that support SRIO controllers to match the new
fsl,srio device tree binding.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/boot/dts/mpc8568mds.dts   |   66 ++++++++++++++++++++++-------
 arch/powerpc/boot/dts/mpc8569mds.dts   |   72 +++++++++++++++++++++++++------
 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   69 ++++++++++++++++++++++++-------
 arch/powerpc/boot/dts/p2041rdb.dts     |   11 +++++
 arch/powerpc/boot/dts/p2041si.dtsi     |   20 +++++++++
 arch/powerpc/boot/dts/p3041ds.dts      |   11 +++++
 arch/powerpc/boot/dts/p3041si.dtsi     |   26 ++++++++---
 arch/powerpc/boot/dts/p4080ds.dts      |   12 ++++-
 arch/powerpc/boot/dts/p4080si.dtsi     |   64 +++++++++++++++++++++++-----
 arch/powerpc/boot/dts/p5020ds.dts      |   11 +++++
 arch/powerpc/boot/dts/p5020si.dtsi     |   26 ++++++++---
 11 files changed, 314 insertions(+), 74 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8568mds.dts b/arch/powerpc/boot/dts/mpc8568mds.dts
index 647daf8..2ca5387 100644
--- a/arch/powerpc/boot/dts/mpc8568mds.dts
+++ b/arch/powerpc/boot/dts/mpc8568mds.dts
@@ -26,7 +26,6 @@
 		serial1 = &serial1;
 		pci0 = &pci0;
 		pci1 = &pci1;
-		rapidio0 = &rio0;
 	};
 
 	cpus {
@@ -331,6 +330,41 @@
 			};
 		};
 
+		rmu: rmu@d3000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,srio-rmu";
+			reg = <0xd3000 0x500>;
+			ranges = <0x0 0xd3000 0x500>;
+
+			message-unit@0 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x0 0x100>;
+				interrupts = <
+					53 2 /* msg1_tx_irq */
+					54 2>;/* msg1_rx_irq */
+			};
+			message-unit@100 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x100 0x100>;
+				interrupts = <
+					55 2  /* msg2_tx_irq */
+					56 2>;/* msg2_rx_irq */
+			};
+			doorbell-unit@400 {
+				compatible = "fsl,srio-dbell-unit";
+				reg = <0x400 0x80>;
+				interrupts = <
+					49 2  /* bell_outb_irq */
+					50 2>;/* bell_inb_irq */
+			};
+			port-write-unit@4e0 {
+				compatible = "fsl,srio-port-write-unit";
+				reg = <0x4e0 0x20>;
+				interrupts = <48 2>;
+			};
+		};
+
 		global-utilities@e0000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -638,22 +672,22 @@
 		};
 	};
 
-	rio0: rapidio@e00c00000 {
-		#address-cells = <2>;
-		#size-cells = <2>;
-		compatible = "fsl,mpc8568-rapidio", "fsl,rapidio-delta";
-		reg = <0xe00c0000 0x20000>;
-		ranges = <0x0 0x0 0xc0000000 0x0 0x20000000>;
-		interrupts = <48 2 /* error     */
-			      49 2 /* bell_outb */
-			      50 2 /* bell_inb  */
-			      53 2 /* msg1_tx   */
-			      54 2 /* msg1_rx   */
-			      55 2 /* msg2_tx   */
-			      56 2 /* msg2_rx   */>;
+	rapidio@e00c0000 {
+		reg = <0xe00c0000 0x11000>;
+		compatible = "fsl,srio";
 		interrupt-parent = <&mpic>;
-		sleep = <&pmc 0x00080000   /* controller */
-			 &pmc 0x00040000>; /* message unit */
+		interrupts = <48 2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		fsl,srio-rmu-handle = <&rmu>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+			ranges = <0x0 0x0 0xc0000000 0x0 0x20000000>;
+		};
 	};
 
 	leds {
diff --git a/arch/powerpc/boot/dts/mpc8569mds.dts b/arch/powerpc/boot/dts/mpc8569mds.dts
index 8b72eaf..0d9d167 100644
--- a/arch/powerpc/boot/dts/mpc8569mds.dts
+++ b/arch/powerpc/boot/dts/mpc8569mds.dts
@@ -27,7 +27,6 @@
 		ethernet5 = &enet5;
 		ethernet7 = &enet7;
 		pci1 = &pci1;
-		rapidio0 = &rio0;
 	};
 
 	cpus {
@@ -326,6 +325,41 @@
 			interrupt-parent = <&mpic>;
 		};
 
+		rmu: rmu@d3000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,srio-rmu";
+			reg = <0xd3000 0x500>;
+			ranges = <0x0 0xd3000 0x500>;
+
+			message-unit@0 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x0 0x100>;
+				interrupts = <
+					53 2 /* msg1_tx_irq */
+					54 2>;/* msg1_rx_irq */
+			};
+			message-unit@100 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x100 0x100>;
+				interrupts = <
+					55 2  /* msg2_tx_irq */
+					56 2>;/* msg2_rx_irq */
+			};
+			doorbell-unit@400 {
+				compatible = "fsl,srio-dbell-unit";
+				reg = <0x400 0x80>;
+				interrupts = <
+					49 2  /* bell_outb_irq */
+					50 2>;/* bell_inb_irq */
+			};
+			port-write-unit@4e0 {
+				compatible = "fsl,srio-port-write-unit";
+				reg = <0x4e0 0x20>;
+				interrupts = <48 2>;
+			};
+		};
+
 		global-utilities@e0000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -771,20 +805,30 @@
 		};
 	};
 
-	rio0: rapidio@e00c00000 {
-		#address-cells = <2>;
-		#size-cells = <2>;
-		compatible = "fsl,mpc8569-rapidio", "fsl,rapidio-delta";
-		reg = <0xe00c0000 0x20000>;
-		ranges = <0x0 0x0 0xc0000000 0x0 0x20000000>;
-		interrupts = <48 2 /* error     */
-			      49 2 /* bell_outb */
-			      50 2 /* bell_inb  */
-			      53 2 /* msg1_tx   */
-			      54 2 /* msg1_rx   */
-			      55 2 /* msg2_tx   */
-			      56 2 /* msg2_rx   */>;
+	rapidio@e00c0000 {
+		reg = <0xe00c0000 0x11000>;
+		compatible = "fsl,srio";
 		interrupt-parent = <&mpic>;
+		interrupts = <48 2>;
 		sleep = <&pmc 0x00080000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		fsl,srio-rmu-handle = <&rmu>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+			ranges = <0x0 0x0 0xc0000000 0x0 0x20000000>;
+		};
+
+		port2 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <2>;
+			status = "disabled";
+		};
 	};
+
 };
diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 848320e..fb8640e 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -26,13 +26,6 @@
 		serial1 = &serial1;
 		pci0 = &pci0;
 		pci1 = &pci1;
-/*
- * Only one of Rapid IO or PCI can be present due to HW limitations and
- * due to the fact that the 2 now share address space in the new memory
- * map.  The most likely case is that we have PCI, so comment out the
- * rapidio node.  Leave it here for reference.
- */
-		/* rapidio0 = &rapidio0; */
 	};
 
 	cpus {
@@ -361,6 +354,41 @@
 			device_type = "open-pic";
 		};
 
+		rmu: rmu@d3000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,srio-rmu";
+			reg = <0xd3000 0x500>;
+			ranges = <0x0 0xd3000 0x500>;
+
+			message-unit@0 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x0 0x100>;
+				interrupts = <
+					53 2 /* msg1_tx_irq */
+					54 2>;/* msg1_rx_irq */
+			};
+			message-unit@100 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x100 0x100>;
+				interrupts = <
+					55 2  /* msg2_tx_irq */
+					56 2>;/* msg2_rx_irq */
+			};
+			doorbell-unit@400 {
+				compatible = "fsl,srio-dbell-unit";
+				reg = <0x400 0x80>;
+				interrupts = <
+					49 2  /* bell_outb_irq */
+					50 2>;/* bell_inb_irq */
+			};
+			port-write-unit@4e0 {
+				compatible = "fsl,srio-port-write-unit";
+				reg = <0x4e0 0x20>;
+				interrupts = <48 2>;
+			};
+		};
+
 		global-utilities@e0000 {
 			compatible = "fsl,mpc8641-guts";
 			reg = <0xe0000 0x1000>;
@@ -612,16 +640,27 @@
 		};
 	};
 /*
-	rapidio0: rapidio@ffec0000 {
+ * Only one of Rapid IO or PCI can be present due to HW limitations and
+ * due to the fact that the 2 now share address space in the new memory
+ * map.  The most likely case is that we have PCI, so comment out the
+ * rapidio node.  Leave it here for reference.
+
+	rapidio@ffec0000 {
+		reg = <0xffec0000 0x11000>;
+		compatible = "fsl,srio";
+		interrupt-parent = <&mpic>;
+		interrupts = <48 2>;
 		#address-cells = <2>;
 		#size-cells = <2>;
-		compatible = "fsl,rapidio-delta";
-		reg = <0xffec0000 0x20000>;
-		ranges = <0 0 0x80000000 0 0x20000000>;
-		interrupt-parent = <&mpic>;
-		// err_irq bell_outb_irq bell_inb_irq
-		//	msg1_tx_irq msg1_rx_irq	msg2_tx_irq msg2_rx_irq
-		interrupts = <48 2 49 2 50 2 53 2 54 2 55 2 56 2>;
+		fsl,srio-rmu-handle = <&rmu>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+			ranges = <0 0 0x80000000 0 0x20000000>;
+		};
 	};
 */
 
diff --git a/arch/powerpc/boot/dts/p2041rdb.dts b/arch/powerpc/boot/dts/p2041rdb.dts
index 79b6895..739d8a7 100644
--- a/arch/powerpc/boot/dts/p2041rdb.dts
+++ b/arch/powerpc/boot/dts/p2041rdb.dts
@@ -106,6 +106,17 @@
 		};
 	};
 
+	rapidio@ffe0c0000 {
+		reg = <0xf 0xfe0c0000 0 0x11000>;
+
+		port1 {
+			ranges = <0 0 0xc 0x20000000 0 0x10000000>;
+		};
+		port2 {
+			ranges = <0 0 0xc 0x30000000 0 0x10000000>;
+		};
+	};
+
 	localbus@ffe124000 {
 		reg = <0xf 0xfe124000 0 0x1000>;
 		ranges = <0 0 0xf 0xe8000000 0x08000000>;
diff --git a/arch/powerpc/boot/dts/p2041si.dtsi b/arch/powerpc/boot/dts/p2041si.dtsi
index f7492ed..c2a4314 100644
--- a/arch/powerpc/boot/dts/p2041si.dtsi
+++ b/arch/powerpc/boot/dts/p2041si.dtsi
@@ -602,6 +602,26 @@
 
 	};
 
+	rapidio@ffe0c0000 {
+		compatible = "fsl,srio";
+		interrupts = <16 2 1 11>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+		};
+
+		port2 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <2>;
+		};
+	};
+
 	localbus@ffe124000 {
 		compatible = "fsl,p2041-elbc", "fsl,elbc", "simple-bus";
 		interrupts = <25 2 0 0>;
diff --git a/arch/powerpc/boot/dts/p3041ds.dts b/arch/powerpc/boot/dts/p3041ds.dts
index bbd113b..40193e4 100644
--- a/arch/powerpc/boot/dts/p3041ds.dts
+++ b/arch/powerpc/boot/dts/p3041ds.dts
@@ -99,6 +99,17 @@
 		};
 	};
 
+	rapidio@ffe0c0000 {
+		reg = <0xf 0xfe0c0000 0 0x11000>;
+
+		port1 {
+			ranges = <0 0 0xc 0x20000000 0 0x10000000>;
+		};
+		port2 {
+			ranges = <0 0 0xc 0x30000000 0 0x10000000>;
+		};
+	};
+
 	localbus@ffe124000 {
 		reg = <0xf 0xfe124000 0 0x1000>;
 		ranges = <0 0 0xf 0xe8000000 0x08000000
diff --git a/arch/powerpc/boot/dts/p3041si.dtsi b/arch/powerpc/boot/dts/p3041si.dtsi
index 87130b7..3ef3ae6 100644
--- a/arch/powerpc/boot/dts/p3041si.dtsi
+++ b/arch/powerpc/boot/dts/p3041si.dtsi
@@ -71,10 +71,6 @@
 		rtic_c = &rtic_c;
 		rtic_d = &rtic_d;
 		sec_mon = &sec_mon;
-
-/*
-		rio0 = &rapidio0;
- */
 	};
 
 	cpus {
@@ -607,9 +603,25 @@
 		};
 	};
 
-/*
-	rapidio0: rapidio@ffe0c0000
-*/
+	rapidio@ffe0c0000 {
+		compatible = "fsl,srio";
+		interrupts = <16 2 1 11>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+		};
+
+		port2 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <2>;
+		};
+	};
 
 	localbus@ffe124000 {
 		compatible = "fsl,p3041-elbc", "fsl,elbc", "simple-bus";
diff --git a/arch/powerpc/boot/dts/p4080ds.dts b/arch/powerpc/boot/dts/p4080ds.dts
index c7916dc..7df35d8 100644
--- a/arch/powerpc/boot/dts/p4080ds.dts
+++ b/arch/powerpc/boot/dts/p4080ds.dts
@@ -105,9 +105,15 @@
 		};
 	};
 
-	rapidio0: rapidio@ffe0c0000 {
-		reg = <0xf 0xfe0c0000 0 0x20000>;
-		ranges = <0 0 0xc 0x20000000 0 0x01000000>;
+	rapidio@ffe0c0000 {
+		reg = <0xf 0xfe0c0000 0 0x11000>;
+
+		port1 {
+			ranges = <0 0 0xc 0x20000000 0 0x10000000>;
+		};
+		port2 {
+			ranges = <0 0 0xc 0x30000000 0 0x10000000>;
+		};
 	};
 
 	localbus@ffe124000 {
diff --git a/arch/powerpc/boot/dts/p4080si.dtsi b/arch/powerpc/boot/dts/p4080si.dtsi
index f20c01a..6c7eb35 100644
--- a/arch/powerpc/boot/dts/p4080si.dtsi
+++ b/arch/powerpc/boot/dts/p4080si.dtsi
@@ -70,8 +70,6 @@
 		rtic_c = &rtic_c;
 		rtic_d = &rtic_d;
 		sec_mon = &sec_mon;
-
-		rio0 = &rapidio0;
 	};
 
 	cpus {
@@ -347,6 +345,41 @@
 				0xf7 0 0 0>;
 		};
 
+		rmu: rmu@d3000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,srio-rmu";
+			reg = <0xd3000 0x500>;
+			ranges = <0x0 0xd3000 0x500>;
+
+			message-unit@0 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x0 0x100>;
+				interrupts = <
+					60 2 0 0  /* msg1_tx_irq */
+					61 2 0 0>;/* msg1_rx_irq */
+			};
+			message-unit@100 {
+				compatible = "fsl,srio-msg-unit";
+				reg = <0x100 0x100>;
+				interrupts = <
+					62 2 0 0  /* msg2_tx_irq */
+					63 2 0 0>;/* msg2_rx_irq */
+			};
+			doorbell-unit@400 {
+				compatible = "fsl,srio-dbell-unit";
+				reg = <0x400 0x80>;
+				interrupts = <
+					56 2 0 0  /* bell_outb_irq */
+					57 2 0 0>;/* bell_inb_irq */
+			};
+			port-write-unit@4e0 {
+				compatible = "fsl,srio-port-write-unit";
+				reg = <0x4e0 0x20>;
+				interrupts = <16 2 1 11>;
+			};
+		};
+
 		guts: global-utilities@e0000 {
 			compatible = "fsl,qoriq-device-config-1.0";
 			reg = <0xe0000 0xe00>;
@@ -651,18 +684,25 @@
 		};
 	};
 
-	rapidio0: rapidio@ffe0c0000 {
+	rapidio@ffe0c0000 {
+		compatible = "fsl,srio";
+		interrupts = <16 2 1 11>;
 		#address-cells = <2>;
 		#size-cells = <2>;
-		compatible = "fsl,rapidio-delta";
-		interrupts = <
-			16 2 1 11 /* err_irq */
-			56 2 0 0  /* bell_outb_irq */
-			57 2 0 0  /* bell_inb_irq */
-			60 2 0 0  /* msg1_tx_irq */
-			61 2 0 0  /* msg1_rx_irq */
-			62 2 0 0  /* msg2_tx_irq */
-			63 2 0 0>; /* msg2_rx_irq */
+		fsl,srio-rmu-handle = <&rmu>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+		};
+
+		port2 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <2>;
+		};
 	};
 
 	localbus@ffe124000 {
diff --git a/arch/powerpc/boot/dts/p5020ds.dts b/arch/powerpc/boot/dts/p5020ds.dts
index e6d4099..e3fb415 100644
--- a/arch/powerpc/boot/dts/p5020ds.dts
+++ b/arch/powerpc/boot/dts/p5020ds.dts
@@ -99,6 +99,17 @@
 		};
 	};
 
+	rapidio@ffe0c0000 {
+		reg = <0xf 0xfe0c0000 0 0x11000>;
+
+		port1 {
+			ranges = <0 0 0xc 0x20000000 0 0x10000000>;
+		};
+		port2 {
+			ranges = <0 0 0xc 0x30000000 0 0x10000000>;
+		};
+	};
+
 	localbus@ffe124000 {
 		reg = <0xf 0xfe124000 0 0x1000>;
 		ranges = <0 0 0xf 0xe8000000 0x08000000
diff --git a/arch/powerpc/boot/dts/p5020si.dtsi b/arch/powerpc/boot/dts/p5020si.dtsi
index e7948ad..02d15e3 100644
--- a/arch/powerpc/boot/dts/p5020si.dtsi
+++ b/arch/powerpc/boot/dts/p5020si.dtsi
@@ -71,10 +71,6 @@
 		rtic_c = &rtic_c;
 		rtic_d = &rtic_d;
 		sec_mon = &sec_mon;
-
-/*
-		rio0 = &rapidio0;
- */
 	};
 
 	cpus {
@@ -594,9 +590,25 @@
 		};
 	};
 
-/*
-	rapidio0: rapidio@ffe0c0000
-*/
+	rapidio@ffe0c0000 {
+		compatible = "fsl,srio";
+		interrupts = <16 2 1 11>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		port1 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <1>;
+		};
+
+		port2 {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			cell-index = <2>;
+		};
+	};
 
 	localbus@ffe124000 {
 		compatible = "fsl,p5020-elbc", "fsl,elbc", "simple-bus";
-- 
1.7.3.1


