Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2LEFmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 00:42:00 -0500
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:36626 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab2LEFl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 00:41:57 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, rob@landley.net, sameo@linux.intel.com,
        haojian.zhuang@gmail.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, zhouqiao@marvell.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Documentation: add docs for 88pm80x dt
Date: Wed,  5 Dec 2012 13:42:00 +0800
Message-Id: <1354686120-26169-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 05 Dec 2012 05:41:51.0870 (UTC) FILETIME=[3A0BB9E0:01CDD2AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 Documentation/devicetree/bindings/mfd/88pm80x.txt |   52 +++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm80x.txt

diff --git a/Documentation/devicetree/bindings/mfd/88pm80x.txt b/Documentation/devicetree/bindings/mfd/88pm80x.txt
new file mode 100644
index 0000000..8a0ed07
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/88pm80x.txt
@@ -0,0 +1,52 @@
+* Marvell 88pm80x Power Management IC
+
+Required parent device properties:
+- compatible : "marvell,88pm80x"
+- reg : the I2C slave address for the 88pm80x chip
+- interrupts : IRQ line for the 88pm80x chip
+- interrupt-controller: describes the 88pm80x as an interrupt controller (has its own domain)
+- #interrupt-cells : should be 1.
+	- The cell is the 88pm80x local IRQ number
+
+Optional parent device properties:
+- marvell,88pm80x-irqmode: inicates whether interrupt status is cleared by read
+- marvell,88pm80x-poweraddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
+				of one chip, and this property stores the I2C address of
+				power related chip.
+- marvell,88pm80x-gpadcaddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
+				of one chip, and this property stores the I2C address of
+				gpadc related chip.
+
+88pm80x consists of various groups of sub-devices:
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+88pm80x-onkey		:		: On key
+88pm80x-rtc		:		: RTC
+
+Example:
+	pmic: 88pm800@30 {
+		compatible = "marvell,88pm80x";
+		reg = <0x30>;
+		interrupts = <4>;
+		interrupt-parent = <&intc>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		marvell,88pm80x-irqmode = 0;
+		marvell,88pm80x-poweraddr = <0x31>;
+		marvell,88pm80x-gpadcaddr = <0x32>;
+	};
+
+
+	pmic: 88pm805@38 {
+		compatible = "marvell,88pm80x";
+		reg = <0x38>;
+		interrupts = <124>;
+		interrupt-parent = <&gpio>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		marvell,88pm80x-irqmode = 0;
+	};
+
-- 
1.7.0.4

