Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2JEPcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2JEPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] ARM: ux500: Apply a Device Tree node for the STMPE MFD
Date: Fri,  5 Oct 2012 16:31:45 +0100
Message-Id: <1349451107-8009-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we apply the STMPE Multi-Functional Device's node to the
ST User Interface Board Device Tree file. It includes all of
the properties required for correct device initialsation.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stuib.dtsi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/stuib.dtsi
index 62f3ecd..b25663c 100644
--- a/arch/arm/boot/dts/stuib.dtsi
+++ b/arch/arm/boot/dts/stuib.dtsi
@@ -11,6 +11,19 @@
 
 / {
 	soc-u9500 {
+		i2c@80004000 {
+			stmpe1601: stmpe1601@40 {
+				compatible = "st,stmpe1601";
+				reg = <0x40>;
+				interrupts = <26 0x4>;
+				interrupt-parent = <&gpio6>;
+				interrupt-controller;
+
+				i2c-client-wake;
+				st,autosleep-timeout = <1024>;
+			};
+		};
+
 		i2c@80110000 {
 			bu21013_tp@0x5c {
 				compatible = "rhom,bu21013_tp";
-- 
1.7.9.5

