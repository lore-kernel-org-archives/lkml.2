Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2HFKrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:47:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59249 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2HFKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:47:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] ARM: ux500: Identify the PRCMU as an interrupt controller
Date: Mon,  6 Aug 2012 11:46:37 +0100
Message-Id: <1344250002-6011-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're just about to provide the DB8500-PRCMU with its own IRQ domain,
so that its subordinate drivers can use it as an interrupt controller.
It's obligatory for all IRQ controllers to reference themselves as
such from its own node in Device Tree. This patch does just that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 241213c..f236bb7 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -194,6 +194,8 @@
 			interrupts = <0 47 0x4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			ranges;
 
 			prcmu-timer-4@80157450 {
-- 
1.7.9.5

