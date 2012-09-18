Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab2IRPwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:52:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44564 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2IRPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:52:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Fix SSP register address format
Date: Tue, 18 Sep 2012 17:52:28 +0200
Message-Id: <1347983548-15243-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSP won't probe unless the specified register address format
is correct i.e. we have to specify that the address is in hex.
After this patch has been applied, the SSP (SPI) driver probes
as expected.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 3708a6b..748ba7a 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -536,7 +536,7 @@
 
 		ssp@80002000 {
 			compatible = "arm,pl022", "arm,primecell";
-			reg = <80002000 0x1000>;
+			reg = <0x80002000 0x1000>;
 			interrupts = <0 14 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.7.9.5

