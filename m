Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0HOQRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:17:48 -0400
Received: from king.tilera.com ([72.1.168.226]:36946 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab0HOQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:17:47 -0400
Message-Id: <201008151617.o7FGHiUb004190@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 15 Aug 2010 12:14:41 -0400
Subject: [PATCH] arch/tile: export only COMMAND_LINE_SIZE to userspace.
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>
X-OriginalArrivalTime: 15 Aug 2010 16:17:46.0407 (UTC) FILETIME=[65B0CB70:01CB3C95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a failure in "make headers_check" for tile.
I hadn't realized this file was exported to userspace by default.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/setup.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
index 823ddd4..7caf0f3 100644
--- a/arch/tile/include/asm/setup.h
+++ b/arch/tile/include/asm/setup.h
@@ -15,6 +15,10 @@
 #ifndef _ASM_TILE_SETUP_H
 #define _ASM_TILE_SETUP_H
 
+#define COMMAND_LINE_SIZE	2048
+
+#ifdef __KERNEL__
+
 #include <linux/pfn.h>
 #include <linux/init.h>
 
@@ -23,10 +27,10 @@
  */
 #define MAXMEM_PFN	PFN_DOWN(MAXMEM)
 
-#define COMMAND_LINE_SIZE	2048
-
 void early_panic(const char *fmt, ...);
 void warn_early_printk(void);
 void __init disable_early_printk(void);
 
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_TILE_SETUP_H */
-- 
1.6.5.2

