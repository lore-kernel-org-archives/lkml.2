Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2FNQvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:54 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:53756 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932251Ab2FNQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 13/23] ARM: LPC32xx: High Speed UART configuration via DT
Date: Thu, 14 Jun 2012 18:51:03 +0200
Message-Id: <1339692673-7848-14-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the DTS files for the High Speed UARTs 1, 2 and 7 of the
LPC32xx SoC, adjusting the compatible strings, adding interrupts and status
configuration. On the PHY3250 reference board, UART2 is enabled.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

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
+				status = "disabled";
 			};
 
 			uart2: serial@40018000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-hsuart";
 				reg = <0x40018000 0x1000>;
+				interrupts = <25 0>;
+				status = "disabled";
 			};
 
-			uart7: serial@4001C000 {
-				compatible = "nxp,serial";
-				reg = <0x4001C000 0x1000>;
+			uart7: serial@4001c000 {
+				compatible = "nxp,lpc3220-hsuart";
+				reg = <0x4001c000 0x1000>;
+				interrupts = <24 0>;
+				status = "disabled";
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
