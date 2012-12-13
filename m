Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2LMNXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:23:38 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45783 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2LMNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/8] ARM: ux500: Specify which IOS regulator to use for MMCI
Date: Thu, 13 Dec 2012 13:22:06 +0000
Message-Id: <1355404930-5691-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to move platform specific GPIO controlled regulators
out from platform code we've created a new mechanism to specify
them from within the MMCI driver using the supply name 'vmmc-ios'.
For that to happen when booting device tree, we need to supply it
in the MMCI (SDI) node.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/href.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/href.dtsi b/arch/arm/boot/dts/href.dtsi
index 592fb9d..f2c0f66 100644
--- a/arch/arm/boot/dts/href.dtsi
+++ b/arch/arm/boot/dts/href.dtsi
@@ -87,6 +87,7 @@
 			mmc-cap-sd-highspeed;
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
+			vqmmc-supply = <&vmmci>;
 
 			cd-gpios  = <&tc3589x_gpio 3 0x4>;
 
-- 
1.7.9.5

