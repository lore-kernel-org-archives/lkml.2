Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031451Ab2I1TiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:38:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031402Ab2I1Th4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:56 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 7/7] ARM: dts: AM33xx PRUSS support
Date: Fri, 28 Sep 2012 15:37:52 -0400
Message-Id: <1348861072-14507-8-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a pruss node and an example of use on Beaglebone.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am335x-bone.dts |    4 ++++
 arch/arm/boot/dts/am33xx.dtsi     |   11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index c634f87..9e070c2 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -78,3 +78,7 @@
 		};
 	};
 };
+
+&pruss {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index bb31bff..399feb3 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -210,5 +210,16 @@
 			interrupt-parent = <&intc>;
 			interrupts = <91>;
 		};
+
+		pruss: pruss@4a300000 {
+			compatible = "ti,pruss-v2";
+			ti,hwmods = "pruss";
+			ti,deassert-hard-reset = "pruss", "pruss";
+			reg = <0x4a300000 0x080000>;
+			ti,pintc-offset = <0x20000>;
+			interrupt-parent = <&intc>;
+			interrupts = <20 21 22 23 24 25 26 27>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

