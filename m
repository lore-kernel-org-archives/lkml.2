Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030714Ab2K3PZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:25:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54621 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519Ab2K3PZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:25:06 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Change IRQ from low-to-high edge triggered to high-to-low
Date: Fri, 30 Nov 2012 15:24:59 +0000
Message-Id: <1354289099-17931-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the STMPE IRQ is triggered to be active high level-sensitive, the
Nomadik GPIO controller it uses complains, although it still works.
Recently we attempted to move triggering to low-to-high in an attempt
to prevent the warning; however, this ensured that the IRQ was actually
missed completely. Now we have a solution which both works and keeps the
GPIO controller happy.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stuib.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/stuib.dtsi
index 39446a2..615392a 100644
--- a/arch/arm/boot/dts/stuib.dtsi
+++ b/arch/arm/boot/dts/stuib.dtsi
@@ -15,7 +15,7 @@
 			stmpe1601: stmpe1601@40 {
 				compatible = "st,stmpe1601";
 				reg = <0x40>;
-				interrupts = <26 0x1>;
+				interrupts = <26 0x2>;
 				interrupt-parent = <&gpio6>;
 				interrupt-controller;
 
-- 
1.7.9.5

