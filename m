Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2LJI4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:56:31 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47497 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2LJI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/12] ARM: ux500: Set correct MMCI regulator voltages in the ux5x0 Device Tree
Date: Mon, 10 Dec 2012 08:55:55 +0000
Message-Id: <1355129761-8088-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltages for the MMCI GPIO controlled voltage regulation differ
depending on who you believe and where you pick the information up
from. More recent internal code suggests that the true upper voltage
from the shifter is actually v3.3, instead of the previously
indicated v2.9. Let's mirror that change in the Device Tree file.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 9f55363..bbea89a 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -634,12 +634,12 @@
 			compatible = "regulator-gpio";
 
 			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <2600000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
 			states = <1800000 0x1
-				  2900000 0x0>;
+				  3300000 0x0>;
 
 			status = "disabled";
 		};
-- 
1.7.9.5

