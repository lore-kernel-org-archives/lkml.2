Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043Ab2COSfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:35:32 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57903 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762029Ab2COSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:35:27 -0400
From: Aneesh V <aneesh@ti.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Aneesh V <aneesh@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 2/4] dt: emif: device tree bindings for TI's EMIF sdram controller
Date: Fri, 16 Mar 2012 00:04:05 +0530
Message-Id: <1331836447-7584-3-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1331836447-7584-1-git-send-email-aneesh@ti.com>
References: <1331836447-7584-1-git-send-email-aneesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EMIF - External Memory Interface - is an SDRAM controller used in
TI SoCs. EMIF supports, based on the IP revision, one or more of
DDR2/DDR3/LPDDR2 protocols. This binding describes a given instance
of the EMIF IP and memory parts attached to it.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Aneesh V <aneesh@ti.com>
---
---
 .../bindings/memory-controllers/ti/emif.txt        |   55 ++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti/emif.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/ti/emif.txt b/Documentation/devicetree/bindings/memory-controllers/ti/emif.txt
new file mode 100644
index 0000000..938f8e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/ti/emif.txt
@@ -0,0 +1,55 @@
+* EMIF family of TI SDRAM controllers
+
+EMIF - External Memory Interface - is an SDRAM controller used in
+TI SoCs. EMIF supports, based on the IP revision, one or more of
+DDR2/DDR3/LPDDR2 protocols. This binding describes a given instance
+of the EMIF IP and memory parts attached to it.
+
+Required properties:
+- compatible	: Should be of the form "ti,emif-<ip-rev>" where <ip-rev>
+  is the IP revision of the specific EMIF instance.
+
+- phy-type	: <u32> indicating the DDR phy type. Following are the
+  allowed values
+  <1>	: Attila PHY
+  <2>	: Intelli PHY
+
+- device-handle	: phandle to a "lpddr2" node representing the memory part
+
+- ti,hwmods	: For TI hwmods processing and omap device creation
+  the value shall be "emif<n>" where <n> is the number of the EMIF
+  instance with base 1.
+
+Optional properties:
+- cs1-used		: Have this property if CS1 of this EMIF
+  instance has a memory part attached to it. If there is a memory
+  part attached to CS1, it should be the same type as the one on CS0,
+  so there is no need to give the details of this memory part.
+
+- cal-resistor-per-cs	: Have this property if the board has one
+  calibration resistor per chip-select.
+
+- hw-caps-read-idle-ctrl: Have this property if the controller
+  supports read idle window programming
+
+- hw-caps-dll-calib-ctrl: Have this property if the controller
+  supports dll calibration control
+
+- hw-caps-ll-interface	: Have this property if the controller
+  has a low latency interface and corresponding interrupt events
+
+- hw-caps-temp-alert	: Have this property if the controller
+  has capability for generating SDRAM temperature alerts
+
+Example:
+
+emif1: emif@0x4c000000 {
+	compatible	= "ti,emif-4d";
+	ti,hwmods	= "emif2";
+	phy-type	= <1>;
+	device-handle	= <&elpida_ECB240ABACN>;
+	cs1-used;
+	hw-caps-read-idle-ctrl;
+	hw-caps-ll-interface;
+	hw-caps-temp-alert;
+};
-- 
1.7.1

