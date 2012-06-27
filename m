Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2F0W0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:26:37 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:47083 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754869Ab2F0W0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:26:34 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/8] ARM: LPC32xx: Update DTS file for EA3250 board
Date: Thu, 28 Jun 2012 00:26:14 +0200
Message-Id: <1340835978-20331-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1340835978-20331-1-git-send-email-stigge@antcom.de>
References: <1340835978-20331-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This DTS file update adds:
* 3-channel ADC (for AD-IN on AD2, or 3-axis-accelerometer)
* Interrupt key

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

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
