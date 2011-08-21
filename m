Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1HUFJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 01:09:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1HUFJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 01:09:17 -0400
Subject: [PATCH] ARM: mach-davinci: Select PHYLIB for ARCH_DAVINCI_DM644x
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 13:09:08 +0800
Message-ID: <1313903348.25059.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call phy_register_fixup_for_uid in davinci_evm_init, thus we need 
select PHYLIB to fix below build error: (with "make davinci_all_defconfig")

  LD      .tmp_vmlinux1
arch/arm/mach-davinci/built-in.o: In function `davinci_phy_fixup':
pm.c:(.text+0x35b8): undefined reference to `mdiobus_read'
pm.c:(.text+0x35d4): undefined reference to `mdiobus_write'
arch/arm/mach-davinci/built-in.o: In function `davinci_evm_init':
pm.c:(.init.text+0x237c): undefined reference to `phy_register_fixup_for_uid'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-davinci/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index c0deaca..029ec46b 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -18,6 +18,7 @@ config ARCH_DAVINCI_DM644x
 	bool "DaVinci 644x based system"
 	select AINTC
 	select ARCH_DAVINCI_DMx
+	select PHYLIB
 
 config ARCH_DAVINCI_DM355
 	bool "DaVinci 355 based system"
-- 
1.7.4.1



