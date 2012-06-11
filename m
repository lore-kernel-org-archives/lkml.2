Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2FKLCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:02:55 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51130 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624Ab2FKLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:02:53 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 13/14] ARM: LPC32xx: High Speed UART configuration via DT
Date: Mon, 11 Jun 2012 13:02:16 +0200
Message-Id: <1339412537-24485-14-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339412537-24485-1-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the DTS files for the High Speed UARTs 1, 2 and 7 of the
LPC32xx SoC, adjusting the compatible strings, adding interrupts and status
configuration. On the PHY3250 reference board, UART2 is enabled.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/lpc32xx.dtsi |   16 +++++++++++-----
 arch/arm/boot/dts/phy3250.dts  |    4 ++++
 2 files changed, 15 insertions(+), 5 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -212,18 +212,24 @@
 			};
 
 			uart1: serial@40014000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-hsuart";
 				reg = <0x40014000 0x1000>;
+				interrupts = <26 0>;
+				status = "disable";
 			};
 
 			uart2: serial@40018000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-hsuart";
 				reg = <0x40018000 0x1000>;
+				interrupts = <25 0>;
+				status = "disable";
 			};
 
-			uart7: serial@4001C000 {
-				compatible = "nxp,serial";
-				reg = <0x4001C000 0x1000>;
+			uart7: serial@4001c000 {
+				compatible = "nxp,lpc3220-hsuart";
+				reg = <0x4001c000 0x1000>;
+				interrupts = <24 0>;
+				status = "disable";
 			};
 
 			rtc@40024000 {
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -148,6 +148,10 @@
 		};
 
 		fab {
+			uart2: serial@40018000 {
+				status = "okay";
+			};
+
 			tsc@40048000 {
 				status = "okay";
 			};
