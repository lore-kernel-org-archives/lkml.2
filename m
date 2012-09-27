Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2I0PNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:13:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43907 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2I0PM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:12:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/7] ARM: ux500: Create a Device Tree for early HREFs
Date: Thu, 27 Sep 2012 16:12:04 +0100
Message-Id: <1348758726-25336-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348758726-25336-1-git-send-email-lee.jones@linaro.org>
References: <1348758726-25336-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ux500 platform code we currently support a number of devices.
Two of these devices are fairly similar, but have key differences.
Early (pre-v60) HREFs and the more up-to-date versions (v60+), and
they both need to be supported by Device Tree. Here we apply a DT
source file for the earlier versions.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefprev60.dts |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 arch/arm/boot/dts/hrefprev60.dts

diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
new file mode 100644
index 0000000..2dd28b9
--- /dev/null
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -0,0 +1,28 @@
+/*
+ * Copyright 2012 ST-Ericsson AB
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "dbx5x0.dtsi"
+/include/ "href.dtsi"
+
+/ {
+	model = "ST-Ericsson HREF (pre-v60) platform with Device Tree";
+	compatible = "st-ericsson,mop500";
+
+	soc-u9500 {
+		i2c@80004000 {
+			tps61052@33 {
+				compatible = "tps61052";
+				reg = <0x33>;
+			};
+		};
+	};
+};
-- 
1.7.9.5

