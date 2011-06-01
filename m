Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab1FAJte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:49:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40391 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753235Ab1FAJtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:49:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, grant@secretlab.ca,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] FRV: Hook up gpiolib support
Date: Wed,  1 Jun 2011 10:49:27 +0100
Message-Id: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow people to use gpiolib on FRV, mostly for build coverage as it
seems more useful to standardise the API than handle making it optional.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/frv/Kconfig            |    4 +++
 arch/frv/include/asm/gpio.h |   55 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 arch/frv/include/asm/gpio.h

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index cb884e4..8e828fc 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select ARCH_WANT_OPTIONAL_GPIO
 
 config ZONE_DMA
 	bool
@@ -27,6 +28,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default n
 
+config GENERIC_GPIO
+	def_bool y
+
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/frv/include/asm/gpio.h b/arch/frv/include/asm/gpio.h
new file mode 100644
index 0000000..8c3377f
--- /dev/null
+++ b/arch/frv/include/asm/gpio.h
@@ -0,0 +1,55 @@
+/*
+ * Generic GPIO API implementation for FRV.
+ *
+ * A stright copy of that for PowerPC which was:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _ASM_FRV_GPIO_H
+#define _ASM_FRV_GPIO_H
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * We don't (yet) implement inlined/rapid versions for on-chip gpios.
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* _ASM_FRV_GPIO_H */
-- 
1.7.5.3

