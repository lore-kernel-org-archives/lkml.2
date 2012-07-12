Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2GLXdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:33:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161792Ab2GLWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nico@fluxnic.net>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [ 084/187] ARM: Orion: Fix WDT compile for Dove and MV78xx0
Date: Thu, 12 Jul 2012 15:34:00 -0700
Message-Id: <20120712191530.189518440@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 1e0c1ce00d83834d03f4d8d039734ca4703298df upstream.

Commit 0fa1f0609a0c1fe8b2be3c0089a2cb48f7fda521 (ARM: Orion: Fix
Virtual/Physical mixup with watchdog) broke the Dove & MV78xx0
build. Although these two SoC don't use the watchdog, the shared
platform code still needs to build. Add the necessary defines.

Reported-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-dove/include/mach/bridge-regs.h    |    1 +
 arch/arm/mach-dove/include/mach/dove.h           |    1 +
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h |    1 +
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h     |    2 ++
 4 files changed, 5 insertions(+)

--- a/arch/arm/mach-dove/include/mach/bridge-regs.h
+++ b/arch/arm/mach-dove/include/mach/bridge-regs.h
@@ -50,5 +50,6 @@
 #define POWER_MANAGEMENT	(BRIDGE_VIRT_BASE | 0x011c)
 
 #define TIMER_VIRT_BASE		(BRIDGE_VIRT_BASE | 0x0300)
+#define TIMER_PHYS_BASE         (BRIDGE_PHYS_BASE | 0x0300)
 
 #endif
--- a/arch/arm/mach-dove/include/mach/dove.h
+++ b/arch/arm/mach-dove/include/mach/dove.h
@@ -78,6 +78,7 @@
 
 /* North-South Bridge */
 #define BRIDGE_VIRT_BASE	(DOVE_SB_REGS_VIRT_BASE | 0x20000)
+#define BRIDGE_PHYS_BASE	(DOVE_SB_REGS_PHYS_BASE | 0x20000)
 
 /* Cryptographic Engine */
 #define DOVE_CRYPT_PHYS_BASE	(DOVE_SB_REGS_PHYS_BASE | 0x30000)
--- a/arch/arm/mach-mv78xx0/include/mach/bridge-regs.h
+++ b/arch/arm/mach-mv78xx0/include/mach/bridge-regs.h
@@ -31,5 +31,6 @@
 #define IRQ_MASK_HIGH_OFF	0x0014
 
 #define TIMER_VIRT_BASE		(BRIDGE_VIRT_BASE | 0x0300)
+#define TIMER_PHYS_BASE		(BRIDGE_PHYS_BASE | 0x0300)
 
 #endif
--- a/arch/arm/mach-mv78xx0/include/mach/mv78xx0.h
+++ b/arch/arm/mach-mv78xx0/include/mach/mv78xx0.h
@@ -42,6 +42,7 @@
 #define MV78XX0_CORE0_REGS_PHYS_BASE	0xf1020000
 #define MV78XX0_CORE1_REGS_PHYS_BASE	0xf1024000
 #define MV78XX0_CORE_REGS_VIRT_BASE	0xfe400000
+#define MV78XX0_CORE_REGS_PHYS_BASE	0xfe400000
 #define MV78XX0_CORE_REGS_SIZE		SZ_16K
 
 #define MV78XX0_PCIE_IO_PHYS_BASE(i)	(0xf0800000 + ((i) << 20))
@@ -59,6 +60,7 @@
  * Core-specific peripheral registers.
  */
 #define BRIDGE_VIRT_BASE	(MV78XX0_CORE_REGS_VIRT_BASE)
+#define BRIDGE_PHYS_BASE	(MV78XX0_CORE_REGS_PHYS_BASE)
 
 /*
  * Register Map


