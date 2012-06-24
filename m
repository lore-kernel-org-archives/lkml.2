Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2FXNtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:49:01 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:50872 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755973Ab2FXNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:43 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/7] ARM: LPC32xx: Update DTS file for EA3250 board
Date: Sun, 24 Jun 2012 15:47:14 +0200
Message-Id: <1340545637-5449-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This DTS file update adds:
* 3-channel ADC (for AD-IN on AD2, or 3-axis-accelerometer)
* Interrupt key

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/ea3250.dts |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- linux-2.6.orig/arch/arm/boot/dts/ea3250.dts
+++ linux-2.6/arch/arm/boot/dts/ea3250.dts
@@ -152,6 +152,23 @@
 			uart1: serial@40014000 {
 				status = "okay";
 			};
+
+			/* 3-axis accelerometer X,Y,Z (or AD-IN instead of Z) */
+			adc@40048000 {
+				status = "okay";
+			};
+		};
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		autorepeat;
+		button@21 {
+			label = "GPIO Key UP";
+			linux,code = <103>;
+			gpios = <&gpio 4 1 0>; /* GPI_P3 1 */
 		};
 	};
 };
