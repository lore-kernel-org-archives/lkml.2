Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2KEGA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:00:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab2KEGA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:00:26 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: Ravi Babu <ravibabu@ti.com>,
        Santhapuri Damodar <damodar.santhapuri@ti.com>,
        Daniel Mack <zonque@gmail.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, AnilKumar Ch <anilkumar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: dts: AM33XX: Add usbss node
Date: Mon, 5 Nov 2012 11:29:59 +0530
Message-ID: <1352095204-29028-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajay Kumar Gupta <ajay.gupta@ti.com>

Device tree node for usbss on AM33XX. There are two musb
controllers on am33xx platform so have port0-mode and
port1-mode data.

[afzal@ti.com: reg & interrupt property addition]

Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Santhapuri, Damodar <damodar.santhapuri@ti.com>
Signed-off-by: Ravi Babu <ravibabu@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

Hi Benoit,

This is based on your "for_3.8/dts" branch.

This is made on top of "usb: musb: am335x support"
(http://marc.info/?l=linux-omap&m=135187391904863&w=2)
and has been tested on Beagle Bone.

Regards
Afzal

 arch/arm/boot/dts/am33xx.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 5dfd682..78340a5 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -321,5 +321,22 @@
 			ti,hwmods = "spi1";
 			status = "disabled";
 		};
+
+		usb_otg_hs@47400000 {
+			compatible = "ti,musb-am33xx";
+			reg = <0x47400000 0x1000	/* usbss */
+			       0x47401000 0x800		/* musb instance 0 */
+			       0x47401800 0x800>;	/* musb instance 1 */
+			interrupts = <17		/* usbss */
+				      18		/* musb instance 0 */
+				      19>;		/* musb instance 1 */
+			multipoint = <1>;
+			num-eps = <16>;
+			ram-bits = <12>;
+			port0-mode = <3>;
+			port1-mode = <3>;
+			power = <250>;
+			ti,hwmods = "usb_otg_hs";
+		};
 	};
 };
-- 
1.7.12

