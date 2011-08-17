Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1HQG3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:29:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64768 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1HQG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:29:12 -0400
Subject: [PATCH] ARM: Footbridge: select CLKEVT_I8253 for ARCH_NETWINDER
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 14:29:03 +0800
Message-ID: <1313562543.2024.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8560a6cfc9818edde1fd8677961714b264ffa03d
"arm: Footbridge: Use common i8253 clockevent",
ARCH_NETWINDER nees to select CLKEVT_I8253.

This patch fixes below build error with "make netwinder_defconfig".

  LD      .tmp_vmlinux1
arch/arm/mach-footbridge/built-in.o: In function `isa_timer_init':
isa-rtc.c:(.init.text+0x12c8): undefined reference to `clockevent_i8253_init'
isa-rtc.c:(.init.text+0x12d0): undefined reference to `i8253_clockevent'
arch/arm/mach-footbridge/built-in.o:(.data+0x198): undefined reference to `i8253_clockevent'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-footbridge/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index dc26fff..c8e7afc 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -62,6 +62,7 @@ config ARCH_EBSA285_HOST
 config ARCH_NETWINDER
 	bool "NetWinder"
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
-- 
1.7.4.1



