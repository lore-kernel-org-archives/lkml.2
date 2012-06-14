Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2FNQvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:51 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29135 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932135Ab2FNQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:34 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 07/23] ARM: LPC32xx: DTS adjustment for key matrix controller
Date: Thu, 14 Jun 2012 18:50:57 +0200
Message-Id: <1339692673-7848-8-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch connects the lpc32xx-key driver to the LPC32xx platform (via
lpc32xx.dtsi), and more specifically to the reference board via its dts file.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---

 arch/arm/boot/dts/lpc32xx.dtsi |    2 ++
 arch/arm/boot/dts/phy3250.dts  |    9 +++++++++
 2 files changed, 11 insertions(+)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -249,6 +249,8 @@
 			key@40050000 {
 				compatible = "nxp,lpc3220-key";
 				reg = <0x40050000 0x1000>;
+				interrupts = <54 0>;
+				status = "disabled";
 			};
 
 		};
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -135,6 +135,15 @@
 			tsc@40048000 {
 				status = "okay";
 			};
+
+			key@40050000 {
+				status = "okay";
+				keypad,num-rows = <1>;
+				keypad,num-columns = <1>;
+				nxp,debounce-delay-ms = <3>;
+				nxp,scan-delay-ms = <34>;
+				linux,keymap = <0x00000002>;
+			};
 		};
 	};
 
