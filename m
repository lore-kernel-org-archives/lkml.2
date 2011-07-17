Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1GQPKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:10:41 -0400
Received: from mail.southpole.se ([193.12.106.18]:34899 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1GQPJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:40 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v3 13/19] OpenRISC: GPIO
Date: Sun, 17 Jul 2011 17:08:23 +0200
Message-Id: <a6921c54ff60a21ec4fee2f3266a1ed200710f00.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/openrisc/include/asm/gpio.h |   65 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/gpio.h

diff --git a/arch/openrisc/include/asm/gpio.h b/arch/openrisc/include/asm/gpio.h
new file mode 100644
index 0000000..0b0d174
--- /dev/null
+++ b/arch/openrisc/include/asm/gpio.h
@@ -0,0 +1,65 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_GPIO_H
+#define __ASM_OPENRISC_GPIO_H
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * OpenRISC (or1k) does not have on-chip GPIO's so there is not really
+ * any standardized implementation that makes sense here.  If passing
+ * through gpiolib becomes a bottleneck then it may make sense, on a
+ * case-by-case basis, to implement these inlined/rapid versions.
+ *
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
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* __ASM_OPENRISC_GPIO_H */
-- 
1.7.4.1

