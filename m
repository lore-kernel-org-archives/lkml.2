Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1LVO7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:59:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1LVO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:47 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH v4 07/12] arm/dts: twl6030: Add DTS file for twl6030 PMIC
Date: Thu, 22 Dec 2011 15:56:41 +0100
Message-ID: <1324565806-31142-8-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dedicated DTS file for the twl6030 Power IC.
This chip is a big SoC that will be reused in a lot of various
OMAP4+ boards.

Note: This file is supposed to be included in a board DTS that will
create the twl node in order to allow the &twl reference to work.

Exmaple:
...
&i2c1 {
    twl: twl@48 {
        reg = <0x48>;
        interrupts = <0 7 4>;
        interrupt-controller;
        interrupt-parent = <&gic>;
    };
};

/include/ "twl6030.dtsi"
...

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/twl6030.dtsi |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/twl6030.dtsi

diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
new file mode 100644
index 0000000..b7b4e5e
--- /dev/null
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Integrated Power Management Chip
+ * http://www.ti.com/lit/ds/symlink/twl6030.pdf
+ */
+&twl {
+	compatible = "ti,twl6030";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+
+	rtc {
+		compatible = "ti,twl4030-rtc";
+		interrupts = <11>;
+	};
+};
-- 
1.7.0.4

