Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2DMAKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:10:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57481 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DMAKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:10:31 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, ralf@linux-mips.org,
        linux-mips@linux-mips.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
Date: Thu, 12 Apr 2012 17:10:19 -0700
Message-Id: <1334275820-7791-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1334275820-7791-1-git-send-email-ddaney.cavm@gmail.com>
References: <1334275820-7791-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

... and create asm/mach-cavium-octeon/gpio.h so that things continue
to build.

This allows us to use the existing I2C connected GPIO expanders.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig                               |    1 +
 arch/mips/include/asm/mach-cavium-octeon/gpio.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/gpio.h

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d0011ef..3134457 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -744,6 +744,7 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
 	select HOLES_IN_ZONE
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
diff --git a/arch/mips/include/asm/mach-cavium-octeon/gpio.h b/arch/mips/include/asm/mach-cavium-octeon/gpio.h
new file mode 100644
index 0000000..34e9f7a
--- /dev/null
+++ b/arch/mips/include/asm/mach-cavium-octeon/gpio.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_MACH_CAVIUM_OCTEON_GPIO_H
+#define __ASM_MACH_CAVIUM_OCTEON_GPIO_H
+
+#ifdef CONFIG_GPIOLIB
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+#else
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+#endif
+
+#include <asm-generic/gpio.h>
+
+#define gpio_to_irq	__gpio_to_irq
+
+#endif /* __ASM_MACH_GENERIC_GPIO_H */
-- 
1.7.2.3

