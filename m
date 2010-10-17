Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0JQPnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:43:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab0JQPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CWEmuWK2kr5/+95vVKjeZCGMFc6Fndb5YGNJpArszxUXuQjwacgZHwR45uLUG3Hepu
         ftP28te3h80xh+RVs2KmOvolLa9/ZL9bLV7KNvIboEjkvP9tUZWNl4oIV3qdDrtgr/b+
         vvS+wKNHb3K0V9KmXu1Z9BpAvm5GgRrtVL7DA=
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] powerpc/83xx: Add additional i2c peripherals to MPC8315ERDB board
Date: Sun, 17 Oct 2010 17:43:39 +0200
Message-Id: <1287330219-3420-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.6.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the additional i2c peripherals found on the board,
including an LM75 temperature sensor, an AT24 i2c eeprom and a
PCF8574A port expander.

This can also probably be applied on many other MPC8xxx boards.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 arch/powerpc/boot/dts/mpc8315erdb.dts |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8315erdb.dts b/arch/powerpc/boot/dts/mpc8315erdb.dts
index 4dd08c3..f89d9fd 100644
--- a/arch/powerpc/boot/dts/mpc8315erdb.dts
+++ b/arch/powerpc/boot/dts/mpc8315erdb.dts
@@ -118,11 +118,29 @@
 			interrupts = <14 0x8>;
 			interrupt-parent = <&ipic>;
 			dfsrr;
+
 			rtc@68 {
 				compatible = "dallas,ds1339";
 				reg = <0x68>;
 			};
 
+                        dtt@48 {
+                                compatible = "national,lm75";
+                                reg = <0x48>;
+                        };
+
+                        at24@50 {
+                                compatible = "at24,24c256";
+                                reg = <0x50>;
+                        };
+
+                        pcf: iexp@39 {
+                                #gpio-cells = <2>;
+                                compatible = "ti,pcf8574a";
+                                reg = <0x39>;
+                                gpio-controller;
+                        };
+
 			mcu_pio: mcu@a {
 				#gpio-cells = <2>;
 				compatible = "fsl,mc9s08qg8-mpc8315erdb",
-- 
1.5.6.5

