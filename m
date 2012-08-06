Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2HFKrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:47:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54995 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2HFKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:47:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] ARM: ux500: Force AB8500 to use the GIC as its interrupt controller
Date: Mon,  6 Aug 2012 11:46:39 +0100
Message-Id: <1344250002-6011-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
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
index f236bb7..83229f7 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -313,6 +313,7 @@
 			ab8500@5 {
 				compatible = "stericsson,ab8500";
 				reg = <5>; /* mailbox 5 is i2c */
+				interrupt-parent = <&intc>;
 				interrupts = <0 40 0x4>;
 				interrupt-controller;
 				#interrupt-cells = <2>;
-- 
1.7.9.5

