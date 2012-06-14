Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2FNQ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:56:41 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35311 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932205Ab2FNQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:43 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 11/23] ARM: LPC32xx: DTS adjustment for using pl18x primecell
Date: Thu, 14 Jun 2012 18:51:01 +0200
Message-Id: <1339692673-7848-12-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the dts files to reference the pl18x primecell driver
correctly.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/lpc32xx.dtsi |    3 ++-
 arch/arm/boot/dts/phy3250.dts  |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -115,9 +115,10 @@
 			};
 
 			sd@20098000 {
-				compatible = "arm,pl180", "arm,primecell";
+				compatible = "arm,pl18x", "arm,primecell";
 				reg = <0x20098000 0x1000>;
 				interrupts = <0x0f 0>, <0x0d 0>;
+				status = "disabled";
 			};
 
 			i2s1: i2s@2009C000 {
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -129,6 +129,14 @@
 					compatible = "atmel,at25";
 				};
 			};
+
+			sd@20098000 {
+				wp-gpios = <&gpio 3 0 0>;
+				cd-gpios = <&gpio 3 1 0>;
+				cd-inverted;
+				bus-width = <4>;
+				status = "okay";
+			};
 		};
 
 		fab {
