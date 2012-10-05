Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2JEPck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2JEPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/10] ARM: ux500: Supply the STMPE keypad Device Tree node to the STUIB DT
Date: Fri,  5 Oct 2012 16:31:46 +0100
Message-Id: <1349451107-8009-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the STMPE keypad driver to be successfully probed
and initialised during a Device Tree enabled boot sequence. It
contains all of the required properties needed to setup and map
each key on the 6x3 keypad located on the ST User Interface Board.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stuib.dtsi |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/stuib.dtsi
index b25663c..b492e3e 100644
--- a/arch/arm/boot/dts/stuib.dtsi
+++ b/arch/arm/boot/dts/stuib.dtsi
@@ -21,6 +21,33 @@
 
 				i2c-client-wake;
 				st,autosleep-timeout = <1024>;
+
+				stmpe_keypad {
+					compatible = "st,stmpe-keypad";
+
+					debounce-interval = <64>;
+					stericsson,scan-count = <8>;
+					stericsson,no-autorepeat;
+
+					linux,keymap = <0x205006b
+							0x4010074
+							0x3050072
+							0x1030004
+							0x502006a
+							0x500000a
+							0x5008b
+							0x706001c
+							0x405000b
+							0x6070003
+							0x3040067
+							0x303006c
+							0x60400e7
+							0x602009e
+							0x4020073
+							0x5050002
+							0x4030069
+							0x3020008>;
+				};
 			};
 		};
 
-- 
1.7.9.5

