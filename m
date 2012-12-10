Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2LJI5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:57:49 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49158 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2LJI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/12] ARM: ux500: Specify the ux5x0 MMCI regulator's on/off GPIO as high-enable
Date: Mon, 10 Dec 2012 08:55:56 +0000
Message-Id: <1355129761-8088-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not specified, the GPIO control bit is inverted by default i.e.
low-enable and high-disable. This is not the case with the MMCI
regulator, hence it will turn on during a disable and off when
regulator_enable() is invoked.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index bbea89a..0523681 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -638,6 +638,8 @@
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
+			enable-active-high;
+
 			states = <1800000 0x1
 				  3300000 0x0>;
 
-- 
1.7.9.5

