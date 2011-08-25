Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1HYXoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:44:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36058 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1HYXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:43:59 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 02/13] docs/dt: Document nvidia,tegra20-gpio's nvidia,enabled-gpios property
Date: Thu, 25 Aug 2011 17:43:33 -0600
Message-Id: <1314315824-9687-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/gpio/gpio_nvidia.txt       |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
index eb4b530..b22fff3 100644
--- a/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
@@ -6,3 +6,23 @@ Required properties:
   second cell is used to specify optional parameters:
   - bit 0 specifies polarity (0 for normal, 1 for inverted)
 - gpio-controller : Marks the device node as a GPIO controller.
+
+Optional properties:
+- nvidia,enabled-gpios : The list of GPIOs that should be controlled by the
+  GPIO controller rather than the pinmux controller.
+
+Example of a gpio-controller node:
+
+	gpio: gpio@6000d000 {
+		compatible = "nvidia,tegra20-gpio";
+		reg = < 0x6000d000 0x1000 >;
+		interrupts = < 64 65 66 67 87 119 121 >;
+		#gpio-cells = <2>;
+		gpio-controller;
+		nvidia,enabled-gpios = <
+			69	// TEGRA_GPIO_PI5 SD2_CD
+			57	// TEGRA_GPIO_PH1 SD2_WP
+			155	// TEGRA_GPIO_PT3 SD2_POWER
+		>;
+	};
+
-- 
1.7.0.4

