Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2A0CpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:53756 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2A0Co6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:44:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/7] bug.h: add include of it to various implicit C users
Date: Thu, 26 Jan 2012 21:44:29 -0500
Message-Id: <1327632272-12928-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With bug.h currently living right in linux/kernel.h there
are files that use BUG_ON and friends but are not including
the header explicitly.  Fix them up so we can remove the
presence in kernel.h file.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-ux500/board-mop500-pins.c         |    1 +
 arch/mips/fw/arc/cmdline.c                      |    1 +
 arch/mips/fw/arc/identify.c                     |    1 +
 arch/powerpc/kernel/pmc.c                       |    1 +
 arch/powerpc/xmon/ppc-opc.c                     |    1 +
 arch/powerpc/xmon/spu-opc.c                     |    1 +
 arch/x86/kernel/paravirt.c                      |    1 +
 arch/x86/mm/kmemcheck/selftest.c                |    1 +
 drivers/gpu/drm/radeon/cayman_blit_shaders.c    |    1 +
 drivers/gpu/drm/radeon/evergreen_blit_shaders.c |    1 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c      |    1 +
 lib/bitmap.c                                    |    1 +
 lib/iommu-helper.c                              |    1 +
 lib/list_debug.c                                |    1 +
 lib/plist.c                                     |    1 +
 lib/string.c                                    |    1 +
 lib/timerqueue.c                                |    1 +
 17 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 74bfcff..f5413dc 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/bug.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
diff --git a/arch/mips/fw/arc/cmdline.c b/arch/mips/fw/arc/cmdline.c
index 9fdf07e..c0122a1 100644
--- a/arch/mips/fw/arc/cmdline.c
+++ b/arch/mips/fw/arc/cmdline.c
@@ -7,6 +7,7 @@
  *
  * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
+#include <linux/bug.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/arch/mips/fw/arc/identify.c b/arch/mips/fw/arc/identify.c
index 788060a..54a33c7 100644
--- a/arch/mips/fw/arc/identify.c
+++ b/arch/mips/fw/arc/identify.c
@@ -11,6 +11,7 @@
  *
  * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
+#include <linux/bug.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/arch/powerpc/kernel/pmc.c b/arch/powerpc/kernel/pmc.c
index a841a9d..58eaa3d 100644
--- a/arch/powerpc/kernel/pmc.c
+++ b/arch/powerpc/kernel/pmc.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/bug.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
 
diff --git a/arch/powerpc/xmon/ppc-opc.c b/arch/powerpc/xmon/ppc-opc.c
index af3780e..6845e91 100644
--- a/arch/powerpc/xmon/ppc-opc.c
+++ b/arch/powerpc/xmon/ppc-opc.c
@@ -22,6 +22,7 @@
 
 #include <linux/stddef.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include "nonstdio.h"
 #include "ppc.h"
 
diff --git a/arch/powerpc/xmon/spu-opc.c b/arch/powerpc/xmon/spu-opc.c
index 530df3d..7d37597 100644
--- a/arch/powerpc/xmon/spu-opc.c
+++ b/arch/powerpc/xmon/spu-opc.c
@@ -19,6 +19,7 @@
    51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */
 
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include "spu.h"
 
 /* This file holds the Spu opcode table */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..83e7b81 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -26,6 +26,7 @@
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
+#include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/mm/kmemcheck/selftest.c b/arch/x86/mm/kmemcheck/selftest.c
index 036efbe..aef7140 100644
--- a/arch/x86/mm/kmemcheck/selftest.c
+++ b/arch/x86/mm/kmemcheck/selftest.c
@@ -1,3 +1,4 @@
+#include <linux/bug.h>
 #include <linux/kernel.h>
 
 #include "opcode.h"
diff --git a/drivers/gpu/drm/radeon/cayman_blit_shaders.c b/drivers/gpu/drm/radeon/cayman_blit_shaders.c
index 7b4eeb7..19a0114 100644
--- a/drivers/gpu/drm/radeon/cayman_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/cayman_blit_shaders.c
@@ -24,6 +24,7 @@
  *     Alex Deucher <alexander.deucher@amd.com>
  */
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 
diff --git a/drivers/gpu/drm/radeon/evergreen_blit_shaders.c b/drivers/gpu/drm/radeon/evergreen_blit_shaders.c
index 3a10399..f85c0af 100644
--- a/drivers/gpu/drm/radeon/evergreen_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/evergreen_blit_shaders.c
@@ -24,6 +24,7 @@
  *     Alex Deucher <alexander.deucher@amd.com>
  */
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 
diff --git a/drivers/gpu/drm/radeon/r600_blit_shaders.c b/drivers/gpu/drm/radeon/r600_blit_shaders.c
index 2d1f6c5..3af3c64 100644
--- a/drivers/gpu/drm/radeon/r600_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/r600_blit_shaders.c
@@ -24,6 +24,7 @@
  *     Alex Deucher <alexander.deucher@amd.com>
  */
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0d4a127..90a683b 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/bug.h>
 #include <asm/uaccess.h>
 
 /*
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index da05331..8b1ab62 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/bitmap.h>
+#include <linux/bug.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 			   unsigned long shift,
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 7204e61..1bf2fe3 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
 
 /*
diff --git a/lib/plist.c b/lib/plist.c
index a0a4da4..6ab0e52 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -23,6 +23,7 @@
  * information.
  */
 
+#include <linux/bug.h>
 #include <linux/plist.h>
 #include <linux/spinlock.h>
 
diff --git a/lib/string.c b/lib/string.c
index dc4a863..0573a20 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/bug.h>
 #include <linux/module.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index 191176a..9230231 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -25,6 +25,7 @@
 #include <linux/timerqueue.h>
 #include <linux/rbtree.h>
 #include <linux/module.h>
+#include <linux/bug.h>
 
 /**
  * timerqueue_add - Adds timer to timerqueue.
-- 
1.7.7.2

