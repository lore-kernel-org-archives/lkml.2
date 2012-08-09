Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031454Ab2HIPzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:55:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54143 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031435Ab2HIPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:54:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/8] ARM: ux500: Force AB8500 to use the GIC as its interrupt controller
Date: Thu,  9 Aug 2012 16:53:51 +0100
Message-Id: <1344527635-6163-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's understood that the AB8500 should be subordinate to the DB8500;
however, the AB8500 uses the GIC as it's interrupt controller. If
we do not specify which IRQ controller to use the default is to use
the next encountered IRQ controller as we climb the tree. This would
be the DB8500. This patch ensures the AB8500 makes use of the correct
interrupt controller.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 6da7ccb..5106662 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -332,6 +332,7 @@
 			ab8500@5 {
 				compatible = "stericsson,ab8500";
 				reg = <5>; /* mailbox 5 is i2c */
+				interrupt-parent = <&intc>;
 				interrupts = <0 40 0x4>;
 				interrupt-controller;
 				#interrupt-cells = <2>;
-- 
1.7.9.5

