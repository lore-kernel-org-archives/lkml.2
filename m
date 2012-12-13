Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2LMNX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:23:59 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64383 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2LMNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] ARM: ux500: Specify the ux5x0 MMCI regulator's on/off GPIO as high-enable
Date: Thu, 13 Dec 2012 13:22:05 +0000
Message-Id: <1355404930-5691-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not specified, the GPIO control bit is inverted by default i.e.
low-enable and high-disable. This is not the case with the MMCI
regulator, hence it will turn on during a disable and off when
regulator_enable() is invoked.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 6b1aa6d..88f90217 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -638,6 +638,8 @@
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
+			enable-active-high;
+
 			states = <1800000 0x1
 				  2900000 0x0>;
 
-- 
1.7.9.5

