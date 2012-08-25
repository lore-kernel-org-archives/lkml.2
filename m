Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2HYSQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:16:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58550 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414Ab2HYSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:16:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clkdev: Add default clkdev.h
Date: Sat, 25 Aug 2012 11:16:10 -0700
Message-Id: <1345918571-4099-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ease the deployment of clkdev by providing a default asm/clkdev.h which
will be used if the arch does not have an include/asm/clkdev.h.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/asm-generic/Kbuild.asm |    4 ++++
 include/asm-generic/clkdev.h   |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 include/asm-generic/clkdev.h

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index c5d2e5d..da121e0 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -13,6 +13,10 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
 header-y += a.out.h
 endif
 
+ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/clkdev.h),)
+generic-y += clkdev.h
+endif
+
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/include/asm-generic/clkdev.h b/include/asm-generic/clkdev.h
new file mode 100644
index 0000000..90a32a6
--- /dev/null
+++ b/include/asm-generic/clkdev.h
@@ -0,0 +1,28 @@
+/*
+ *  include/asm-generic/clkdev.h
+ *
+ * Based on the ARM clkdev.h:
+ *  Copyright (C) 2008 Russell King.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper for the clk API to assist looking up a struct clk.
+ */
+#ifndef __ASM_CLKDEV_H
+#define __ASM_CLKDEV_H
+
+#include <linux/slab.h>
+
+struct clk;
+
+static inline int __clk_get(struct clk *clk) { return 1; }
+static inline void __clk_put(struct clk *clk) { }
+
+static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+#endif
-- 
1.7.10.4

