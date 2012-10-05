Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2JEO4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab2JEOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:55:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 13/16] ARM: be really quiet when building with 'make -s'
Date: Fri,  5 Oct 2012 16:55:27 +0200
Message-Id: <1349448930-23976-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ftXxDaJp4PN0ddyAoNt7sOaXXXWhtkNOxo0xfdoJP2k
 gpWyxov58UW8Mx4br9Oik8ult3G8IZhzfqUGUM+8DsQ14Womg2
 drFrbc6cnfvDVi74KyLdiNyEXOoHaR4y4TTvf2xgPTlwK1L0pB
 9IZ1tyD8bRw2a8l5pvQv+K/M5a+7octjTFHNNHog/NFIC5JJRV
 I249/Yr5AeNyrtqddMLIP97fxxki+ZHB9ztDo1If7fQ4ZlxnFY
 bTaQAU89dYjZsTS5Ffb6meJYOJtuBCywgZ4oylFjXh62v+VaIQ
 oMAVqUOqUDPDLCZNEFvG/eryi2ikasvXXyeZftthji//q647gI
 sJ69Kojqt8ZIXmuQxjDsPZgXDBJKTdWlD2c29bXjsuedDrphcf
 0UTs6vFZsoUOxjjTpivHwNtImIOrQvYD9o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we want the kernel build process to only print messages
on errors, e.g. in automated build testing. This uses the "kecho"
macro that the build system provides to hide a few informational
messages. Nothing changes for a regular "make" or "make V=1".

Without this patch, building any ARM kernel results in:

  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 arch/arm/boot/Makefile  |   10 +++++-----
 arch/arm/tools/Makefile |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index c877087..89680f2 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -31,7 +31,7 @@ ifeq ($(CONFIG_XIP_KERNEL),y)
 
 $(obj)/xipImage: vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
+	$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
 
 $(obj)/Image $(obj)/zImage: FORCE
 	@echo 'Kernel configured for XIP (CONFIG_XIP_KERNEL=y)'
@@ -46,14 +46,14 @@ $(obj)/xipImage: FORCE
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 $(obj)/compressed/vmlinux: $(obj)/Image FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
 $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 endif
 
@@ -88,7 +88,7 @@ fi
 $(obj)/uImage:	$(obj)/zImage FORCE
 	@$(check_for_multiple_loadaddr)
 	$(call if_changed,uimage)
-	@echo '  Image $@ is ready'
+	$(kecho) '  Image $@ is ready'
 
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
@@ -96,7 +96,7 @@ $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 
 $(obj)/bootpImage: $(obj)/bootp/bootp FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 PHONY += initrd FORCE
 initrd:
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 635cb18..cd60a81 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -5,6 +5,6 @@
 #
 
 include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
-	@echo '  Generating $@'
+	$(kecho) '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
-- 
1.7.10

