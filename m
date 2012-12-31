Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2LaCiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:38:23 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40422 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LaCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:38:16 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] ODROID-X: dts: Add nodes for leds based on GPIO.
Date: Mon, 31 Dec 2012 11:35:12 +0900
Message-Id: <1356921314-12595-4-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
References: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds GPIO connected LEDS on ODROID-X board and configure its
properties.

LED1: use 'heartbeat' trigger, blinking while the board is running.
LED2: use 'mmc0' trigger, on when mmc0 is accessing.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index 213b152..f31529f 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -54,4 +54,20 @@
 		enable-active-high;
 		regulator-boot-on;
 	};
+
+	leds {
+		compatible = "gpio-leds";
+		led1 {
+			label = "led1:heart";
+			gpios = <&gpc1 0 1>;
+			default-state = "on";
+			linux,default-trigger = "heartbeat";
+		};
+		led2 {
+			label = "led2:mmc0";
+			gpios = <&gpc1 2 1>;
+			default-state = "on";
+			linux,default-trigger = "mmc0";
+		};
+	};
 };
-- 
1.7.10.4

