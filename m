Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab1BPHwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:52:50 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:42713 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1BPHwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:52:47 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Wed, 16 Feb 2011 15:52:42 +0800
Message-ID: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrnhhwW+xjL7XQt+t6hsJOj3xTw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <bca6d64c27c47036b940df5085b899a38fa15a82.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:28:19 +0800

This patch implements arch-specific ps2 driver.

By reviewed with Dmitry Torokhov:
     1. move i8042-ucio.h to drivers/input/serio/i8042-unicore32io.h
     2. move puv3_ps2_init() to arch/unicore32/kernel/puv3-core.c
     3. remove unused comments.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/i8042-unicore32io.h |   70 +++++++++++++++++++++++++++++++
 drivers/input/serio/i8042.h             |    2 +
 2 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/i8042-unicore32io.h

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
new file mode 100644
index 0000000..6a7e8b3
--- /dev/null
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -0,0 +1,70 @@
+/*
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2011 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _I8042_UNICORE32_H
+#define _I8042_UNICORE32_H
+
+#include <mach/hardware.h>
+
+/*
+ * Names.
+ */
+#define I8042_KBD_PHYS_DESC "isa0060/serio0"
+#define I8042_AUX_PHYS_DESC "isa0060/serio1"
+#define I8042_MUX_PHYS_DESC "isa0060/serio%d"
+
+/*
+ * IRQs.
+ */
+#define I8042_KBD_IRQ           IRQ_PS2_KBD
+#define I8042_AUX_IRQ           IRQ_PS2_AUX
+
+/*
+ * Register numbers.
+ */
+#define I8042_COMMAND_REG	((unsigned long)&PS2_COMMAND)
+#define I8042_STATUS_REG	((unsigned long)&PS2_STATUS)
+#define I8042_DATA_REG		((unsigned long)&PS2_DATA)
+
+static inline int i8042_read_data(void)
+{
+	return inb(I8042_DATA_REG);
+}
+
+static inline int i8042_read_status(void)
+{
+	return inb(I8042_STATUS_REG);
+}
+
+static inline void i8042_write_data(int val)
+{
+	outb(val, I8042_DATA_REG);
+}
+
+static inline void i8042_write_command(int val)
+{
+	outb(val, I8042_COMMAND_REG);
+}
+
+static inline int i8042_platform_init(void)
+{
+	if (!request_region(I8042_DATA_REG, 16, "i8042"))
+		return -EBUSY;
+
+	i8042_reset = 1;
+	return 0;
+}
+
+static inline void i8042_platform_exit(void)
+{
+	release_region(I8042_DATA_REG, 16);
+}
+
+#endif /* _I8042_UNICORE32_H */
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..e0fe4af 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -26,6 +26,8 @@
 #include "i8042-sparcio.h"
 #elif defined(CONFIG_X86) || defined(CONFIG_IA64)
 #include "i8042-x86ia64io.h"
+#elif defined(CONFIG_UNICORE32)
+#include "i8042-unicore32io.h"
 #else
 #include "i8042-io.h"
 #endif
-- 
1.6.2.2


