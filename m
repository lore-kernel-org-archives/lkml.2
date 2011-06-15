Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1FOTiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:38:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54341 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1FOTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:38:06 -0400
Subject: [PATCH 2/2] gpio/tegra: add devicetree support
To: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Date: Wed, 15 Jun 2011 13:38:04 -0600
Message-ID: <20110615193759.23641.26212.stgit@ponder>
In-Reply-To: <20110615193734.23641.8004.stgit@ponder>
References: <20110615193734.23641.8004.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for decoding gpios from the device tree

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/gpio/gpio_nvidia.txt       |    7 +++++++
 drivers/gpio/gpio-tegra.c                          |   10 ++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_nvidia.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
new file mode 100644
index 0000000..afb3ff3
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
@@ -0,0 +1,7 @@
+NVIDIA Tegra 2 GPIO controller
+
+Required properties:
+- compatible : "nvidia,tegra250-gpio"
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+- gpio-controller : Marks the device node as a GPIO controller.
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 919d638..13afb88 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -23,6 +23,7 @@
 
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 
 #include <asm/mach/irq.h>
 
@@ -340,6 +341,15 @@ static int __init tegra_gpio_init(void)
 		}
 	}
 
+#ifdef CONFIG_OF_GPIO
+	/*
+	 * This isn't ideal, but it gets things hooked up until this
+	 * driver is converted into a platform_device
+	 */
+	tegra_gpio_chip.of_node = of_find_compatible_node(NULL, NULL,
+						"nvidia,tegra250-gpio");
+#endif /* CONFIG_OF_GPIO */
+
 	gpiochip_add(&tegra_gpio_chip);
 
 	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {

