Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2FKP0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:26:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2FKPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/14] ARM: ux500: Enable the AB8500 RTC for all DT:ed DB8500 based devices
Date: Mon, 11 Jun 2012 16:25:06 +0100
Message-Id: <1339428307-3850-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add a node for the AB8500 Real Time Clock in all devices
supporting the DB8500. The AB8500 RTC driver makes use of named
interrupts we provide support for this too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 55a36ae..26f895f 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -315,6 +315,13 @@
 				interrupt-controller;
 				#interrupt-cells = <2>;
 
+				ab8500-rtc {
+					compatible = "stericsson,ab8500-rtc";
+					interrupts = <17 0x4
+					              18 0x4>;
+					interrupt-names = "60S", "ALARM";
+				};
+
 				ab8500-gpadc {
 					compatible = "stericsson,ab8500-gpadc";
 					interrupts = <32 0x4
-- 
1.7.9.5

