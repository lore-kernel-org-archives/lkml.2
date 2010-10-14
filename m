Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0JNVSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:18:00 -0400
Received: from king.tilera.com ([72.1.168.226]:52857 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab0JNVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:15 -0400
Message-Id: <45123f7e74e004848da765f3182cd401a38d354d.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 15:16:59 -0400
Subject: [PATCH 05/14] arch/tile: various top-level Makefile cleanups
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:14.0293 (UTC) FILETIME=[08685850:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a compile failure if CONFIG_DEBUG_EXTRA_FLAGS is empty ("");
provide an "install" hook as well as a matching archhelp target;
and some minor whitespace cleanup.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Makefile |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index fd8f6bb..a700f7f 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -26,8 +26,9 @@ $(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
   endif
 endif
 
-
+ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
+endif
 
 LIBGCC_PATH     := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
@@ -49,6 +50,18 @@ head-y		:= arch/tile/kernel/head_$(BITS).o
 libs-y		+= arch/tile/lib/
 libs-y		+= $(LIBGCC_PATH)
 
-
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
+
+ifdef TILERA_ROOT
+INSTALL_PATH ?= $(TILERA_ROOT)/tile/boot
+endif
+
+install:
+	install -D -m 755 vmlinux $(INSTALL_PATH)/vmlinux-$(KERNELRELEASE)
+	install -D -m 644 .config $(INSTALL_PATH)/config-$(KERNELRELEASE)
+	install -D -m 644 System.map $(INSTALL_PATH)/System.map-$(KERNELRELEASE)
+
+define archhelp
+	echo '  install         - install kernel into $(INSTALL_PATH)'
+endef
-- 
1.6.5.2

