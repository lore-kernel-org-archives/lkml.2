Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KKMvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:51:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2KKMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:51:00 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: enable serial through Device Tree
Date: Sun, 11 Nov 2012 13:50:49 +0100
Message-Id: <1352638249-29298-16-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable serial through Device Tree board files instead of legacy
board files.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/bcm63xx/boards/board_bcm963xx.c |   15 ---------------
 arch/mips/bcm63xx/dts/96328avng.dts       |    3 +++
 arch/mips/bcm63xx/dts/96338gw.dts         |    3 +++
 arch/mips/bcm63xx/dts/96338w.dts          |    3 +++
 arch/mips/bcm63xx/dts/96345gw2.dts        |    3 +++
 arch/mips/bcm63xx/dts/96348gw.dts         |    3 +++
 arch/mips/bcm63xx/dts/96348gw_10.dts      |    3 +++
 arch/mips/bcm63xx/dts/96348gw_11.dts      |    3 +++
 arch/mips/bcm63xx/dts/96348gw_a.dts       |    3 +++
 arch/mips/bcm63xx/dts/96348r.dts          |    3 +++
 arch/mips/bcm63xx/dts/96358vw.dts         |    3 +++
 arch/mips/bcm63xx/dts/96358vw2.dts        |    3 +++
 arch/mips/bcm63xx/dts/dv201amr.dts        |    3 +++
 arch/mips/bcm63xx/dts/dwv_s0.dts          |    3 +++
 arch/mips/bcm63xx/dts/fast2404.dts        |    3 +++
 arch/mips/bcm63xx/dts/rta1025w_16.dts     |    3 +++
 16 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index 73be9b3..c64cf7c 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -40,7 +40,6 @@ static struct board_info __initdata board_96328avng = {
 	.name				= "96328avng",
 	.expected_cpu_id		= 0x6328,
 
-	.has_uart0			= 1,
 	.has_pci			= 1,
 	.has_usbd			= 0,
 
@@ -88,7 +87,6 @@ static struct board_info __initdata board_96338gw = {
 	.name				= "96338GW",
 	.expected_cpu_id		= 0x6338,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.enet0 = {
 		.force_speed_100	= 1,
@@ -131,7 +129,6 @@ static struct board_info __initdata board_96338w = {
 	.name				= "96338W",
 	.expected_cpu_id		= 0x6338,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.enet0 = {
 		.force_speed_100	= 1,
@@ -176,8 +173,6 @@ static struct board_info __initdata board_96338w = {
 static struct board_info __initdata board_96345gw2 = {
 	.name				= "96345GW2",
 	.expected_cpu_id		= 0x6345,
-
-	.has_uart0			= 1,
 };
 #endif
 
@@ -189,7 +184,6 @@ static struct board_info __initdata board_96348r = {
 	.name				= "96348R",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_pci			= 1,
 
@@ -233,7 +227,6 @@ static struct board_info __initdata board_96348gw_10 = {
 	.name				= "96348GW-10",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -293,7 +286,6 @@ static struct board_info __initdata board_96348gw_11 = {
 	.name				= "96348GW-11",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -347,7 +339,6 @@ static struct board_info __initdata board_96348gw = {
 	.name				= "96348GW",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -405,7 +396,6 @@ static struct board_info __initdata board_FAST2404 = {
 	.name				= "F@ST2404",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
         .has_enet0			= 1,
         .has_enet1			= 1,
         .has_pci			= 1,
@@ -448,7 +438,6 @@ static struct board_info __initdata board_DV201AMR = {
 	.name				= "DV201AMR",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_pci			= 1,
 	.has_ohci0			= 1,
 
@@ -468,7 +457,6 @@ static struct board_info __initdata board_96348gw_a = {
 	.name				= "96348GW-A",
 	.expected_cpu_id		= 0x6348,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -494,7 +482,6 @@ static struct board_info __initdata board_96358vw = {
 	.name				= "96358VW",
 	.expected_cpu_id		= 0x6358,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -546,7 +533,6 @@ static struct board_info __initdata board_96358vw2 = {
 	.name				= "96358VW2",
 	.expected_cpu_id		= 0x6358,
 
-	.has_uart0			= 1,
 	.has_enet0			= 1,
 	.has_enet1			= 1,
 	.has_pci			= 1,
@@ -594,7 +580,6 @@ static struct board_info __initdata board_AGPFS0 = {
 	.name                           = "AGPF-S0",
 	.expected_cpu_id                = 0x6358,
 
-	.has_uart0			= 1,
 	.has_enet0                      = 1,
 	.has_enet1                      = 1,
 	.has_pci                        = 1,
diff --git a/arch/mips/bcm63xx/dts/96328avng.dts b/arch/mips/bcm63xx/dts/96328avng.dts
index c1aee15..811fc29 100644
--- a/arch/mips/bcm63xx/dts/96328avng.dts
+++ b/arch/mips/bcm63xx/dts/96328avng.dts
@@ -18,5 +18,8 @@
 
 	ubus@10000000 {
 
+		serial@100 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96338gw.dts b/arch/mips/bcm63xx/dts/96338gw.dts
index 5e4f893..003c4c8 100644
--- a/arch/mips/bcm63xx/dts/96338gw.dts
+++ b/arch/mips/bcm63xx/dts/96338gw.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96338w.dts b/arch/mips/bcm63xx/dts/96338w.dts
index 972a530..bb5be303 100644
--- a/arch/mips/bcm63xx/dts/96338w.dts
+++ b/arch/mips/bcm63xx/dts/96338w.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96345gw2.dts b/arch/mips/bcm63xx/dts/96345gw2.dts
index 0114733..f5942ea 100644
--- a/arch/mips/bcm63xx/dts/96345gw2.dts
+++ b/arch/mips/bcm63xx/dts/96345gw2.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96348gw.dts b/arch/mips/bcm63xx/dts/96348gw.dts
index 8d7f7ca..a956046 100644
--- a/arch/mips/bcm63xx/dts/96348gw.dts
+++ b/arch/mips/bcm63xx/dts/96348gw.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96348gw_10.dts b/arch/mips/bcm63xx/dts/96348gw_10.dts
index 3b27b5b..f8d6925 100644
--- a/arch/mips/bcm63xx/dts/96348gw_10.dts
+++ b/arch/mips/bcm63xx/dts/96348gw_10.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96348gw_11.dts b/arch/mips/bcm63xx/dts/96348gw_11.dts
index 07837ac..fbaf956 100644
--- a/arch/mips/bcm63xx/dts/96348gw_11.dts
+++ b/arch/mips/bcm63xx/dts/96348gw_11.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96348gw_a.dts b/arch/mips/bcm63xx/dts/96348gw_a.dts
index 9b0e5bd..d1e1fcd 100644
--- a/arch/mips/bcm63xx/dts/96348gw_a.dts
+++ b/arch/mips/bcm63xx/dts/96348gw_a.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96348r.dts b/arch/mips/bcm63xx/dts/96348r.dts
index 309f898..65081f3 100644
--- a/arch/mips/bcm63xx/dts/96348r.dts
+++ b/arch/mips/bcm63xx/dts/96348r.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96358vw.dts b/arch/mips/bcm63xx/dts/96358vw.dts
index 55c3e92..6e6c8a2 100644
--- a/arch/mips/bcm63xx/dts/96358vw.dts
+++ b/arch/mips/bcm63xx/dts/96358vw.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@100 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/96358vw2.dts b/arch/mips/bcm63xx/dts/96358vw2.dts
index 88f12ba..065944d 100644
--- a/arch/mips/bcm63xx/dts/96358vw2.dts
+++ b/arch/mips/bcm63xx/dts/96358vw2.dts
@@ -19,5 +19,8 @@
 
 	ubus@fffe0000 {
 
+		serial@100 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/dv201amr.dts b/arch/mips/bcm63xx/dts/dv201amr.dts
index 7cdb41f..7f23015 100644
--- a/arch/mips/bcm63xx/dts/dv201amr.dts
+++ b/arch/mips/bcm63xx/dts/dv201amr.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/dwv_s0.dts b/arch/mips/bcm63xx/dts/dwv_s0.dts
index 96e79cd..9f837d7 100644
--- a/arch/mips/bcm63xx/dts/dwv_s0.dts
+++ b/arch/mips/bcm63xx/dts/dwv_s0.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@100 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/fast2404.dts b/arch/mips/bcm63xx/dts/fast2404.dts
index 55d31ce..9158aaa 100644
--- a/arch/mips/bcm63xx/dts/fast2404.dts
+++ b/arch/mips/bcm63xx/dts/fast2404.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/rta1025w_16.dts b/arch/mips/bcm63xx/dts/rta1025w_16.dts
index 825fe4e..726de6d 100644
--- a/arch/mips/bcm63xx/dts/rta1025w_16.dts
+++ b/arch/mips/bcm63xx/dts/rta1025w_16.dts
@@ -18,5 +18,8 @@
 
 	ubus@fffe0000 {
 
+		serial@300 {
+			status = "ok";
+		};
 	};
 };
-- 
1.7.2.5

